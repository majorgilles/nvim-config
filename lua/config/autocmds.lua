-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-reload files changed externally (e.g. by Claude Code)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})
vim.o.updatetime = 300

-- Poll for file changes even when Neovim doesn't have focus
local checktime_timer = vim.uv.new_timer()
checktime_timer:start(1000, 1000, vim.schedule_wrap(function()
  if vim.fn.getcmdwintype() == "" then
    vim.cmd("checktime")
  end
end))
