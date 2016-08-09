#!/usr/bin/env bash

### Add dm script to PATH
### Warning: depends on BlueAcornInc\bootstrap

# utility
#########

display_help() {
  cat <<-EOF

  A utiltiy for setting up configuration on any machine

  Usage: manage.sh <command>

  Commands:
  symlink              symlinks dotfiles to home directory
EOF

  if [ $# -eq 0 ]; then
    exit 0
  fi

  exit $1
}

error(){
  printf "\033[31m%s\n\033[0m" "$@" >&2
  exit 1
}

# globals
#########

type greadlink >/dev/null 2>&1 && CWD="$(dirname "$(greadlink -f "$0")")" || \
  CWD="$(dirname "$(readlink -f "$0")")"

symlink_files=(".atom" ".i3/config" ".ideavimrc" ".oh-my-zsh/custom" ".tmux.conf" ".vimrc" ".zshrc")

# functions
###########
symlink() {
  # TODO check if these are symlinks first
  for file in "${symlink_files[@]}"
  do
    if [ ! -e "$HOME/${file}" ]; then
      echo "Symlinking to ~/${file}"
      ln -s "${CWD}/${file}" "$HOME/${file}"
    fi
  done
}


# runtime
#########

if [ $# -eq 0 ]; then
  display_help 1
else
  while [ $# -ne 0 ]; do
    case $1 in
      -h|--help|help)    display_help ;;
      symlink)           runstr="symlink" ;;
      *)                 echo "invalid option: $1" ; display_help 1 ;;
    esac
    shift
  done

  $runstr
  exit $?
fi


