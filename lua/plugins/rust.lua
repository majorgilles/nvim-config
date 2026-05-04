return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    init = function()
      local codelldb_path = (function()
        if vim.fn.has("win32") == 1 then
          return vim.fn.expand("$LOCALAPPDATA") .. "/codelldb/extension/adapter/codelldb.exe"
        else
          return vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
        end
      end)()

      vim.g.rustaceanvim = {
        dap = {
          adapter = {
            type = "server",
            port = "${port}",
            executable = {
              command = codelldb_path,
              args = { "--port", "${port}" },
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>dR", "<cmd>RustLsp debuggables<cr>", desc = "Rust: pick debuggable", ft = "rust" },
      { "<leader>cR", "<cmd>RustLsp runnables<cr>", desc = "Rust: pick runnable", ft = "rust" },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
}
