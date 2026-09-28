local vault_path = "/mnt/c/Users/sprat/Documents/ObsidianVault"

local function run(args)
  return vim.system(args, { cwd = vault_path, text = true }):wait()
end

local function sync_vault()
  run({ "git", "add", "-A" })

  if run({ "git", "diff", "--cached", "--quiet" }).code ~= 0 then
    local commit = run({ "git", "commit", "-m", "vault sync: " .. os.date("%Y-%m-%d %H:%M") })
    if commit.code ~= 0 then
      vim.notify("Vault commit failed:\n" .. (commit.stderr or ""), vim.log.levels.ERROR)
      return
    end
  end

  local pull = run({ "git", "pull", "--rebase", "--autostash" })
  if pull.code ~= 0 then
    vim.notify("Vault pull failed:\n" .. (pull.stderr or ""), vim.log.levels.ERROR)
    return
  end

  local push = run({ "git", "push" })
  if push.code ~= 0 then
    vim.notify("Vault push failed:\n" .. (push.stderr or ""), vim.log.levels.ERROR)
    return
  end

  vim.notify("Vault synced to remote", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("ObsidianVaultSync", sync_vault, {})
vim.keymap.set("n", "<leader>og", sync_vault, { desc = "Obsidian: sync vault to remote" })
