print("'Hello in go profile'")

require('config.lazy')
require("config.options")

vim.g.mapleader = "\\"

vim.opt.termguicolors = true

-- turn on line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"

-- keymaps fop executing a file.
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")

-- keymaps for enabling moving a particular line up and down using Alt + j/k
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { silent = true })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true })

-- keymaps for toggling file tree
local tree_toggle = function()
  require("nvim-tree.api").tree.toggle({
	path = "<args>",
	find_file = true,
	update_root = false,
	focus = true,
  })
end
vim.keymap.set('v', '<A-g>', tree_toggle, { silent = true })
vim.keymap.set('n', '<A-g>', tree_toggle, { silent = true })
vim.keymap.set('t', '<A-g>', tree_toggle, { silent = true })

-- keymaps for moving the screen up or down with the cursor always in the middle of the screen.
vim.keymap.set("n", "<C-j>", "jzz")
vim.keymap.set("n", "<C-k>", "kzz")
vim.keymap.set("n", "<C-down>", "jzz")
vim.keymap.set("n", "<C-up>", "kzz")

-- keymap to exit terminal mode
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

--keymap to do nothing when pressing - in normal mode
vim.keymap.set('n', '-', '<Nop>', { desc = 'do nothing for -' })

-- keymap to toggle height of the current window between max and min
local last_height = nil
local function toggle_min_height()
  local win = 0
  if last_height then
	vim.api.nvim_win_set_height(win, vim.o.lines)
	last_height = nil
  else
	last_height = vim.api.nvim_win_get_height(win)
	vim.api.nvim_win_set_height(win, 1)
  end
end

vim.keymap.set('n', '<space>t', toggle_min_height, { desc = 'toggle between the height of current window full and minimum' })

-- Go to the next or previous buffer tab
vim.keymap.set("n", "<space><Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<space><S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Buffer" })

-- Close the current buffer
vim.keymap.set("n", "<leader>bc", "<cmd>bdelete<cr>", { desc = "Close Buffer" })

-- keymap to replace <C-W> + direction to switch between windows
vim.keymap.set("n", "<space>wh", "<C-w>h", { desc = "Move to window to the left" })
vim.keymap.set("n", "<space>wj", "<C-w>j", { desc = "Move to window to the bottom" })
vim.keymap.set("n", "<space>wk", "<C-w>k", { desc = "Move to window to the top" })
vim.keymap.set("n", "<space>wl", "<C-w>l", { desc = "Move to window to the right" })

--keymap to set vim as known value for lua lsp
vim.lsp.config("lua_ls", {
  settings = {
	Lua = {
	  diagnostics = { globals = { "vim" } },
	},
  },
})

