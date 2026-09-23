# My setup!

## Mac OS

### Tmux

Download [tmux binary](https://github.com/tmux/tmux-builds/releases/). Copy to `~/.local/bin`.

### Go

https://go.dev/dl/

`go install golang.org/x/tools/gopls@latest`

### Neovim 

Download [Neovim](https://neovim.io/doc/install/#install-from-download); unzip in ~/Downloads.

Copy:
`sudo mv ~/Downloads/nvim-macos-arm64 /opt/nvim`

Add link in bin directory:
`sudo ln -s /opt/nvim/bin/nvim ~/.local/bin/nvim`

Install tree-sitter CLI:
https://github.com/tree-sitter/tree-sitter/releases/

Check lsps: `:checkhealth vim.lsp`

### just

`curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin`


### For fun

Rename displayed hostname in terminals:
`sudo scutil --set HostName`

