# Aliases
export MY_GIT_DIR="$HOME/code"
alias copy-ssh-key='copy-file ~/.ssh/id_rsa.pub'
alias reload-zsh='source ~/.zshrc'
alias ba-vpn="sudo openvpn --daemon /etc/openvpn/ba-client.conf"
alias wifi-scan='sudo iwlist wlp1s0 scan | grep ESSID'
alias wifi-rescan='nmcli d wifi rescan'
alias wifi-list='nmcli d wifi'
alias wifi-connect='nmcli -a -p -s d wifi connect'
alias get-simpsons-img='echo "http://imgur.com/a/T81t9copy" | copy'
alias ethernet='sudo ip link set dev enp61s0u1u2 up && sudo dhcpcd enp61s0u1u2'
alias sync-391-down='rsync -ae ssh --info=progress2 tays@madrid.stat.washington.edu:/mounts/costila/common/391stuff/ ~/uw/stat391/costila'
alias sync-391-up='rsync -ae ssh --info=progress2 ~/uw/stat391/upload-dir/ tays@madrid.stat.washington.edu:/mounts/costila/common/391stuff/sam-upload-dir'
alias sync-391='sync-391-up ; sync-391-down'


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
  cd "$MY_GIT_DIR/$1" && ls -Hlh --color=auto
}

backup() {
  mv $1{,.bak}
}

displays-toggle() {
  declare -a all_connected=( $( { xrandr -q || exit 1; } | awk '$2 == "connected" {print $1}' ) )


  [[ ${#all_connected[@]} = 0 ]] && {
      echo "no monitors connected"
      return 1
  }

  if xrandr --listmonitors | grep eDP-1 ; then
    for (( j=0; j<=${#all_connected[@]}; j++ )); do
        if [[ ! -z ${all_connected[$j]} ]]; then
          if [[ ${all_connected[$j]} != "eDP-1" ]]; then
            echo "Turning on ${all_connected[$j]}"
            xrandr --output ${all_connected[$j]} --auto
          fi
        fi
    done
    xrandr --output eDP-1 --off
  else
    xrandr --output eDP-1 --auto
    for (( j=0; j<=${#all_connected[@]}; j++ )); do
        if [[ ! -z ${all_connected[$j]} ]]; then
          if [[ ${all_connected[$j]} != "eDP-1" ]]; then
            echo "Turning off ${all_connected[$j]}"
            xrandr --output ${all_connected[$j]} --off
          fi
        fi
    done
  fi
}

copy() {
  xclip -sel clip
}

copy-file() {
  xclip -sel clip "$1"
}

watch() {
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

find-process() {
  ps aux | grep "$@"
}

fix-broken-symlinks() {
  find -L . -type l -exec rm {} \;
}

surfcam() {
  local cam="$1"
  if [ -z "$cam" ]; then
    read "cam?w: washout
ht: hightower
16: 16th st s
Pick one: "
  fi
  case $cam in
    w|washout) url='cdn-ec/ec-washout/chunklist.m3u8' ;;
    16) url='cdn-ec/ec-cocoastreets/chunklist.m3u8'
  esac
  vlc "https://cams.cdn-surfline.com/$url"
}
