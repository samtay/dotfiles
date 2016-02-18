alias g2sites='cd /home/samtay/git/sites && ll'
alias g2modules='cd ~/git/modules'
alias g2innovation='cd ~/git/innovation'
alias copy-ssh-key='echo "todo:: fix this"'
alias reload-zsh='source ~/.zshrc'
alias ba-jump="ssh -o 'ProxyCommand ssh -W %h:%p jump'"
alias ba-jump-scp="scp -o 'ProxyCommand ssh -W %h:%p jump'"
alias ba-vpn="sudo openvpn --daemon /etc/openvpn/ba-client.conf"
alias wifi-scan="sudo iwlist wlp3s0 scan"

copy-file(){
echo "todo:: fix this"
}
watch(){
  less +F $1
}

mysql-command() {
  echo "$1" | mysql -uroot -proot
}
