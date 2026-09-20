return {
  { "folke/tokyonight.nvim", priority = 1000, config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end },
  { "nvim-lualine/lualine.nvim", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  { "stevearc/oil.nvim", opts = {}, keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent dir" } } },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols" },
    },
  },
}
