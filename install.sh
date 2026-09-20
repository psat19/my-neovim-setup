#!/usr/bin/env bash
#
# install.sh - set up the "govim" Neovim profile on a fresh Ubuntu/WSL machine.
#
# Usage:
#   git clone <repo> ~/.config/govim
#   ~/.config/govim/install.sh [--git-editor]
#
# Options:
#   --git-editor   Overwrite git's global core.editor with govim. Without this
#                  flag core.editor is only set when it is currently unset.
#   -h, --help     Show this help.
#
# Safe to re-run: every step checks before it changes anything.
# Versions can be overridden, e.g. NVIM_VERSION=0.12.6 ./install.sh

set -euo pipefail

NVIM_VERSION="${NVIM_VERSION:-0.12.5}"
GO_VERSION="${GO_VERSION:-1.27.1}"
STYLUA_VERSION="${STYLUA_VERSION:-2.5.2}"
NVIM_MIN_VERSION="0.11"   # the config needs vim.lsp.config / vim.lsp.enable

APPNAME="govim"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/$APPNAME"
GIT_EDITOR_CMD="env NVIM_APPNAME=$APPNAME nvim"
ALIAS_LINE="alias $APPNAME='NVIM_APPNAME=$APPNAME nvim'"

FORCE_GIT_EDITOR=0

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
skip() { printf '\033[1;32m ok\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror\033[0m %s\n' "$*" >&2; exit 1; }

for arg in "$@"; do
  case "$arg" in
    --git-editor) FORCE_GIT_EDITOR=1 ;;
    -h|--help) sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown option: $arg (try --help)" ;;
  esac
done

SUDO=""
[ "$(id -u)" -eq 0 ] || SUDO="sudo"

# Append a line to a file unless a grep -E pattern already matches it.
append_once() { # file pattern line
  touch "$1"
  grep -qE "$2" "$1" || printf '%s\n' "$3" >> "$1"
}

# --------------------------------------------------------------------------
# 0. Preflight
# --------------------------------------------------------------------------
[ "$(uname -s)" = "Linux" ]   || die "Linux only"
[ "$(uname -m)" = "x86_64" ]  || die "x86_64 only (got $(uname -m))"
command -v apt-get >/dev/null || die "apt-get not found; this script targets Ubuntu/Debian"
[ -f "$CONFIG_DIR/init.lua" ] || die "config not found at $CONFIG_DIR - clone the repo there first"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

export PATH="/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin:$PATH"

# --------------------------------------------------------------------------
# 1. apt packages
# --------------------------------------------------------------------------
log "System packages"
PKGS=(git build-essential curl tar unzip ripgrep ca-certificates)
MISSING=()
for p in "${PKGS[@]}"; do
  dpkg -s "$p" >/dev/null 2>&1 || MISSING+=("$p")
done
if [ "${#MISSING[@]}" -gt 0 ]; then
  $SUDO apt-get update
  $SUDO apt-get install -y "${MISSING[@]}"
else
  skip "all present"
fi

# --------------------------------------------------------------------------
# 2. Neovim
# --------------------------------------------------------------------------
log "Neovim >= $NVIM_MIN_VERSION"
nvim_installed_version() {
  command -v nvim >/dev/null || return 1
  nvim --version | sed -n '1s/^NVIM v\([0-9.]*\).*/\1/p'
}
CUR_NVIM="$(nvim_installed_version || true)"
if [ -n "$CUR_NVIM" ] && [ "$(printf '%s\n%s\n' "$NVIM_MIN_VERSION" "$CUR_NVIM" | sort -V | head -1)" = "$NVIM_MIN_VERSION" ]; then
  skip "found $CUR_NVIM"
else
  log "Installing Neovim $NVIM_VERSION (found: ${CUR_NVIM:-none})"
  curl -fsSL -o "$TMP/nvim.tar.gz" \
    "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
  $SUDO rm -rf /opt/nvim-linux-x86_64
  $SUDO tar -C /opt -xzf "$TMP/nvim.tar.gz"
  $SUDO ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  hash -r
fi

# --------------------------------------------------------------------------
# 3. Go  (go.nvim's build step then installs gopls, goimports, gofumpt, dlv)
# --------------------------------------------------------------------------
log "Go"
if command -v go >/dev/null; then
  skip "found $(go version | awk '{print $3}')"
