# Aliases
alias copy='xclip -sel clip'
alias copy-ssh-key='copy-file ~/.ssh/id_rsa.pub'
alias reload-zsh='source ~/.zshrc'
alias ba-vpn="sudo openvpn --daemon /etc/openvpn/ba-client.conf"
alias wifi-scan='sudo iwlist wlp1s0 scan | grep ESSID'
alias wifi-rescan='nmcli d wifi rescan'
alias wifi-list='nmcli d wifi'
alias wifi-connect='nmcli -a -p -s d wifi connect'
alias get-simpsons-img='echo "http://imgur.com/a/T81t9copy" | copy'
alias surfcam='vlc https://cams.cdn-surfline.com/wsc-east/ec-washoutcam.stream/chunklist.m3u8'
alias aspen='g2 aspen'
export MY_GIT_DIR="$HOME/git"

g2() {
  cd "$MY_GIT_DIR/$1" && ls -lhF --show-control-chars --color=always
}

backup() {
  mv $1{,.bak}
}

displays-toggle() {
#  local displayCount=$(xrandr | grep " connected " | wc -l)
#  if [[ $displayCount -gt 1 ]]; then
  case $1 in
    0) xrandr --output DP-0 --off --output DP-3 --auto
       sudo sed -i 's|fontconfig.dpi = 96|fontconfig.dpi = 192|' \
         /etc/nixos/configuration.nix ;;
    1) xrandr --output DP-3 --off --output DP-0 --auto
       sudo sed -i 's|fontconfig.dpi = 192|fontconfig.dpi = 96|' \
         /etc/nixos/configuration.nix ;;
  esac
  sudo nixos-rebuild switch && reboot
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
