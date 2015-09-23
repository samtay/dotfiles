alias g2sites='cd /Volumes/Sites && ll'
alias copy-ssh-key='cat ~/.ssh/id_rsa.pub | pbcopy'
alias reload-zsh='source ~/.zshrc'
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
