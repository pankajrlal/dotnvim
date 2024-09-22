vim.cmd("colorscheme catppuccin")

-- Setup for lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'catppuccin',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '*', right = '*'},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
-- cmp_nvim_lsp.update_capabilities is deprecated, use cmp_nvim_lsp.default_capabilities instead. See :h deprecated


vim.o.background = "dark"
-- vim.cmd([[colorscheme gruvbox]])

require("mason").setup()

-- setup for vim bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}

require "nvim-treesitter.configs".setup {
  tree_docs = {enable = true}
}
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  }
 };
 -- same as `override` but specifically for operating system
 -- takes effect when `strict` is true
 override_by_operating_system = {
  ["apple"] = {
    icon = "",
    color = "#A2AAAD",
    cterm_color = "248",
    name = "Apple",
  },
 };
}
require'nvim-web-devicons'.get_icons()
require'lspconfig'.bashls.setup{}

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

--  require("crates").setup()
--
--  require("crates.completion.cmp").setup()
--
--  require("actions-preview").setup {
--   -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
--   diff = {
--     ctxlen = 3,
--   },
--
--   -- priority list of external command to highlight diff
--   -- disabled by defalt, must be set by yourself
--   highlight_command = {
--     -- require("actions-preview.highlight").delta(),
--     -- require("actions-preview.highlight").diff_so_fancy(),
--     -- require("actions-preview.highlight").diff_highlight(),
--   },
--
--   -- priority list of preferred backend
--   backend = { "telescope", "nui" },
--
--   -- options related to telescope.nvim
--   telescope = vim.tbl_extend(
--     "force",
--     -- telescope theme: https://github.com/nvim-telescope/telescope.nvim#themes
--     require("telescope.themes").get_dropdown(),
--     -- a table for customizing content
--     {
--       -- a function to make a table containing the values to be displayed.
--       -- fun(action: Action): { title: string, client_name: string|nil }
--       make_value = nil,
--
--       -- a function to make a function to be used in `display` of a entry.
--       -- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
--       -- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
--       make_make_display = nil,
--     }
--   ),
--
--   -- options for nui.nvim components
--   nui = {
--     -- component direction. "col" or "row"
--     dir = "col",
--     -- keymap for selection component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu#keymap
--     keymap = nil,
--     -- options for nui Layout component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/layout
--     layout = {
--       position = "50%",
--       size = {
--         width = "60%",
--         height = "90%",
--       },
--       min_width = 40,
--       min_height = 10,
--       relative = "editor",
--     },
--     -- options for preview area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
--     preview = {
--       size = "60%",
--       border = {
--         style = "rounded",
--         padding = { 0, 1 },
--       },
--     },
--     -- options for selection area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu
--     select = {
--       size = "40%",
--       border = {
--         style = "rounded",
--         padding = { 0, 1 },
--       },
--     },
--   },
-- }
--
-- local outline = require("outline")
--
-- outline.setup({
--     server = {
--         on_attach = function(_, bufnr)
--             vim.keymap.set("n", "<Leader>o", outline.OutlineOpen, {buffer = bufnr})
--         end,
--     }
-- })

-- local rt = require("rust-tools")
--
-- rt.setup({
--   server = {
--     on_attach = function(_, bufnr)
--       -- Hover actions
--       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
--       -- Code action groups
--       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
--     end,
--   },
-- })

