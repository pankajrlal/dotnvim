My nvim configs seem reasonably portable. you will need packer installed for this to work.

```shell
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

After this when you get into nvim, just run the command

```
:PackerInstall
```

This should do the job

I use Mason to manage all the language server. packer installation should take care of installing Mason also.

However once Mason is in shape, you will need to install specific language servers. The ones I am using are as follows

* gh 
* vue-language-server
* typescript-language-server
* html-lsp
* rust-analyzer
* lua-language-server

Structurally

* plugins.lua contains all the plugins that packer installs
* lspsetup and config.lua contains all the post lsp install activities. I need to clean this up to get them together.
* customizations.lua contains all my key bindings
* vimrc_customizations are some legacy pieces that I should move to customizations.lua someday

I have vim_plug just for vimiki as vimwiki seemed to not like packer and I haven't investigated why. 


