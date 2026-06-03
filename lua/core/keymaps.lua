local map = vim.keymap.set

-- ── Config ────────────────────────────────────────────────────────────────────
map('n', '<Leader>vr', '<cmd>source $MYVIMRC<CR>', { desc = 'Reload config' })

-- ── LSP ───────────────────────────────────────────────────────────────────────
-- (LSP on_attach keymaps are set per-buffer in plugins/lsp.lua)
map('n', '<Leader>L', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- ── Buffers ───────────────────────────────────────────────────────────────────
map('n', '<C-Right>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<C-Left>',  '<cmd>bprev<CR>', { desc = 'Prev buffer' })

-- ── Window navigation (Alt + arrow) ──────────────────────────────────────────
map('n', '<M-Down>',  '<C-W>j',    { desc = 'Window down' })
map('n', '<M-Up>',    '<C-W>k',    { desc = 'Window up' })
map('n', '<M-Right>', '<C-W>l',    { desc = 'Window right' })
map('n', '<M-Left>',  '<C-W>h',    { desc = 'Window left' })
map('n', '<Leader>s', '<C-w><C-x>', { desc = 'Swap windows' })

-- ── File utilities ────────────────────────────────────────────────────────────
map('n', '<Leader>sf', function() print(vim.fn.expand('%:p')) end, { desc = 'Show file path' })
map('n', '<C-A>',      'ggVG',                                     { desc = 'Select all' })
map('',  '<F7>',       'gg=G<C-o><C-o>',                          { desc = 'Re-indent file' })
map('n', '<Leader>v',  '"+gP',                                     { desc = 'Paste from clipboard' })

-- Insert date + section divider at cursor
map('n', '<F12>', function()
  vim.api.nvim_put({ os.date('%a, %d %b %Y'), '################' }, 'l', true, true)
end, { desc = 'Insert date header' })

-- ── Navigation / tools ────────────────────────────────────────────────────────
map('n', 'T',          '<cmd>terminal<CR>',       { desc = 'Open terminal' })
map('n', '<F12>f',     '<cmd>silent !firefox %<CR>', { desc = 'Open in Firefox' })
map('n', '<Leader>nf', '<cmd>NvimTreeOpen<CR>',   { desc = 'Open file tree' })

-- Quickfix list navigation
map('n', '[', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
map('n', ']', '<cmd>cprev<CR>', { desc = 'Prev quickfix item' })

-- ── Telescope shortcuts (global, work because lazy = false) ───────────────────
map('n', '<M-b>', '<cmd>Telescope buffers<CR>',               { desc = 'Telescope: buffers' })
map('n', '<M-e>', '<cmd>Telescope diagnostics<CR>',           { desc = 'Telescope: diagnostics' })
map('n', '<M-f>', '<cmd>Telescope find_files<CR>',            { desc = 'Telescope: find files' })
map('n', '<M-g>', '<cmd>Telescope live_grep<CR>',             { desc = 'Telescope: live grep' })
map('n', '<M-i>', '<cmd>Telescope lsp_incoming_calls<CR>',    { desc = 'Telescope: incoming calls' })
map('n', '<M-o>', '<cmd>Telescope lsp_outgoing_calls<CR>',    { desc = 'Telescope: outgoing calls' })
map('n', '<M-q>', '<cmd>Telescope quickfix<CR>',              { desc = 'Telescope: quickfix' })
map('n', '<M-r>', '<cmd>Telescope lsp_references<CR>',        { desc = 'Telescope: references' })
map('n', '<M-s>', '<cmd>Telescope lsp_document_symbols<CR>',  { desc = 'Telescope: doc symbols' })
map('n', '<M-w>', '<cmd>Telescope lsp_workspace_symbols<CR>', { desc = 'Telescope: workspace symbols' })
