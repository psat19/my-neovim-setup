return {
  "greggh/claude-code.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
  },
  opts = {
    git = {
      use_git_root = false, -- use nvim's cwd instead of the git root
    },
    window = {
      position = "float",
      float = {
        width = "90%",
        height = "90%",
        row = "center",
        col = "center",
        relative = "editor",
        border = "double",
      },
    },
  },
}
