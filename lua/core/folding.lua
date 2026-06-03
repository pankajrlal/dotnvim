-- Folding configuration.
--
-- Folds are driven by document STRUCTURE, not by any linked JSON/YAML schema.
-- A schema validates which keys are legal and what their types are; it carries
-- no fold-region information, so no foldmethod can be "schema aware". For real
-- structure-aware folds we use:
--   * the language server's foldingRange (preferred when a server is attached,
--     e.g. yaml-language-server for YAML), then
--   * treesitter as the default and fallback for everything else.
--
-- foldmethod=syntax is intentionally NOT used: the YAML syntax file shipped with
-- nvim declares no fold regions, so syntax folding produces nothing for YAML.
-- foldmethod=indent works for YAML only because YAML structure is indentation,
-- but it is blind to block structure in other languages.

-- Global defaults: expr folding via treesitter, everything open on file open.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "" -- render the raw first line (with highlighting) as fold text
vim.opt.foldlevel = 99 -- start fully unfolded
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = "auto:1" -- show a clickable +/- gutter only when folds exist
-- mouse is on by default (mouse=nvi); clicking the + in the gutter opens a fold.

-- Prefer the LSP's folding ranges on buffers whose server supports them.
-- For YAML this routes through yaml-language-server, which reports fold ranges
-- from the parsed document tree (the schema-aware server, even if the folds
-- themselves are structural). Falls back to the treesitter default otherwise.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_folding", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})

-- When the last LSP for a window detaches, drop back to treesitter folding.
vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("lsp_folding_detach", { clear = true }),
  callback = function()
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
})

-- Friendlier fold keys. NOTE: in a terminal <Tab> == <C-i>, so this shadows the
-- jumplist forward jump (<C-o> back still works). Swap <Tab> for another key if
-- you rely on <C-i>.
--
--   <Tab>    toggle the fold under the cursor (za)
--   <S-Tab>  toggle ALL folds: open everything if anything is closed, else close all
vim.keymap.set("n", "<Tab>", "za", { desc = "Fold: toggle under cursor", silent = true })

local function toggle_all_folds()
  for lnum = 1, vim.fn.line("$") do
    if vim.fn.foldclosed(lnum) ~= -1 then
      vim.cmd("normal! zR") -- something is closed -> open all
      return
    end
  end
  vim.cmd("normal! zM") -- nothing closed -> close all
end
vim.keymap.set("n", "<S-Tab>", toggle_all_folds, { desc = "Fold: toggle all", silent = true })
