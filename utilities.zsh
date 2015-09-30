alias g2sites='cd /Volumes/Sites && ll'
alias g2modules='cd ~/modules'
alias copy-ssh-key='cat ~/.ssh/id_rsa.pub | pbcopy'
alias reload-zsh='source ~/.zshrc'
alias ba-jump="ssh -o 'ProxyCommand ssh -W %h:%p jump'"
alias ba-jump-scp="scp -o 'ProxyCommand ssh -W %h:%p jump'"
copy-file(){
  cat $1 | pbcopy
}
watch(){
  less +F $1
}

UNCHY_DIR=$(dirname `gem which lunchy`)/../extras
if [ -f $LUNCHY_DIR/lunchy-completion.bash ]; then
  . $LUNCHY_DIR/lunchy-completion.bash
fi

mysql-command() {
  echo "$1" | mysql -uroot -proot
}
