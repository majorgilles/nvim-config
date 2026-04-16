return {
  {
    "folke/snacks.nvim",
    opts = {
      statuscolumn = {
        left = { "sign" }, -- removed "mark" so marks don't interfere with breakpoint signs
        right = { "fold", "git" },
      },
      picker = {
        actions = {
          yank_absolute_path = function(_, item)
            if item then
              local path = Snacks.picker.util.path(item)
              vim.fn.setreg("+", path)
              Snacks.notify("Copied absolute path:\n" .. path, { title = "Snacks Picker" })
            end
          end,
          yank_relative_path = function(picker, item)
            if item then
              local path = Snacks.picker.util.path(item)
              local cwd = picker:cwd() or vim.fn.getcwd()
              local relative = vim.fn.fnamemodify(path, ":." .. cwd) or path
              -- fallback: manually strip cwd prefix
              if relative == path and path:sub(1, #cwd) == cwd then
                relative = path:sub(#cwd + 2) -- +2 to skip trailing /
              end
              vim.fn.setreg("+", relative)
              Snacks.notify("Copied relative path:\n" .. relative, { title = "Snacks Picker" })
            end
          end,
        },
        win = {
          list = {
            keys = {
              ["gy"] = "yank_relative_path",
              ["gY"] = "yank_absolute_path",
            },
          },
        },
      },
    },
  },
}
