return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "/mnt/c/Users/sprat/Documents/ObsidianVault",
        },
      },
      daily_notes = {
        folder = "daily",
      },
      completion = {
        nvim_cmp = false,
        blink = false,
      },
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "Obsidian: New note" },
      { "<leader>oo", "<cmd>ObsidianOpen<CR>", desc = "Obsidian: Open in app" },
      { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Obsidian: Search" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", desc = "Obsidian: Quick switch" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Obsidian: Backlinks" },
      { "<leader>ot", "<cmd>ObsidianToday<CR>", desc = "Obsidian: Today's note" },
      { "<leader>of", "<cmd>ObsidianFollowLink<CR>", desc = "Obsidian: Follow link" },
    },
  },
}
