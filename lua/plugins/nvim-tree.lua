return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      require("nvim-tree").setup {
        view = {
          width = 20,
        },
        -- Move the tree cursor to the file in the active buffer (expanding folders)
        update_focused_file = {
          enable = true,
        },
        -- Highlight files that are open in a buffer
        renderer = {
          highlight_opened_files = "name",
        },
      }
      -- Make the opened-file highlight clearly visible
      vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { bold = true, underline = true, fg = "#e0af68" })
    end,
  },
}
