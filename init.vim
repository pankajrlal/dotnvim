source ~/.config/nvim/vim_plug
set encoding=UTF-8
lua require('plugins')
lua require('config')
lua require('lspsetup')
lua require('customizations')
" lua require('crates_config')
" lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})
source ~/.config/nvim/vimrc_customizations
