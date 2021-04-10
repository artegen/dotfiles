#!/usr/bin/env bash

# Update installed Homebrew + its installed packages
brew -v update

# uninstall all Homebrew formulae not listed in Brewfile
# Unless the --force option is passed, formulae will be listed rather than actually uninstalled.
# brew bundle cleanup --force

brew upgrade # --greedy, for casks without autoupdates active

brew doctor
