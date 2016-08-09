#compdef g2site

_sites_list () {
  _sanitized_dir=$(echo $SITES_DIR | sed -e "s/\//\\\\\//g")
  find $SITES_DIR -maxdepth 1 -mindepth 1 | sed -e "s/$_sanitized_dir//" | sed -e "s/\///g"
}

_g2site () {
  compadd `_sites_list`
}

compdef _g2site g2site

