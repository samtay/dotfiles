########## zplug
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi
source ~/.zplug/init.zsh

########### functionality
# load the good parts from oh-my-zsh lib/
zplug "lib/completion",           from:oh-my-zsh
zplug "lib/directories",          from:oh-my-zsh
zplug "lib/theme-and-appearance", from:oh-my-zsh # used in theme
zplug "lib/git",                  from:oh-my-zsh # used in theme
# external plugins
zplug "plugins/docker",           from:oh-my-zsh, nice:10
zplug "plugins/docker-compose",   from:oh-my-zsh, nice:10
zplug "plugins/composer",         from:oh-my-zsh, nice:10
zplug "plugins/vi-mode",          from:oh-my-zsh, nice:10
zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "zsh-users/zsh-history-substring-search", nice:11
# local plugins
zplug "~/git/etc/dotfiles/zsh/plugins", from:local, nice:12
# vim binding for history
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

########### theme
zplug "SamTay/lambda-mod-zsh-theme", as:theme

########### install packages
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

########### globals
# set up PATH
export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/home/samtay/.badevops/bin:$PATH"
# others
export VISUAL=vim
export EDITOR="$VISUAL"
# blueacorn shiz
export BLUEACORN_BOOTSTRAP_DIR="/home/samtay/git/innovation/bootstrap"
export BLUEACORN_SERVICE_CREDENTIALS="/home/samtay/.badevops/git/devops-docker/machines/service-credentials"

########## misc tasks
# termite ctrl+shift+t
if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi
# bash completions
autoload -U +X bashcompinit && bashcompinit
# stack completion
eval "$(stack --bash-completion-script stack)"
# autocomplete hidden files
_comp_options+=(globdots)

####### doc links
# https://github.com/zplug/zplug/wiki/Configurations
# nice of 10 or higher results in plugins being loaded after compinit is called.
