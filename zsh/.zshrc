#####################################################################
# zplug
#####################################################################

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug --self-manage
fi
source ~/.zplug/init.zsh

# functionality
zplug "lib/directories",          from:oh-my-zsh
zplug "plugins/docker",           from:oh-my-zsh, defer:1
zplug "plugins/docker-compose",   from:oh-my-zsh, defer:1
zplug "plugins/composer",         from:oh-my-zsh, defer:1
zplug "zsh-users/zsh-syntax-highlighting", defer:1
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "~/git/dotfiles/zsh/plugins", from:local, defer:3
zplug "spwhitt/nix-zsh-completions"

# theme
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", on:"mafredri/zsh-async"

# install
zplug check || zplug install
zplug load


#####################################################################
# environment
#####################################################################

export EDITOR=vim
export VISUAL=vim
export BROWSER=vimb
export DOTFILES_DIR="$HOME/git/dotfiles"
export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.dex/bin:$PATH"


#####################################################################
# completions
#####################################################################

# Enable completions
if [ -d ~/.zsh/comp ]; then
  fpath=(~/.zsh/comp $fpath)
  autoload -U ~/.zsh/comp/*(:t)
fi

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
#zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:descriptions' format '%d'
zstyle ':completion:*:options' verbose yes
zstyle ':completion:*:values' verbose yes
zstyle ':completion:*:options' prefix-needed yes
zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'l:|=* e:|[.,_-]=* e:|=* m:{a-z}={A-Z}'
# sudo completions
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' menu select
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored \
  _approximate _list
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

autoload -U compinit; compinit -d ~/.zcompdump

# Original complete functions
for f in $(find $DOTFILES_DIR/zsh/plugins/completion -name "*.zsh"); do
  source "$f"
done

# autocomplete hidden files
# _comp_options+=(globdots)


#####################################################################
# colors
#####################################################################

# Color settings for zsh complete candidates
alias ll='ls -lhF --show-control-chars --color=always'
alias l='ll -A'
alias lt='l -t'
alias l.='l .[a-zA-Z]* --color=always'
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'

# use prompt colors feature
autoload -U colors
colors


#####################################################################
# options
######################################################################

#{{{
setopt auto_resume
# Ignore <C-d> logout
setopt ignore_eof
# Disable beeps
setopt no_beep
# {a-c} -> a b c
setopt brace_ccl
# Enable spellcheck
setopt correct
# Enable "=command" feature
setopt equals
# Disable flow control
setopt no_flow_control
# Ignore dups
setopt hist_ignore_dups
# Reduce spaces
setopt hist_reduce_blanks
# Ignore add history if space
setopt hist_ignore_space
# Save time stamp
setopt extended_history
# Expand history
setopt hist_expand
# Better jobs
setopt long_list_jobs
# Enable completion in "--option=arg"
setopt magic_equal_subst
# Add "/" if completes directory
setopt mark_dirs
# Disable menu complete for vimshell
setopt no_menu_complete
# List completions vertically
unsetopt list_rows_first
# Expand globs when completion
setopt glob_complete
# Enable multi io redirection
setopt multios
# Can search subdirectory in $PATH
setopt path_dirs
# For multi byte
setopt print_eightbit
# Print exit value if return code is non-zero
setopt print_exit_value
setopt pushd_ignore_dups
setopt pushd_silent
# Short statements in for, repeat, select, if, function
setopt short_loops
# Ignore history (fc -l) command in history
setopt hist_no_store
setopt transient_rprompt
unsetopt promptcr
setopt hash_cmds
setopt numeric_glob_sort
# Enable comment string
setopt interactive_comments
# Improve rm *
setopt rm_star_wait
# Enable extended glob
setopt extended_glob
# Note: It is a lot of errors in script
# setopt no_unset
# Prompt substitution
setopt prompt_subst
if [[ ${VIMSHELL_TERM:-""} != "" ]]; then
  setopt no_always_last_prompt
else
  setopt always_last_prompt
fi
# List completion
setopt auto_list
setopt auto_param_slash
setopt auto_param_keys
# List like "ls -F"
setopt list_types
# Compact completion
setopt list_packed
setopt auto_cd
setopt auto_pushd
setopt pushd_minus
setopt pushd_ignore_dups
# Check original command in alias completion
setopt complete_aliases
unsetopt hist_verify
unsetopt RM_STAR_WAIT
setopt nomatch
# }}}


#####################################################################
# keybinds
######################################################################

# vim keybinds
bindkey -v

# History completion
# autoload history-search-end
#zle -N history-beginning-search-backward-end history-search-end
#zle -N history-beginning-search-forward-end history-search-end
#bindkey "^p" history-beginning-search-backward-end
#bindkey "^n" history-beginning-search-forward-end
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[A'       history-substring-search-up
bindkey '^[[B'       history-substring-search-down

# Like bash
bindkey "^u" backward-kill-line

# Traversal in completions
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete # shift tab for reverse completions


#####################################################################
# misc tasks
#####################################################################

# bash completions
autoload -U +X bashcompinit && bashcompinit
# stack completion
eval "$(stack --bash-completion-script stack)"
#eval "$(dmc --bash-completion-script dmc)"
#eval "$(dm --bash-completion-script dm)"

HISTFILE=${HOME}/.zsh_history
HISTSIZE=10000                   # The maximum number of events to save in the internal history.
SAVEHIST=10000                   # The maximum number of events to save in the history file.
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
bindkey -v

# vi mode inidicator
VIM_PROMPT="❯"
PROMPT='%(?.%F{magenta}.%F{red})${VIM_PROMPT}%f '

prompt_pure_update_vim_prompt() {
    zle || {
        print "error: pure_update_vim_prompt must be called when zle is active"
        return 1
    }
    VIM_PROMPT=${${KEYMAP/vicmd/❮}/(main|viins)/❯}
    zle .reset-prompt
}

function zle-line-init zle-keymap-select {
    prompt_pure_update_vim_prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

if [ -e /home/samtay/.nix-profile/etc/profile.d/nix.sh ]; then . /home/samtay/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

