# Aliases
alias copy="xclip -sel clip"
alias copy-ssh-key='copy-file ~/.ssh/id_rsa.pub'
alias reload-zsh='source ~/.zshrc'
alias ba-jump="ssh -o 'ProxyCommand ssh -W %h:%p jump'"
alias ba-jump-scp="scp -o 'ProxyCommand ssh -W %h:%p jump'"
alias ba-vpn="sudo openvpn --daemon /etc/openvpn/ba-client.conf"
alias wifi-scan="sudo iwlist wlp3s0 scan | grep ESSID"
alias wifi-list="nmcli d wifi"
alias wifi-connect="nmcli -a -p -s d wifi connect"
alias l="ls -lAh"
alias lt="l -t"

export ETC_DIR="$HOME/git/etc"
export MODULES_DIR="$HOME/git/modules"
export INNOVATION_DIR="$HOME/git/innovation"
export SITES_DIR="$HOME/git/sites"

# Functions to leverage autocomplete
g2etc() {
  cd "$ETC_DIR/$1" && ll
}
g2module() {
  cd "$MODULES_DIR/$1" && ll
}
g2innovation() {
  cd "$INNOVATION_DIR/$1" && ll
}
g2site() {
  cd "$SITES_DIR/$1" && ll
}

backup() {
  mv $1{,.bak}
}

displays-toggle() {
  local displayCount=$(xrandr | grep " connected " | wc -l)
  if [[ $displayCount -gt 1 ]]; then
    xrandr --output HDMI-0 --off
    xrandr --output DP-2 --off
    xrandr --output DP-0 --panning 1920x1080
  else
    xrandr --output HDMI-0 --auto --right-of DP-0
    xrandr --output DP-2 --auto --right-of HDMI-0
  fi
}

copy-file(){
  cat $1 | xclip -sel clip
}

watch(){
  less +F $1
}

screenshot-select() {
  mkdir -p $HOME/screenshots
  sleep 0.2; scrot -s "$HOME/screenshots/%Y-%m-%d-%H%M%S_\$wx\$h.png"
}

screenshot() {
  mkdir -p $HOME/screenshots
  sleep 0.2; scrot -m "$HOME/screenshots/%Y-%m-%d-%H%M%S_\$wx\$h.png"
}

mysql-command() {
  echo "$1" | mysql -uroot -proot
}

find-process() {
  ps aux | grep "$@"
}

xdebug-toggle() {
  if [ -e /etc/php/conf.d/xdebug.ini ]; then
    sudo mv /etc/php/conf.d/xdebug.ini /etc/php/conf.d/xdebug.ini.bak
    echo 'Xdebug disabled'
  elif [ -e /etc/php/conf.d/xdebug.ini.bak ]; then
    sudo mv /etc/php/conf.d/xdebug.ini.bak /etc/php/conf.d/xdebug.ini
    echo 'Xdebug enabled'
  fi
}

fix-broken-symlinks() {
  find -L . -type l -exec rm {} \;
}