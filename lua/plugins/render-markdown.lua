return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons", -- needs a Nerd Font for the icons
  },
  opts = {
    file_types = { "markdown" },
  },
}
