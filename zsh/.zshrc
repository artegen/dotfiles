
#Export new path for zsh configuration files
export ZDOTDIR="$HOME/.dotfiles/zsh"


# uncomment to profile prompt startup with zprof
# zmodload zsh/zprof
# see below for stop command


# Load default dotfiles
source ~/.bash_profile


# Set TERM early for guake
# export TERM="xterm-256color"

# Load package manager
source "${ZDOTDIR:-$HOME}/packages.zsh"

# Enable command correction
setopt CORRECT

# Cd shortcut
setopt AUTO_CD

# Dots expansion
setopt GLOB_DOTS

# Extended glob operator
setopt EXTENDED_GLOB

# Add overwrite warnings
unsetopt CLOBBER

# Pipe to multiple files
setopt MULTIOS

# Easy URL copy-pasting.
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Expansion options
setopt BRACE_CCL
setopt COMBINING_CHARS
setopt RC_QUOTES

# Job control
setopt LONG_LIST_JOBS
setopt AUTO_RESUME
setopt NOTIFY
unsetopt BG_NICE
unsetopt HUP
unsetopt CHECK_JOBS

# directory options
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT


# Set Tmuxinator alias
# alias mux="tmuxinator start"

# Virtualenvwrapper, python
# source "$HOME/.local/bin/virtualenvwrapper_lazy.sh"


# # all of our zsh files
# typeset -U config_files
# config_files=($ZSH/**/*.zsh)

# # load the path files
# for file in ${(M)config_files:#*/path.zsh}
# do
#   source $file
# done

# # load everything but the path and completion files
# for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
# do
#   source $file
# done

# # initialize autocomplete here, otherwise functions won't be loaded
# autoload -U compinit
# compinit

# # load every completion after autocomplete loads
# for file in ${(M)config_files:#*/completion.zsh}
# do
#   source $file
# done

# unset config_files

#add each topic folder to fpath so that they can add functions and completion scripts
# for topic_folder ($ZSH/*) if [ -d $topic_folder ]; then  fpath=($topic_folder $fpath); fi;

# fpath=( "$HOME/.functions" $fpath )


# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "$HOME/.bash_profile" ]]; then
  source "$HOME/.bash_profile"
fi



bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char


# # uncomment to finish profiling
# # zprof

# tabtab source for qnm package
# uninstall by removing these lines or running `tabtab uninstall qnm`
[[ -f /Users/mac/.nvm/versions/node/v9.5.0/lib/node_modules/qnm/node_modules/tabtab/.completions/qnm.zsh ]] && . /Users/mac/.nvm/versions/node/v9.5.0/lib/node_modules/qnm/node_modules/tabtab/.completions/qnm.zsh
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/mac/Dev/apps/front2back/api-channels/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/mac/Dev/apps/front2back/api-channels/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/mac/Dev/apps/front2back/api-channels/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/mac/Dev/apps/front2back/api-channels/node_modules/tabtab/.completions/sls.zsh