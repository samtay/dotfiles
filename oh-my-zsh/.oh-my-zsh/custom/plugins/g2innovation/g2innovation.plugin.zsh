#compdef g2innovation

_innovation_list () {
  local _sanitized_dir=$(echo $INNOVATION_DIR | sed -e "s/\//\\\\\//g")
  find $INNOVATION_DIR -maxdepth 1 -mindepth 1 | sed -e "s/$_sanitized_dir//" | sed -e "s/\///g"
}

_g2innovation () {
  compadd `_innovation_list`
}

compdef _g2innovation g2innovation

