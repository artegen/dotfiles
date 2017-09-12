#  updates and installables from the Mac App Store
echo "› sudo softwareupdate -i -a"
sudo softwareupdate -i -a


# Update installed Homebrew, npm, and their installed packages
brew -v update

# uninstall all Homebrew formulae not listed in Brewfile
$ brew bundle cleanup --force
# Unless the --force option is passed, formulae will be listed rather than actually uninstalled.

brew upgrade --force-bottle --cleanup
brew cleanup
brew cask cleanup
brew prune
brew doctor
# npm-check -g -u

# npm install npm -g
# npm update -g'

