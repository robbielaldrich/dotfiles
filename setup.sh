#!/bin/bash
cat .zshrc >> ~/.zshrc
cat .zshenv >> ~/.zshenv
cat .gitconfig >> ~/.gitconfig

mkdir -p ~/.config/nvim/
cat .config/nvim/init.lua >> ~/.config/nvim/init.lua

