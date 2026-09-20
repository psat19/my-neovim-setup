return {
  "ray-x/go.nvim",
  dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig" },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()',
  opts = {
    lsp_cfg = false,       -- we configure gopls ourselves above
    lsp_inlay_hints = { enable = false },
    trouble = false,
    luasnip = false,
    dap_debug = true,
  },
  keys = {
    { "<leader>gt", "<cmd>GoTestFunc<cr>", desc = "Test function" },
    { "<leader>gT", "<cmd>GoTestFile<cr>", desc = "Test file" },
    { "<leader>gc", "<cmd>GoCoverage<cr>", desc = "Coverage" },
    { "<leader>ge", "<cmd>GoIfErr<cr>", desc = "Insert if err" },
    { "<leader>gf", "<cmd>GoFillStruct<cr>", desc = "Fill struct" },
    { "<leader>gs", "<cmd>GoImpl<cr>", desc = "Implement interface" },
    { "<leader>ga", "<cmd>GoAddTag json<cr>", desc = "Add json tags" },
  },
}
