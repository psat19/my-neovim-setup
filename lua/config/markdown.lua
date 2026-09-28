vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true   -- wrap at word boundaries, not mid-word
    vim.opt_local.breakindent = true -- keep wrapped lines indented under the paragraph
    vim.opt_local.showbreak = "↳ "   -- mark wrapped continuation lines
    vim.opt_local.conceallevel = 2   -- also what obsidian.nvim's syntax features want

    local map_opts = { buffer = args.buf, silent = true }
    vim.keymap.set("n", "j", "gj", map_opts)
    vim.keymap.set("n", "k", "gk", map_opts)
    vim.keymap.set("n", "0", "g0", map_opts)
    vim.keymap.set("n", "$", "g$", map_opts)
  end,
})
