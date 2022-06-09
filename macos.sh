#!/bin/bash

# Set dock show delay to 1000 seconds, so it's basically hidden permanently.
defaults write com.apple.dock autohide-delay -float 1000; killall Dock
# Restore default behavior.
# defaults delete com.apple.dock autohide-delay; killall Dock

