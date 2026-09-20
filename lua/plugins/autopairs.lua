return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,  -- use treesitter to be smarter about context (e.g. skip pairing inside strings/comments)
    fast_wrap = {},    -- enables <M-e> to wrap a selection in brackets/quotes
  },
}
