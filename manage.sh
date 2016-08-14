#!/usr/bin/env bash

# utility
#########

display_help() {
  cat <<-EOF

  A utiltiy for setting up configuration on any machine

  Usage: manage.sh <command>

  Commands:
  link-config              stow directories of this repo into ~
  install-packages         install base packages (from packages.txt)
  bootstrap                bootstrap my arch linux environment
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

# functions
###########
link-config() {
  for d in $(ls -d */); do
    ( stow --target=$HOME --restow $d )
  done
}

install-packages() {
  sudo pacman -Sy yaourt
  yaourt -S --needed --noconfirm `cat packages.txt`
}

add-repositories() {
  add-infinality-key
  cat repositories.txt | sudo tee -a /etc/pacman.conf
}

add-infinality-key() {
  sudo dirmngr &
  sleep 1
  sudo pacman-key -r 962DDE58
  sudo pacman-key --lsign-key 962DDE58
}

enable-services() {
  sudo systemctl enable tlp tlp-sleep
  sudo systemctl disable systemd-rfkill
  sudo tlp start
}

set-shell() {
 chsh -s $(which zsh)
}

show-post-install() {
  cat ./post-install.txt
}

bootstrap() {
  add-repositories
  install-packages
  enable-services
  link-config
  set-shell
  show-notes
}

# runtime
#########

if [ $# -eq 0 ]; then
  display_help 1
else
  while [ $# -ne 0 ]; do
    case $1 in
      -h|--help|help)    display_help ;;
      link-config)       runstr="link-config" ;;
      install-packages)  runstr="install-packages" ;;
      bootstrap)         runstr="bootstrap" ;;
      *)                 echo "invalid option: $1" ; display_help 1 ;;
    esac
    shift
  done

  $runstr
  exit $?
fi