else
  log "Installing Go $GO_VERSION"
  curl -fsSL -o "$TMP/go.tar.gz" "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
  $SUDO rm -rf /usr/local/go
  $SUDO tar -C /usr/local -xzf "$TMP/go.tar.gz"
  hash -r
fi

# --------------------------------------------------------------------------
# 4. stylua  (Lua formatter used by conform.nvim)
# --------------------------------------------------------------------------
log "stylua"
if command -v stylua >/dev/null; then
  skip "found $(stylua --version)"
else
  log "Installing stylua $STYLUA_VERSION"
  curl -fsSL -o "$TMP/stylua.zip" \
    "https://github.com/JohnnyMorganz/StyLua/releases/download/v${STYLUA_VERSION}/stylua-linux-x86_64.zip"
  unzip -oq "$TMP/stylua.zip" -d "$TMP"
  install -Dm755 "$TMP/stylua" "$HOME/.local/bin/stylua"
fi

# --------------------------------------------------------------------------
# 5. Claude Code CLI  (used by <leader>cc)
# --------------------------------------------------------------------------
log "Claude Code CLI"
if command -v claude >/dev/null; then
  skip "found $(claude --version 2>/dev/null | head -1)"
else
  curl -fsSL https://claude.ai/install.sh | bash
  hash -r
  CLAUDE_NEEDS_LOGIN=1
fi

# --------------------------------------------------------------------------
# 6. Shell config: PATH + govim alias
# --------------------------------------------------------------------------
log "Shell config"
append_once "$HOME/.bashrc" '/usr/local/go/bin' 'export PATH=$PATH:/usr/local/go/bin'
append_once "$HOME/.bashrc" 'go env GOPATH' 'export PATH=$PATH:$(go env GOPATH)/bin'
if ! grep -qE '\.local/bin' "$HOME/.bashrc" "$HOME/.profile" 2>/dev/null; then
  append_once "$HOME/.bashrc" '\.local/bin' 'export PATH="$HOME/.local/bin:$PATH"'
fi

append_once "$HOME/.bash_aliases" "^alias $APPNAME=" "$ALIAS_LINE"
grep -q 'bash_aliases' "$HOME/.bashrc" \
  || warn "~/.bashrc does not source ~/.bash_aliases - add: [ -f ~/.bash_aliases ] && . ~/.bash_aliases"

# --------------------------------------------------------------------------
# 7. git editor
# --------------------------------------------------------------------------
log "git core.editor"
CUR_EDITOR="$(git config --global core.editor || true)"
if [ "$CUR_EDITOR" = "$GIT_EDITOR_CMD" ]; then
  skip "already set"
elif [ -z "$CUR_EDITOR" ] || [ "$FORCE_GIT_EDITOR" -eq 1 ]; then
  git config --global core.editor "$GIT_EDITOR_CMD"
  skip "set to: $GIT_EDITOR_CMD"
else
  warn "core.editor is already '$CUR_EDITOR' - left unchanged (re-run with --git-editor to overwrite)"
fi

# --------------------------------------------------------------------------
# 8. Plugins
#    `Lazy! restore` clones missing plugins and checks out the commits pinned in
#    lazy-lock.json. go.nvim's build step installs gopls/goimports/gofumpt/dlv.
# --------------------------------------------------------------------------
log "Neovim plugins (lockfile versions)"
NVIM_APPNAME="$APPNAME" nvim --headless "+Lazy! restore" +qa 2>&1 | tail -n 5 || true

log "Treesitter parsers"
NVIM_APPNAME="$APPNAME" nvim --headless \
  "+Lazy! load nvim-treesitter" \
  "+lua require('nvim-treesitter.install').ensure_installed_sync(require('nvim-treesitter.configs').get_ensure_installed_parsers())" \
  +qa 2>&1 | tail -n 5 || true

# --------------------------------------------------------------------------
# Done
# --------------------------------------------------------------------------
echo
log "Done. Open a new shell (or: source ~/.bashrc) and run: $APPNAME"
if [ "${CLAUDE_NEEDS_LOGIN:-0}" -eq 1 ]; then
  echo "    Claude Code was just installed - run 'claude' once to log in."
fi
echo "    If you use Windows Terminal, set a Nerd Font there so icons render."
