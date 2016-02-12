alias g2sites='cd /home/sites && ll'
alias g2modules='cd ~/modules'
alias g2innovation='cd ~/innovation'
alias copy-ssh-key='echo "todo:: fix this"'
alias reload-zsh='source ~/.zshrc'
alias ba-jump="ssh -o 'ProxyCommand ssh -W %h:%p jump'"
alias ba-jump-scp="scp -o 'ProxyCommand ssh -W %h:%p jump'"
copy-file(){
echo "todo:: fix this"
}
watch(){
  less +F $1
}

mysql-command() {
  echo "$1" | mysql -uroot -proot
}
