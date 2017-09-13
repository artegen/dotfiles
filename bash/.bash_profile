
# Load our dotfiles like ~/.bash_prompt, etc…
#   ~/.local can be used for settings you don’t want to commit,
#   Use it to configure your PATH, thus it being first in line.
for file in ~/.{config/.local,bash_prompt,exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file



# Do not override files using `>`, but it's still possible using `>!`
set -o noclobber

# generic colouriser
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n "$GRC" ]
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure'
        for app in {diff,make,gcc,g++,ping,traceroute}; do
            alias "$app"='colourify '$app
    done
fi



##
## Completion…
##

# z beats cd most of the time. `brew install z`
zpath="$(brew --prefix)/etc/profile.d/z.sh"
[ -s $zpath ] && source $zpath


# The below applies only for bash, so exit if in zsh
if [[ -n "$ZSH_VERSION" ]]; then
    return 1 2> /dev/null || exit 1;
fi;


# bash completion.
if  which brew > /dev/null
    && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;
# homebrew completion
# if  which brew > /dev/null; then
#     source "$(brew --prefix)/etc/bash_completion.d/brew"
# fi;

# hub completion
if  which hub > /dev/null; then
    source "$(brew --prefix)/etc/bash_completion.d/hub.bash_completion.sh";
fi;

# Add tab completion for SSH hostnames based on ~/.ssh.config, ignoring wildcards
[ -e "$HOME/.ssh.config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh.config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;


# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_complete &> /dev/null; then
    __git_complete g __git_main
fi;



##
## better `cd`'ing
##

# Autocorrect on directory names to match a glob.
shopt -s dirspell 2> /dev/null

# Turn on recursive globbing (enables ** to recurse all directories, e.g. `echo **/*.txt`)
shopt -s globstar 2> /dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell;

