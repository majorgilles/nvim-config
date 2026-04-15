return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- Setup Python adapter (uses debugpy from project .venv)
      local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
      if vim.fn.executable(venv_python) == 1 then
        require("dap-python").setup(venv_python)
      end

      -- Auto open/close UI when debugging starts/stops
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Breakpoint signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "" })
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e06c75" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bg = "#2d3343" })

      -- Override snacks statuscolumn click handler to toggle breakpoints
      -- instead of only toggling folds
      local snacks_sc_ok, snacks_sc = pcall(require, "snacks.statuscolumn")
      if snacks_sc_ok then
        snacks_sc.click_fold = function()
          local pos = vim.fn.getmousepos()
          vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
          vim.api.nvim_win_call(pos.winid, function()
            if vim.fn.foldlevel(pos.line) > 0 then
              vim.cmd("normal! za")
            else
              dap.toggle_breakpoint()
            end
          end)
        end
      end

      -- Toggle breakpoint on double-click (fallback for non-statuscolumn areas)
      vim.keymap.set("n", "<2-LeftMouse>", function()
        local mouse = vim.fn.getmousepos()
        if mouse.screencol <= 6 then
          vim.api.nvim_win_set_cursor(mouse.winid, { mouse.line, 0 })
          dap.toggle_breakpoint()
        else
          vim.cmd("normal! <2-LeftMouse>")
        end
      end, { desc = "Toggle breakpoint (click gutter)" })

      -- Keybindings
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, { desc = "Conditional breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue / Start" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart" })
      vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle debug UI" })
      vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "Eval expression" })

      -- F-key shortcuts
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step out" })
    end,
  },
}
