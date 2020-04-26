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
alias ethernet='sudo ip link set dev enp61s0u1u2 up && sudo dhcpcd enp61s0u1u2'
export MY_GIT_DIR="$HOME/git"

alias sync-391='rsync -avce ssh --info=progress2 tays@madrid.stat.washington.edu:/mounts/costila/common/391stuff/ ~/uw/stat391/costila'

dupe() {
  cp "$1" "$2"
  vim "$2"
}

fix-wide-monitor() {
  if [ -z "$1" ]; then
    monitor="DP-1"
  else
    monitor="$1"
  fi
  xrandr --newmode "2560x1080_45.00"  167.75  2560 2696 2960 3360  1080 1083 1093 1111 -hsync +vsync
  xrandr --addmode $monitor "2560x1080_45.00"
  xrandr --output $monitor --mode "2560x1080_45.00"
}


build-resume() {
  cd "$MY_GIT_DIR/resume" && ./build.hs
}

g2() {
  cd "$MY_GIT_DIR/$1" && ls -lhF --show-control-chars --color=always
}

backup() {
  mv $1{,.bak}
}

displays-toggle() {
  if xrandr --listmonitors | grep eDP-1 ; then
    xrandr --output eDP-1 --off --output DP-1 --auto
  else
    xrandr --output DP-1 --off --output eDP-1 --auto
  fi
}

copy-file(){
  cat $1 | copy
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

surfcam() {
  local cam="$1"
  if [ -z "$cam" ]; then
    read "cam?w: washout
sw: south washout
pn: pier north
ps pier south
wr: wrightsville
f: frisco
h: hatteras
r: rockaway
j: jacksonville
ns: new-smyrna
sa: st-augustine
pi: ponce-inlet
Pick one: "
  fi
  case $cam in
    w|washout) url='cdn-ec/ec-washout/chunklist.m3u8' ;;
    sw|washout) url='wsc-east/ec-washoutsouthcam.stream/playlist.m3u8' ;;
    wr|wrightsville) url='wsc-east/ec-wrightsvillecam.stream/chunklist.m3u8' ;;
    pn|pier-north) url='wsc-east/ec-follypiernorthcam.stream/playlist.m3u8' ;;
    ps|pier-south) url='wsc-east/ec-follypiersouthcam.stream/playlist.m3u8' ;;
    f|frisco) url='wsc-east/ec-friscopiercam.stream/playlist.m3u8' ;;
    h|hatteras) url='wsc-east/ec-capehatterascam.stream/playlist.m3u8' ;;
    r|rockaway) url='wsc-east/ec-rockaway90thcam.stream/playlist.m3u8' ;;
    j|jacksonville) url='wsc-east/ec-jacksonvillepiercam.stream/playlist.m3u8' ;;
    ns|new-smyrna) url='wsc-east/ec-newsmycam.stream/playlist.m3u8' ;;
    sa|st-augustine) url='wsc-east/ec-staugustinecam.stream/playlist.m3u8' ;;
    pi|ponce-inlet) url='wsc-east/ec-ponceinletcam.stream/playlist.m3u8' ;;
  esac
  vlc "https://cams.cdn-surfline.com/$url"
}
