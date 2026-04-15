return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false,
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.30,
        -- Without fixbuf = false, snacks.nvim monitors which buffer is shown in the
        -- Claude terminal window. When you close a tab, Neovim briefly places the
        -- replacement buffer there, and snacks reacts by swapping buffers between
        -- windows and stealing focus — making all tabs jump to the terminal side.
        snacks_win_opts = {
          fixbuf = false,
        },
      },
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>aV", "<cmd>ClaudeCode --verbose<cr>", desc = "Verbose Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to context" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
    },
  },
}
