return {
  -- ── Package manager for LSP servers, linters, formatters ────────────────────
  {
    'williamboman/mason.nvim',
    config = function() require('mason').setup() end,
  },
  { 'williamboman/mason-lspconfig.nvim' },

  -- ── Completion sources ───────────────────────────────────────────────────────
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'rafamadriz/friendly-snippets' },

  -- ── Snippet engine ───────────────────────────────────────────────────────────
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build   = 'make install_jsregexp',
    config  = function()
      local ls = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()

      -- Expand snippet or jump to next placeholder; fall back to a real <Tab>
      vim.keymap.set({ 'i', 's' }, '<Tab>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        else
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false
          )
        end
      end, { silent = true, desc = 'LuaSnip: expand or jump forward' })

      -- C-f also jumps forward (insert mode)
      vim.keymap.set('i', '<C-f>', function()
        if ls.jumpable(1) then ls.jump(1) end
      end, { silent = true, desc = 'LuaSnip: jump forward' })

      -- Jump forward in select mode
      vim.keymap.set('s', '<Tab>', function()
        if ls.jumpable(1) then ls.jump(1) end
      end, { silent = true, desc = 'LuaSnip: jump forward (select)' })

      -- Jump backward
      vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
        if ls.jumpable(-1) then ls.jump(-1) end
      end, { silent = true, desc = 'LuaSnip: jump backward' })
    end,
  },

  -- ── Completion engine ────────────────────────────────────────────────────────
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp     = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>']     = cmp.mapping.scroll_docs(-4),
          ['<C-f>']     = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>']     = cmp.mapping.abort(),
          ['<CR>']      = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'luasnip' },
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
      })

      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({ { name = 'cmp_git' } }, { { name = 'buffer' } }),
      })
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } },
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
      })
    end,
  },

  -- ── LSP server configs ───────────────────────────────────────────────────────
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lsp_flags    = { debounce_text_changes = 150 }

      -- Keymaps and settings applied when an LSP attaches to a buffer
      local function on_attach(_, bufnr)
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local function opts(desc)
          return { noremap = true, silent = false, buffer = bufnr, desc = desc }
        end
        local tb = require('telescope.builtin')

        vim.keymap.set('n', '<Leader>gD', vim.lsp.buf.declaration,       opts('Declaration'))
        vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition,        opts('Definition'))
        vim.keymap.set('n', '<Leader>K',  vim.lsp.buf.hover,             opts('Hover docs'))
        vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation,    opts('Implementation'))
        vim.keymap.set('n', '<Leader><C-k>', vim.lsp.buf.signature_help, opts('Signature help'))
        vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder,    opts('Add workspace folder'))
        vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts('Remove workspace folder'))
        vim.keymap.set('n', '<Leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts('List workspace folders'))
        vim.keymap.set('n', '<Leader>D',  vim.lsp.buf.type_definition, opts('Type definition'))
        vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename,          opts('Rename'))
        vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action,     opts('Code action'))
        vim.keymap.set('n', '<Leader>gr', vim.lsp.buf.references,      opts('References'))
        vim.keymap.set('n', '<Leader>f',  vim.lsp.buf.format,          opts('Format'))
        vim.keymap.set('n', '<Leader>lr', tb.lsp_references,           opts('LSP references'))
        vim.keymap.set('n', '<Leader>li', tb.lsp_incoming_calls,       opts('LSP incoming calls'))
        vim.keymap.set('n', '<Leader>lo', tb.lsp_outgoing_calls,       opts('LSP outgoing calls'))
        vim.keymap.set('n', '<Leader>ls', tb.lsp_document_symbols,     opts('LSP doc symbols'))
        vim.keymap.set('n', '<M-q><M-f>', tb.quickfix,                 opts('Quickfix'))

        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      -- Global diagnostic keymaps
      vim.keymap.set('n', '<Space>e', vim.diagnostic.open_float, { desc = 'Diagnostic: float' })
      vim.keymap.set('n', '[d',       vim.diagnostic.goto_prev,  { desc = 'Diagnostic: prev' })
      vim.keymap.set('n', ']d',       vim.diagnostic.goto_next,  { desc = 'Diagnostic: next' })
      vim.keymap.set('n', '<Space>q', vim.diagnostic.setloclist, { desc = 'Diagnostic: loclist' })

      -- ── Server configs ────────────────────────────────────────────────────────
      -- Python
      vim.lsp.config('basedpyright', {
        on_attach    = on_attach,
        flags        = lsp_flags,
        capabilities = capabilities,
        filetypes    = { 'python' },
      })
      vim.lsp.enable('basedpyright')

      -- Rust
      vim.lsp.config('rust_analyzer', {
        on_attach    = on_attach,
        flags        = lsp_flags,
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            imports   = { granularity = { group = 'module' }, prefix = 'self' },
            cargo     = { buildScripts = { enable = true } },
            procMacro = { enable = true },
          },
        },
      })
      vim.lsp.enable('rust_analyzer')

      -- LaTeX
      vim.lsp.config('texlab',      { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities })
      vim.lsp.enable('texlab')

      -- Terraform
      vim.lsp.config('terraformls', { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities })
      vim.lsp.enable('terraformls')

      -- YAML
      vim.lsp.config('yamlls',      { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities })
      vim.lsp.enable('yamlls')

      -- HTML
      vim.lsp.config('html',        { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities })
      vim.lsp.enable('html')

      -- Lua (teach it about the vim global)
      vim.lsp.config('lua_ls', {
        on_attach    = on_attach,
        flags        = lsp_flags,
        capabilities = capabilities,
        settings     = { Lua = { diagnostics = { globals = { 'vim' } } } },
      })
      vim.lsp.enable('lua_ls')

      -- CSS
      vim.lsp.config('cssls',       { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities })
      vim.lsp.enable('cssls')

      -- TypeScript / Vue (ts_ls + @vue/typescript-plugin)
      vim.lsp.config('ts_ls', {
        init_options = {
          plugins = {
            {
              name      = '@vue/typescript-plugin',
              location  = vim.env.HOME .. '/.bun/install/global/node_modules/@vue/typescript-plugin',
              languages = { 'javascript', 'typescript', 'vue' },
            },
          },
        },
        filetypes = { 'javascript', 'typescript', 'vue' },
      })
      vim.lsp.enable('ts_ls')

      -- Volar (Vue)
      vim.lsp.config('volar', {
        on_attach    = on_attach,
        flags        = lsp_flags,
        capabilities = capabilities,
        filetypes    = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
      })
      vim.lsp.enable('volar')

      -- Bash
      vim.lsp.config('bashls',      { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities })
      vim.lsp.enable('bashls')
    end,
  },
}
