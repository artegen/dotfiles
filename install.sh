#!/usr/bin/env bash

log() { echo -e "\n \033[1;33m➜\033[0m  $* \n"; }
success() { echo -e "\n \033[1;32m✔\033[0m  $* \n"; }

link() {
  file=$1
  link=$2

  # mkdir -p "$(dirname "${link}")"
  ln -vf -s "${file}" "${link}"
}

symlink_dotfiles() {
  log 'Symlinking dotfiles'
  WDIR="$HOME/.dotfiles"

  for dir in "$WDIR/shell" "$WDIR/git" "$WDIR/configs"; do
    for file in "$dir"/.*; do
      base="$(basename "$file")"
      [[ $base =~ ^(.|..|.DS_Store)$ ]] && continue # skip these files
      dest="$HOME/$base"
      link "$file" "$dest"
    done
  done

  mkdir "$HOME"/.ssh{,/control}
  declare -A files
  files=(
    ["configs/ssh"]=".ssh/config"
    # ["code/settings.json"]=".config/Code/User/settings.json"
  )
  for file in "${!files[@]}"; do
    link "$(pwd)/${file}" "$HOME/${files[${file}]}"
  done

  # ln -sf "$HOME/.dotfiles/vscode/javascript.json" "$HOME/Library/Application Support/Code/User/snippets/javascript.json"
  # ln -sf "$HOME/.dotfiles/vscode/general-snippets.json" "$HOME/Library/Application Support/Code/User/snippets/general-snippets.json"
  # ln -sf "$HOME/.dotfiles/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
  # ln -sf "$HOME/.dotfiles/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
}

symlink_dotfiles

# Check for/install Homebrew
if test ! "$(which brew)"; then
  log "Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
# Run Homebrew through the Brewfile, https://github.com/Homebrew/homebrew-bundle
brew tap Homebrew/bundle
log "Installing brew packages"
brew bundle
brew cleanup

#  Set up mac OS
log "Setting up mac OS"
./configs/macos.sh

# Additional packages
log "Installing more packages"

# for the c alias (syntax highlighted cat)
pip3 install Pygments

#Install antigen
git clone --recursive https://github.com/zsh-users/antigen.git "$HOME/.dotfiles/zsh/antigen"

# change nvm version >
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | bash
nvm install lts

curl -o- -L https://yarnpkg.com/install.sh | bash

success 'All installed!'
