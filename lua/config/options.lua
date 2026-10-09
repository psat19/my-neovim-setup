vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local o = vim.opt
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.expandtab = false        -- Go uses tabs
o.tabstop = 4
o.shiftwidth = 4
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.splitright = true
o.splitbelow = true
o.undofile = true
o.updatetime = 250
o.termguicolors = true
o.completeopt = "menu,menuone,noselect"
o.clipboard = "unnamedplus"

-- Treesitter-based folds (functions, methods, blocks), computed automatically
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevelstart = 99      -- open everything on load; use zM to fold all

vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  severity_sort = true,
  float = { border = "rounded", source = true },
})
