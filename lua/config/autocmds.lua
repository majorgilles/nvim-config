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
vim.o.updatetime = 300

local function safe_checktime()
  -- Guard against running inside the cmdline-window or command mode, where :checktime is disallowed
  if vim.fn.getcmdwintype() ~= "" or vim.fn.mode() == "c" then
    return
  end
  pcall(vim.cmd, "checktime")
end

vim.api.nvim_create_autocmd({
  "FocusGained",
  "BufEnter",
  "BufWinEnter",
  "CursorHold",
  "CursorHoldI",
  "InsertLeave",
  "TermLeave",
}, {
  callback = safe_checktime,
})

-- When a buffer is reloaded from disk, force a clean LSP re-sync. Without this, pyright/tsserver
-- sometimes keep flagging errors for code that no longer exists on disk.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function(args)
    vim.notify(
      "Reloaded: " .. vim.fn.fnamemodify(args.file, ":~:."),
      vim.log.levels.INFO,
      { title = "autoread" }
    )
    -- Detach + reattach LSP clients so diagnostics don't lag behind the reload
    local bufnr = args.buf or vim.api.nvim_get_current_buf()
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
      pcall(vim.lsp.buf_detach_client, bufnr, client.id)
      pcall(vim.lsp.buf_attach_client, bufnr, client.id)
    end
  end,
})

-- Auto-save Session.vim on exit so tmux-resurrect can restore neovim sessions
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("mksession! Session.vim")
  end,
})

-- Poll for file changes even when Neovim doesn't have focus (e.g. while in the Claude Code terminal)
local checktime_timer = vim.uv.new_timer()
checktime_timer:start(1000, 1000, vim.schedule_wrap(safe_checktime))
