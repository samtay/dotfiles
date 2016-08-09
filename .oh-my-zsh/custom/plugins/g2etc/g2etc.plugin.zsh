#compdef g2etc

_etc_list () {
  local _sanitized_dir=$(echo $ETC_DIR | sed -e "s/\//\\\\\//g")
  find $ETC_DIR -maxdepth 1 -mindepth 1 | sed -e "s/$_sanitized_dir//" | sed -e "s/\///g"
}

_g2etc () {
  compadd `_etc_list`
}

compdef _g2etc g2etc

