return {
  -- ── Fuzzy finder ────────────────────────────────────────────────────────────
  {
    'nvim-telescope/telescope.nvim',
    branch       = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-v>'] = require('telescope.actions').select_vertical,
              ['<C-x>'] = require('telescope.actions').select_horizontal,
            },
          },
        },
        extensions = {
          media_files = {
            filetypes = { 'png', 'webp', 'jpg', 'jpeg' },
            find_cmd  = 'rg',
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({}),
          },
        },
      })
      telescope.load_extension('media_files')
      telescope.load_extension('ui-select')
    end,
  },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'nvim-telescope/telescope-media-files.nvim' },

  -- ── File tree ────────────────────────────────────────────────────────────────
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local api = require('nvim-tree.api')

      local function on_attach(bufnr)
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        -- Replace C-v / C-x defaults with Leader versions to avoid conflicts
        vim.keymap.del('n', '<C-V>', { buffer = bufnr })
        vim.keymap.del('n', '<C-X>', { buffer = bufnr })
        vim.keymap.set('n', '<Leader>x', api.node.open.horizontal, opts('Open: Horizontal Split'))
        vim.keymap.set('n', '<Leader>y', api.node.open.vertical,   opts('Open: Vertical Split'))
      end

      require('nvim-tree').setup({
        diagnostics = { enable = true },
        sort        = { sorter = 'case_sensitive' },
        view        = { width = 50 },
        renderer    = { group_empty = true },
        filters     = { dotfiles = true },
        on_attach   = on_attach,
      })
    end,
  },

  -- ── Editing helpers ──────────────────────────────────────────────────────────
  {
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup({}) end,
  },
  { 'tpope/vim-surround' },
  { 'alvan/vim-closetag' },
  { 'AndrewRadev/splitjoin.vim' },
  { 'preservim/nerdcommenter' }, -- globals configured in core/options.lua

  -- ── Code outline (symbols sidebar) ──────────────────────────────────────────
  {
    'stevearc/aerial.nvim',
    config = function()
      require('aerial').setup({
        on_attach = function(bufnr)
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Aerial: prev symbol' })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Aerial: next symbol' })
          vim.keymap.set('n', '<Leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Aerial: toggle' })
        end,
      })
    end,
  },

  -- ── Auto-formatting on save ──────────────────────────────────────────────────
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua        = { 'stylua' },
          python     = { 'isort', 'black' },
          rust       = { 'rustfmt', lsp_format = 'fallback' },
          javascript = { 'prettierd', 'prettier', stop_after_first = false },
        },
      })
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern  = '*',
        callback = function(args)
          require('conform').format({ bufnr = args.buf })
        end,
      })
    end,
  },

  -- ── Code-action preview with diff ───────────────────────────────────────────
  {
    'aznhe21/actions-preview.nvim',
    config = function()
      require('actions-preview').setup({
        diff    = { ctxlen = 3 },
        backend = { 'telescope', 'nui' },
        telescope = vim.tbl_extend('force',
          require('telescope.themes').get_dropdown(),
          { make_value = nil, make_make_display = nil }
        ),
        nui = {
          dir    = 'col',
          keymap = nil,
          layout = {
            position   = '50%',
            size       = { width = '60%', height = '90%' },
            min_width  = 40,
            min_height = 10,
            relative   = 'editor',
          },
          preview = { size = '60%', border = { style = 'rounded', padding = { 0, 1 } } },
          select  = { size = '40%', border = { style = 'rounded', padding = { 0, 1 } } },
        },
      })
      vim.keymap.set({ 'v', 'n' }, '<Leader>b',
        require('actions-preview').code_actions,
        { desc = 'Code actions (preview)' }
      )
    end,
  },
}
