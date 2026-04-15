return {
  {
    "folke/snacks.nvim",
    opts = {
      statuscolumn = {
        left = { "sign" }, -- removed "mark" so marks don't interfere with breakpoint signs
        right = { "fold", "git" },
      },
    },
  },
}
