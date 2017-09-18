# Maybe, you'll need to do first things commented out in the bottom, if your machine is completely new.

if test ! "$(uname)" = "Darwin"
  then echo "› Your machine is not 'Darwin'. These dotfiles are not meant for other systems."
  exit 1
fi

success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}

cd "$(dirname $0)"/..

symlink_dotfiles () {
  echo '› Symlinking dotfiles'

  for src in $(find -H "$(pwd -P)" -type f -maxdepth 2 -name '.*' -not -name '.DS_Store' -not -name '.gitmodules')
  do
    dst="$HOME/$(basename "${src}")"
    ln -sf "$src" "$dst"
    success "linked $src to $dst"
  done

  # setting up the VS Code symlink
  ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ~/.bin/code

}

symlink_dotfiles



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
brew cask cleanup



#  Set up mac OS
echo "› Setting up mac OS"
sh my-macos.sh



echo "› Installing dependencies"

# for the c alias (syntax highlighted cat)
pip install Pygments

# git clone https://github.com/rupa/z.git ~/.dotfiles/bin/z
# installed with brew
# consider reusing your current .z file if possible. it's painful to rebuild :)
# z is hooked up in .bash_profile

# https://github.com/jamiew/git-friendly
git clone git://github.com/jamiew/git-friendly.git "~/.dotfiles/bin/git-friendly"

#Install antigen
git clone --recursive https://github.com/zsh-users/antigen.git "$HOME/.dotfiles/zsh/antigen"

# Install yarn, nvm from the binaries, run these periodically to update
curl -o- -L https://yarnpkg.com/install.sh | bash
# change version >
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash





# ## XCode Command Line Tools
#     #  thx https://github.com/alrra/dotfiles/blob/ff123ca9b9b/os/os_x/installs/install_xcode.sh


# print_success() {
#      "   [✔] $1\n"
# }
# print_error() {
#      "   [✖] $1 $2\n"
# }
# print_result() {

#     if [ "$1" -eq 0 ]; then
#         print_success "$2"
#     else
#         print_error "$2"
#     fi

#     return "$1"

# }

# execute() {

#     local -r CMDS="$1"
#     local -r MSG="${2:-$1}"
#     local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

#     local exitCode=0
#     local cmdsPID=""

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     # If the current process is ended,
#     # also end all its subprocesses.

#     # set_trap "EXIT" "kill_all_subprocesses"

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     # Execute commands in background

#     eval "$CMDS" \
#         &> /dev/null \
#         2> "$TMP_FILE" &

#     cmdsPID=$!

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     # Show a spinner if the commands
#     # require more time to complete.

#     # show_spinner "$cmdsPID" "$CMDS" "$MSG"

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     # Wait for the commands to no longer be executing
#     # in the background, and then get their exit code.

#     wait "$cmdsPID" &> /dev/null
#     exitCode=$?

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     # Print output based on what happened.

#     print_result $exitCode "$MSG"

#     if [ $exitCode -ne 0 ]; then
#         print_error_stream < "$TMP_FILE"
#     fi

#     rm -rf "$TMP_FILE"

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     return $exitCode

# }

# agree_with_xcode_licence() {

#     # Automatically agree to the terms of the `Xcode` license.
#     # https://github.com/alrra/dotfiles/issues/10

#     sudo xcodebuild -license accept &> /dev/null
#     print_result $? "Agree to the terms of the Xcode licence"

# }

# are_xcode_command_line_tools_installed() {
#     xcode-select --print-path &> /dev/null
# }

# install_xcode() {

#     # If necessary, prompt user to install `Xcode`.

#     if ! is_xcode_installed; then
#         open "macappstores://itunes.apple.com/en/app/xcode/id497799835"
#     fi

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     # Wait until `Xcode` is installed.

#     execute \
#         "until is_xcode_installed; do \
#             sleep 5; \
#          done" \
#         "Xcode.app"

# }

# install_xcode_command_line_tools() {

#     # If necessary, prompt user to install
#     # the `Xcode Command Line Tools`.

#     xcode-select --install &> /dev/null

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     # Wait until the `Xcode Command Line Tools` are installed.

#     execute \
#         "until are_xcode_command_line_tools_installed; do \
#             sleep 5; \
#          done" \
#         "Xcode Command Line Tools"

# }

# is_xcode_installed() {
#     [ -d "/Applications/Xcode.app" ]
# }

# set_xcode_developer_directory() {

#     # Point the `xcode-select` developer directory to
#     # the appropriate directory from within `Xcode.app`.
#     #
#     # https://github.com/alrra/dotfiles/issues/13

#     sudo xcode-select -switch "/Applications/Xcode.app/Contents/Developer" &> /dev/null
#     print_result $? "Make 'xcode-select' developer directory point to the appropriate directory from within Xcode.app"

# }

# # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# main() {


#     install_xcode_command_line_tools
#     install_xcode
#     set_xcode_developer_directory
#     agree_with_xcode_licence

# }

# if ! xcode-select --print-path &> /dev/null; then main; fi;


# # XCODE is enormous - not any more
# # kill cache
# rm -rf ~/Library/Caches/com.apple.dt.Xcode
# #   appears that XCode can survive deleting ALL documentation sets!
# ~/Library/Developer/Shared/Documentation/DocSets
# /Applications/Xcode.app/Contents/Developer/Documentation/DocSets
# # other simulators can be here.
# /Library/Developer/CoreSimulator/Profiles/Runtimes





echo ''
echo success 'All installed!'




###  backup old machine's key items

# mkdir -p ~/migration/home/
# mkdir -p ~/migration/Library/"Application Support"/
# mkdir -p ~/migration/Library/Preferences/
# mkdir -p ~/migration/Library/Application Support/
# mkdir -p ~/migration/rootLibrary/Preferences/SystemConfiguration/

# cd ~/migration

# # what is worth reinstalling?
# brew leaves              > brew-list.txt    # all top-level brew installs
# brew cask list           > cask-list.txt
# npm list -g --depth=0    > npm-g-list.txt
# yarn global ls --depth=0 > yarn-g-list.txt

# # then compare brew-list to what's in `brew.sh`
# #   comm <(sort brew-list.txt) <(sort brew.sh-cleaned-up)

# # backup some dotfiles likely not under source control
# cp -Rp \
#     ~/.bash_history \
#     ~/.extra ~/.extra.fish \
#     ~/.gitconfig.local \
#     ~/.gnupg \
#     ~/.nano \
#     ~/.nanorc \
#     ~/.netrc \
#     ~/.ssh \
#     ~/.z   \
#         ~/migration/home

# cp -Rp ~/Documents ~/migration

# cp -Rp /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist ~/migration/rootLibrary/Preferences/SystemConfiguration/ # wifi

# cp -Rp ~/Library/Preferences/net.limechat.LimeChat.plist ~/migration/Library/Preferences/
# cp -Rp ~/Library/Preferences/com.tinyspeck.slackmacgap.plist ~/migration/Library/Preferences/

# cp -Rp ~/Library/Services ~/migration/Library/ # automator stuff
# cp -Rp ~/Library/Fonts ~/migration/Library/ # all those fonts you've installed

# # editor settings & plugins
# cp -Rp ~/Library/Application\ Support/Sublime\ Text\ * ~/migration/Library/"Application Support"
# cp -Rp ~/Library/Application\ Support/Code\ -\ Insider* ~/migration/Library/"Application Support"

