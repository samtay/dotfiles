#compdef g2module

_modules_list () {
  local _sanitized_dir=$(echo $MODULES_DIR | sed -e "s/\//\\\\\//g")
  find $MODULES_DIR -maxdepth 1 -mindepth 1 | sed -e "s/$_sanitized_dir//" | sed -e "s/\///g"
}

_g2module () {
  compadd `_modules_list`
}

compdef _g2module g2module

