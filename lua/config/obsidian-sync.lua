local vault_path = "/mnt/c/Users/sprat/Documents/ObsidianVault"

local function run(args)
  return vim.system(args, { cwd = vault_path, text = true }):wait()
end

local function unsaved_vault_buffers()
  local prefix = vault_path .. "/"
  local dirty = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:sub(1, #prefix) == prefix then
        table.insert(dirty, name:sub(#prefix + 1))
      end
    end
  end
  return dirty
end

local function sync_vault()
  local dirty = unsaved_vault_buffers()
  if #dirty > 0 then
    local msg = "Unsaved changes won't be synced:\n  " .. table.concat(dirty, "\n  ")
    local choice = vim.fn.confirm(msg, "&Save all and sync\n&Sync anyway\n&Cancel", 3)
    if choice == 0 or choice == 3 then
      return
    elseif choice == 1 then
      vim.cmd("wa")
    end
  end

  local status = run({ "git", "status", "--porcelain" })
  if status.stdout == nil or status.stdout == "" then
    vim.notify("Vault has nothing to sync", vim.log.levels.INFO)
    return
  end

  local confirm_msg = "Sync vault to remote?\n\n" .. status.stdout
  if vim.fn.confirm(confirm_msg, "&Sync\n&Cancel", 2) ~= 1 then
    return
  end

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
