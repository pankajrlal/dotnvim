# 001 Fix markdown table rendering and remove vimwiki

## What shipped
- `lua/plugins/ui.lua`: render-markdown table options moved from `table` to the
  correct key `pipe_table` (checkhealth reported `table - expected: nil`).
- Removed vimwiki completely: plugin spec (`misc.lua`), `vim.g.vimwiki_list`
  (`options.lua`), the `vimwiki` FileType autocmd (`autocmds.lua`), the HTML
  export template `default.tpl` and its `style.css`, the lazy-lock entry and the
  Readme note.

## Why
Vimwiki's default `vimwiki_global_ext` claimed every `.md` file as filetype
`vimwiki`, so render-markdown (`ft = markdown`) never loaded. With vimwiki gone,
`.md` files get `markdown` and tables render.

## Deferred
- The installed plugin dir remains until `:Lazy clean`.
- The wrap/linebreak prose settings that applied to vimwiki buffers were dropped,
  not moved to `markdown`.
- Pre-existing `E31: No such mapping` at startup (also on `main`) not investigated.
