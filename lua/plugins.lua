return require('packer').startup(
function(use)
    -- packer for itself
    use 'wbthomason/packer.nvim'
    -- Use neovim treesitter for syntax highlighting
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    use { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }
    -- Use telescope for all kinds of search across different files
    use { 'nvim-telescope/telescope.nvim', branch = 'master', requires = {{'nvim-lua/plenary.nvim'}}}

    use {'nvim-telescope/telescope-ui-select.nvim' }
    
    -- use {'github/copilot.vim' }

    -- gruvbox theme
    use { "ellisonleao/gruvbox.nvim" }

    use { "catppuccin/nvim", as = "catppuccin" }
    

    use { 'nvim-tree/nvim-web-devicons' }
    use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons', opt = true } }
    -- lsp installation management
    use { "williamboman/mason.nvim" }

    use { 'williamboman/mason-lspconfig.nvim' }
    -- lsp config installation
    use 'neovim/nvim-lspconfig'

    -- Packer
    use { "sindrets/diffview.nvim" }
    -- auto completion based on lsp config
    use {'hrsh7th/cmp-nvim-lsp' }
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-path'}
    use {'hrsh7th/cmp-cmdline'}

    use {'hrsh7th/cmp-nvim-lua'}

    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    })
    use { 'hrsh7th/nvim-cmp'}
    use { 'saadparwaiz1/cmp_luasnip' }



    use {"rafamadriz/friendly-snippets"}

    -- using buffer line. Gives a tabbed view to buffers on top of the window
    -- use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}
    use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
    -- Vimwiki installation
    -- use { 'vimwiki/vimwiki'}

    -- gitsigns
    use { 'tpope/vim-fugitive' }

    -- Nerd Commenter
    use { 'preservim/nerdcommenter' }

    --- Vim Doge
    use { 'kkoomen/vim-doge', run = ':call doge#install()' }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }
    --- stuff for html editing
    use { 'tpope/vim-surround' }
    use { 'alvan/vim-closetag' }

    use { 'metakirby5/codi.vim' }


    use { 'stevearc/aerial.nvim' }
    --
    -- use {
    --     'saecki/crates.nvim',
    --     tag = 'stable',
    --     requires = { 'nvim-lua/plenary.nvim' }, -- This is a dependency for crates.nvim
    --     config = function()
    --         require('crates').setup()
    --     end
    -- }
    use {
        "aznhe21/actions-preview.nvim",
        config = function()
            vim.keymap.set({ "v", "n" }, "<Leader>b", require("actions-preview").code_actions)
        end,
    }
    use 'windwp/nvim-autopairs'
    -- use {
    --     'm4xshen/autoclose.nvim'
    -- }
    -- Debugging
--  use 'nvim-lua/plenary.nvim'
    use {
        'mfussenegger/nvim-dap',
         requires = {
            "rcarriga/nvim-dap-ui",  -- UI for nvim-dap
            "nvim-telescope/telescope-dap.nvim",  -- Telescope integration for DAP
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio"
        }
    }

    use 'AndrewRadev/splitjoin.vim'

    use {
        "stevearc/conform.nvim",
    }
    use 'nvim-telescope/telescope-media-files.nvim'
    -- use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}

    -- use {
    --     'anurag3301/nvim-platformio.lua',
    --     requires = {
    --         {'akinsho/nvim-toggleterm.lua'},
    --         {'nvim-telescope/telescope.nvim'},
    --         {'nvim-lua/plenary.nvim'},
    --     }
    -- }
    use{
      "olimorris/codecompanion.nvim",
      config = function()
        require("codecompanion").setup()
      end,
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      }
    }
  use {
      "SmiteshP/nvim-navic",
      requires = {
          "neovim/nvim-lspconfig"
      },
      config = function()
        require("nvim-navic").setup({
          highlight = true,
        })
      end
  }
  use {
      'greggh/claude-code.nvim',
      requires = {
        'nvim-lua/plenary.nvim', -- Required for git operations
      },
      config = function()
        require('claude-code').setup()
      end
   }
   use {
      'milanglacier/minuet-ai.nvim',
      requires = {
          'nvim-lua/plenary.nvim',
          'hrsh7th/nvim-cmp',       -- optional
          'Saghen/blink.cmp',       -- optional
      },
      config = function()
          require('minuet').setup {
              -- Your configuration options here
          }
      end,
  }
end
)
