-- AI ghost-text completion for markdown only (Gemini via minuet-ai.nvim).
-- Needs GEMINI_API_KEY exported in the shell (key from aistudio.google.com).
return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "InsertEnter",
  config = function()
	require("minuet").setup({
	  provider = "gemini",
	  -- Increase to save free-tier quota
	  throttle = 300,
	  debounce = 150,
	  context_window = 1000,
	  n_completions = 1, -- default is 3, which triples the output to generate
	  provider_options = {
		gemini = {
		  model = "gemini-3.5-flash-lite",
		  api_key = "GEMINI_API_KEY", -- env var name, not the key itself
		  optional = {
			generationConfig = {
			  maxOutputTokens = 48,
			  thinkingConfig = { thinkingLevel = "minimal" },
			},
		  },
		},
	  },
	  virtualtext = {
		auto_trigger_ft = { "markdown" },
		show_on_completion_menu = false,
		keymap = {
		  accept = "<A-l>",
		  accept_line = "<A-;>",
		  prev = "<A-,>",
		  next = "<A-.>",
		  dismiss = "<A-e>",
		},
	  },
	})

	-- Accept the ghost text one word at a time. Minuet has no such action, so
	-- read the first word from its virtual-text extmark and insert it; minuet
	-- then trims the remaining suggestion as the typed text matches its start.
	vim.keymap.set("i", "<C-l>", function()
	  local vt = require("minuet.virtualtext")
	  if not vt.action.is_visible() then
		return
	  end
	  local mark = vim.api.nvim_buf_get_extmark_by_id(0, vt.ns_id, 1, { details = true })
	  local chunk = mark[3] and mark[3].virt_text and mark[3].virt_text[1]
	  local first_line = chunk and chunk[1] or ""
	  local word = first_line:match("^%s*%S+") or first_line
	  if word == "" then
		return
	  end
	  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { word })
	  vim.api.nvim_win_set_cursor(0, { row, col + #word })
	end, { desc = "[minuet] accept suggestion (word)" })
  end,
}
