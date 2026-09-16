alias ll="ls -l"
alias la="ls -la"
alias lta="ls -lta"

alias nv="nvim"

export PATH=$PATH:~/.local/bin

# Faster key repeat (requires logout/login to take full effect)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false
