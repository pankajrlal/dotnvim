return {
  -- Icons (shared dependency across many plugins)
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        color_icons = true,
        default     = true,
        strict      = true,
        override_by_filename = {
          ['.gitignore'] = { icon = '', color = '#f1502f', name = 'Gitignore' },
        },
        override_by_extension = {
          ['log'] = { icon = '', color = '#81e043', name = 'Log' },
        },
        override_by_operating_system = {
          ['apple'] = { icon = '', color = '#A2AAAD', cterm_color = '248', name = 'Apple' },
        },
      })
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled        = true,
          theme                = 'catppuccin-nvim',
          component_separators = { left = '|', right = '|' },
          section_separators   = { left = '*', right = '*' },
          disabled_filetypes   = { statusline = {}, winbar = {} },
          always_divide_middle = true,
          globalstatus         = false,
          refresh              = { statusline = 1000, tabline = 1000, winbar = 1000 },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            { 'filename', path = 4 },
            {
              'navic',
              cond = function()
                return package.loaded['nvim-navic']
                  and require('nvim-navic').is_available()
              end,
            },
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
        },
      })
    end,
  },

  -- Buffer tabs
  {
    'akinsho/bufferline.nvim',
    version      = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({})
    end,
  },

  -- LSP breadcrumbs in statusline
  {
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('nvim-navic').setup({ highlight = true })
    end,
  },
}
