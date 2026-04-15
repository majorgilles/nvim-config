return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    ft = "python",
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run test file" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show output" },
      { "<leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Re-run last test" },
    },
    config = function()
      -- Set env vars for pytest (neotest-python doesn't support env option)
      vim.env.AWS_DEFAULT_REGION = vim.env.AWS_DEFAULT_REGION or "eu-west-1"
      vim.env.CURRENT_STAGE = vim.env.CURRENT_STAGE or "dev"
      vim.env.DJANGO_SETTINGS_MODULE = vim.env.DJANGO_SETTINGS_MODULE or "lizy_django.settings"
      vim.env.AWS_PROFILE = vim.env.AWS_PROFILE or "lizy_dev"
      vim.env.PYTHONDONTWRITEBYTECODE = vim.env.PYTHONDONTWRITEBYTECODE or "1"

      local neotest = require("neotest")
      neotest.setup({
        icons = {
          running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          passed = "✓",
          failed = "✗",
          unknown = "▶",
        },
        summary = {
          mappings = {
            run = { "r", "<2-LeftMouse>" },
            debug = "d",
            expand = { "<CR>", "<space>" },
            expand_all = "e",
            output = "o",
            jumpto = "i",
            stop = "u",
            short = "O",
            attach = "a",
            mark = "m",
            clear_marked = "M",
            run_marked = "R",
          },
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = true,
        },
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
            args = { "-v", "--reuse-db", "--no-migrations", "-p", "no:doctest", "-p", "no:catchlog" },
            python = vim.fn.getcwd() .. "/.venv/bin/python",
          }),
        },
      })

      -- Run nearest test on gutter click (sign column)
      vim.keymap.set("n", "<RightMouse>", function()
        local mouse = vim.fn.getmousepos()
        if mouse.screencol <= 4 then
          vim.api.nvim_win_set_cursor(mouse.winid, { mouse.line, 0 })
          neotest.run.run()
        else
          vim.cmd("normal! <RightMouse>")
        end
      end, { desc = "Run test (right-click gutter)" })
    end,
  },
}
