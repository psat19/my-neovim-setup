return {
  "wr9dg17/essential-term.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("essential-term").setup({
      display_mode = "horizontal", -- or "vertical" or "float"
      size = 30,                   -- percentage of editor height/width
	  exit_term_mode_key = false
	})
  end,
  keys = {
	{ "<C-`>",  "<cmd>EssentialTermToggle<cr>", mode = { "n", "t" } },
	{ "<C-\\>", "<cmd>EssentialTermToggle<cr>", mode = { "n", "t" } },
	{ "<C-t>",  "<cmd>EssentialTermNew<cr>",    mode = { "n", "t" } },
	{ "<C-x>",  "<cmd>EssentialTermClose<cr>",  mode = { "n", "t" } },
	{ "<C-h>",  "<cmd>EssentialTermPrev<cr>",   mode = { "t" } },
	{ "<C-l>",  "<cmd>EssentialTermNext<cr>",   mode = { "t" } },
  },
}
