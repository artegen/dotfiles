# Maybe, you'll need to do first things commented out in the bottom, if your machine is completely new.

# Exit the script on any command with non 0 return code
set -e


# Error messages are redirected to stderr
function handle_error {
  echo "$(basename $0): ERROR! An error was encountered executing line $1." 1>&2;
  echo 'Exiting with error.' 1>&2;
  exit 1
}

# Exit the script with a helpful error message when any error is encountered
trap 'set +x; handle_error $LINENO $BASH_COMMAND' ERR

# Echo every command being executed
set -x


success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}


# Symbolic links are not aliases. They don't contain the inode name of the original object,
# so if its path changes the link is lost. But you can replace original object in this case.
# Hard links (3rd type) contain inode, but not the path,
# and you can't delete the object until you remove all the links.
symlink_dotfiles () {
  echo '› Symlinking dotfiles'

  for src in $(find -H "$(pwd -P)" -type f -maxdepth 2 -name '.*' -not -name '.DS_Store' -not -name '.gitmodules')
  do
    dst="$HOME/$(basename "${src}")"
    ln -sf "$src" "$dst"
    success "linked $src to $dst"
  done

  ln -sf "$HOME/.dotfiles/preferences/config" "$HOME/.ssh/config"
  ln -sf "$HOME/.dotfiles/vscode/javascript.json" "$HOME/Library/Application Support/Code/User/snippets/javascript.json"
  ln -sf "$HOME/.dotfiles/vscode/general-snippets.json" "$HOME/Library/Application Support/Code/User/snippets/general-snippets.json"
  ln -sf "$HOME/.dotfiles/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
  ln -sf "$HOME/.dotfiles/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
}


symlink_dotfiles


cd preferences/

# Check for/install Homebrew
if test ! $(which brew)
then
  echo "› Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
# if your machine has /usr/local locked down (like corporate ones), you can do this to place everything in ~/.homebrew
# mkdir $HOME/.homebrew && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
# export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH

brew update

# Run Homebrew through the Brewfile, https://github.com/Homebrew/homebrew-bundle
brew tap Homebrew/bundle
echo "› Installing brew bundle"
brew bundle

brew cleanup



#  Set up mac OS
# echo "› Setting up mac OS"
# sh my-macos.sh



echo "› Installing dependencies"

# for the c alias (syntax highlighted cat)
pip3 install Pygments

# git clone https://github.com/rupa/z.git ~/.dotfiles/bin/z
# installed with brew
# consider reusing your current .z file if possible. it's painful to rebuild :)
# z is hooked up in .bash_profile

# https://github.com/jamiew/git-friendly
curl -sS https://raw.githubusercontent.com/jamiew/git-friendly/master/install.sh | bash

#Install antigen
git clone --recursive https://github.com/zsh-users/antigen.git "$HOME/.dotfiles/zsh/antigen"

# Install yarn, nvm from the binaries, run these periodically to update
# change nvm version >
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | bash
nvm install lts

curl -o- -L https://yarnpkg.com/install.sh | bash

cd  ../vscode/ && sh vscode-pkglist.sh -i





echo ''
echo success 'All installed!'
