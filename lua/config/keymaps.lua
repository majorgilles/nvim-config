-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" })
