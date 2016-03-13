alias g2sites='cd /home/samtay/git/sites && ll'
alias g2modules='cd ~/git/modules'
alias g2innovation='cd ~/git/innovation'
alias copy-ssh-key='echo "todo:: fix this"'
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

copy-file(){
echo "todo:: fix this"
}
watch(){
  less +F $1
}

mysql-command() {
  echo "$1" | mysql -uroot -proot
}
