
-- Set completeopt to have a better completion experience. This was suggestged by nvim github copilot chat plugin
vim.o.completeopt = "menu,menuone,noinsert,noselect,popup"


vim.cmd([[nnoremap <Leader>vr :source ~/.config/nvim/init.vim <CR>]])
vim.cmd([[let mapleader = ' ']])
vim.cmd ([[nnoremap <Leader>L :lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>]])

vim.keymap.set({ "v", "n" }, "<Leader>b", require("actions-preview").code_actions)

vim.cmd[[
" Use Tab to expand and jump through snippets
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
imap <silent><expr> <C-f> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<C-f>'
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

" Use Shift-Tab to jump backwards through snippets
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'

]]

vim.api.nvim_set_keymap('n', '<Leader>ds', ':DapStepOver<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>di', ':DapStepInto<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>do', ':DapStepOut<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dt', ':DapToggleBreakpoint<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dc', ':DapContinue<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dx', ':DapStop<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dr', ':DapRestart<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dp', ':DapPause<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dl', ':DapToggleRepl<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>du', ':DapToggleUI<CR>', { noremap = true, silent = true })
