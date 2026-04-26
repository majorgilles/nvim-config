return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Using basedpyright instead of pyright because vanilla pyright's
        -- workspace/symbol search only indexes already-opened files; basedpyright
        -- maintains a full workspace index (needed for reliable symbol search
        -- across our monorepo layout with extraPaths in pyrightconfig.json).
        basedpyright = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "python" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "basedpyright")
    end,
  },
}
