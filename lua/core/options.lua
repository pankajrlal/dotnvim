local opt = vim.opt

-- Appearance
opt.termguicolors = true
opt.background    = 'dark'
opt.number        = true
opt.cursorline    = true
opt.signcolumn    = 'yes'

-- Indentation
opt.tabstop     = 4
opt.softtabstop = 4
opt.shiftwidth  = 4
opt.expandtab   = true

-- Search
opt.ignorecase = true
opt.hlsearch   = true

-- Editing behaviour
opt.hidden        = true
opt.splitright    = true
opt.updatetime    = 300
opt.completeopt   = 'menu,menuone,noinsert,noselect,popup'
opt.formatoptions = 'crqto'
opt.encoding      = 'utf-8'

-- Disable netrw (nvim-tree replaces it)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- Vimwiki
vim.g.vimwiki_list = {{
  path             = vim.env.HOME .. '/vimwiki',
  template_path    = vim.fn.stdpath('config') .. '/',
  template_default = 'default',
  template_ext     = '.tpl',
}}

-- NERDCommenter
vim.g.NERDSpaceDelims            = 1
vim.g.NERDCompactSexyComs        = 1
vim.g.NERDDefaultAlign           = 'left'
vim.g.NERDAltDelims_java         = 1
vim.g.NERDCustomDelimiters       = { c = { left = '/**', right = '*/' } }
vim.g.NERDCommentEmptyLines      = 1
vim.g.NERDTrimTrailingWhitespace = 1
vim.g.NERDToggleCheckAllLines    = 1

-- FZF layout (kept for compatibility)
vim.g.fzf_layout = { down = '~25%' }
