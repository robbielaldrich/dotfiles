# My setup!

## Mac OS

Skipping homebrew, considering it an unnecessary dependency.

1. Make `bin` dir: 
`sudo mkdir /usr/local/bin && sudo chown -R $(whoami) /usr/local/bin`
1. Download [tmux binary](https://github.com/tmux/tmux-builds/releases/); copy to `/usr/local/bin/`.
1. Download [Neovim](https://neovim.io/doc/install/#install-from-download) to ~/Downloads.
Copy:
`sudo mv ~/Downloads/nvim-macos-arm64 /opt/nvim`
Add link in bin directory:
`sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim`


