# My setup!

## Mac OS

### Tmux

Download [tmux binary](https://github.com/tmux/tmux-builds/releases/). Copy to `~/.local/bin`.

### Neovim 

Download [Neovim](https://neovim.io/doc/install/#install-from-download); unzip in ~/Downloads.
Copy:
`sudo mv ~/Downloads/nvim-macos-arm64 /opt/nvim`
Add link in bin directory:
`sudo ln -s /opt/nvim/bin/nvim ~/.local/bin/nvim`

### just

`curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin`

### Go

https://go.dev/dl/

### For fun

Rename displayed hostname in terminals:
`sudo scutil --set HostName`


