return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
	-- Ensure termguicolors is enabled before loading the plugin
	vim.opt.termguicolors = true

	require("bufferline").setup({
	  options = {
		offsets = {
		  {
			filetype = "NvimTree",         -- The filetype of your sidebar plugin
			text = "File Explorer",        -- Text to display over the sidebar panel
			text_align = "left",           -- Alignment of the text ("left" | "center" | "right")
			separator = true,              -- Adds a clean border line matching your window split
		  },
		},

		mode = "buffers", -- "buffers" or "tabs"
		separator_style = "slant", -- options: "slant" | "slope" | "thick" | "thin"
		always_show_bufferline = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		diagnostics = "nvim_lsp", -- displays LSP error count markers on tabs
	  }
	})
  end
}
