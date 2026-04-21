return {
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {
      window = {
        position = "vertical botright",
        split_ratio = 0.30,
      },
      keymaps = {
        toggle = {
          normal = "<leader>ac",
          terminal = "<leader>ac",
          variants = {
            continue = "<leader>aC",
            resume = "<leader>ar",
            verbose = "<leader>aV",
          },
        },
      },
    },
  },
}
