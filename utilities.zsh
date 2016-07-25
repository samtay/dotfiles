# Aliases
alias copy="xclip -sel clip"
alias copy-ssh-key='copy-file ~/.ssh/id_rsa.pub'
alias reload-zsh='source ~/.zshrc'
alias ba-jump="ssh -o 'ProxyCommand ssh -W %h:%p jump'"
alias ba-jump-scp="scp -o 'ProxyCommand ssh -W %h:%p jump'"
alias ba-vpn="sudo openvpn --daemon /etc/openvpn/ba-client.conf"
alias wifi-scan="sudo iwlist wlp3s0 scan | grep ESSID"
alias wifi-list="nmcli d wifi"
alias wifi-connect="nmcli -a d wifi connect"
alias displays-on="xrandr --output HDMI-0 --auto --rotate left --right-of DP-0 && xrandr --output DP-2 --auto --right-of HDMI-0"
alias displays-off="xrandr --output HDMI-0 --off && xrandr --output DP-2 --off"
alias screenshot-select="scrot -s -e 'mv \$f ~/screenshots/'"
alias lt="l -t"

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

copy-file(){
  cat $1 | xclip -sel clip
}

watch(){
  less +F $1
}

mysql-command() {
  echo "$1" | mysql -uroot -proot
}

find-process() {
  ps aux | grep "$@"
}

cli-xdebug-toggle() {
  local XDEBUG_EXTENSION_ON="zend_extension=\/usr\/lib\/php5\/20131226\/xdebug.so"
  local XDEBUG_EXTENSION_OFF=";$XDEBUG_EXTENSION_ON"
  if grep -q $XDEBUG_EXTENSION_OFF "/etc/php5/cli/php.ini"; then
    sudo sed -i "s/$XDEBUG_EXTENSION_OFF/$XDEBUG_EXTENSION_ON/g" /etc/php5/cli/php.ini
    echo "CLI xdebug enabled"
  else
    sudo sed -i "s/$XDEBUG_EXTENSION_ON/$XDEBUG_EXTENSION_OFF/g" /etc/php5/cli/php.ini
    echo "CLI xdebug disabled"
  fi
}

