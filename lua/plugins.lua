-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Git
  { 'lewis6991/gitsigns.nvim' },
  { 'tpope/vim-fugitive' },
  { 'sindrets/diffview.nvim' },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'nvim-telescope/telescope-media-files.nvim' },

  -- Themes
  { 'ellisonleao/gruvbox.nvim' },
  { 'catppuccin/nvim', name = 'catppuccin' },

  -- Icons & UI
  { 'nvim-tree/nvim-web-devicons' },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- LSP
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' },

  -- Completion
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'hrsh7th/nvim-cmp' },
  { 'saadparwaiz1/cmp_luasnip' },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
  },
  { 'rafamadriz/friendly-snippets' },

  -- File tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Editing helpers
  { 'tpope/vim-surround' },
  { 'alvan/vim-closetag' },
  { 'preservim/nerdcommenter' },
  { 'windwp/nvim-autopairs' },
  { 'AndrewRadev/splitjoin.vim' },

  -- Documentation generator
  { 'kkoomen/vim-doge', build = ':call doge#install()' },

  -- Code tools
  { 'metakirby5/codi.vim' },
  { 'stevearc/aerial.nvim' },
  { 'stevearc/conform.nvim' },

  -- Code actions preview
  {
    'aznhe21/actions-preview.nvim',
    -- keymap is set in customizations.lua; full setup in config.lua
  },

  -- DAP (Debugging)
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-neotest/nvim-nio',
    },
  },

  -- Breadcrumbs
  {
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('nvim-navic').setup({ highlight = true })
    end,
  },

  -- AI / Code assistance
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('codecompanion').setup()
    end,
  },
  {
    'greggh/claude-code.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- full setup in config.lua
  },
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
      { 'Saghen/blink.cmp', optional = true },
    },
    -- full setup in config.lua
  },

}, {
  -- Load all plugins eagerly on startup, matching packer's default behaviour.
  -- Lazy-load optimisation can be added incrementally later.
  defaults = { lazy = false },
})
