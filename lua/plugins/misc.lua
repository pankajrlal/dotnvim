return {
  -- Wiki / note-taking (previously managed by vim-plug, now unified under lazy)
  { 'vimwiki/vimwiki' }, -- config lives in core/options.lua (vim.g.vimwiki_list)

  -- Documentation generator (generates docstrings)
  { 'kkoomen/vim-doge', build = ':call doge#install()' },

  -- Interactive scratchpad / REPL overlay
  { 'metakirby5/codi.vim' },
}
