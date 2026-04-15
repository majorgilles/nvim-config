# Neovim Configuration

## Adding Plugins (LazyVim)

Reference: https://www.lazyvim.org/configuration/plugins

Plugins are added as specs in files under `lua/plugins/*.lua`. You can use one file per plugin or group related specs together.

### Add a plugin

```lua
return {
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      position = "right",
    },
  },
}
```

### Disable a plugin

```lua
return {
  { "folke/trouble.nvim", enabled = false },
}
```

### Customize a plugin's options

LazyVim merges custom specs with defaults:

- **cmd, event, ft, keys, dependencies** — extended (added to existing values)
- **opts** — deep-merged with defaults
- **Everything else** — overrides defaults

You can pass a table or a function for `opts`:

```lua
return {
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
```

### Manage keymaps

Disable a keymap with `false`, override by matching `lhs`, or return a function to replace all keymaps:

```lua
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>/", false },                                    -- disable
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" }, -- override
  },
}
```

When disabling keymaps, match the exact mode:

```lua
return {
  "folke/flash.nvim",
  keys = {
    { "s", mode = { "n", "x", "o" }, false },
  },
}
```

Replace all keymaps by returning a function:

```lua
return {
  "nvim-telescope/telescope.nvim",
  keys = function()
    return {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    }
  end,
}
```
