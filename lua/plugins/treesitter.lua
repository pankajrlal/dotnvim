-- nvim-treesitter, `main` branch (the rewrite; requires Neovim 0.12+).
--
-- Unlike the old `master` branch, `main` does almost nothing by default:
--   * it does NOT auto-install parsers   -> we declare a list and install it
--   * it does NOT enable highlighting    -> we start it per-buffer on FileType
--   * it does NOT support lazy-loading   -> `lazy = false`
-- Folding is intentionally NOT configured here: core/folding.lua already drives
-- folds through vim.treesitter.foldexpr() globally, so folds work as soon as a
-- parser exists for the buffer.
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate', -- keep parsers matched to the plugin version
    config = function()
      local ts = require('nvim-treesitter')

      -- Parsers to keep installed. Add a language here and restart (install is a
      -- no-op for parsers already present). c/lua/markdown/query/vim/vimdoc ship
      -- bundled with Neovim, but listing them keeps them current via :TSUpdate.
      local ensure = {
        'bash', 'css', 'diff', 'dockerfile', 'gitcommit', 'gitignore',
        'hcl', 'html', 'javascript', 'json', 'lua', 'luadoc',
        'markdown', 'markdown_inline', 'python', 'query', 'regex', 'sql',
        'terraform', 'toml', 'typescript', 'vim', 'vimdoc', 'yaml',
      }

      -- Install asynchronously; no-op for parsers that are already present.
      ts.install(ensure)

      -- Turn on treesitter highlighting for any buffer whose filetype has a
      -- parser. pcall swallows the error for filetypes without one.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_highlight', { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
