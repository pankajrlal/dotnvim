-- Set leader first — before lazy so all plugin keymaps inherit it
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- Core: options, autocmds, keymaps (no plugin dependencies)
require('core.options')
require('core.autocmds')
require('core.keymaps')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- { import = 'plugins' } scans every file under lua/plugins/
require('lazy').setup({ { import = 'plugins' } }, {
  defaults = { lazy = false },
})
