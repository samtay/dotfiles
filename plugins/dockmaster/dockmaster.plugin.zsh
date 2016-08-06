#compdef dockmaster

_list_compositions() {
  local compositions_dir="$(_get_repo_root)/compositions"
  local escaped_compositions_dir=$(echo $compositions_dir | sed -e "s/\//\\\\\//g")
  find $compositions_dir -maxdepth 1 -mindepth 1 \
    | sed -e "s/$escaped_compositions_dir//" \
    | sed -e "s/\///g"
}

_compadd_compositions () {
  compadd $(_list_compositions)
}

_dockmaster () {
  if ! _is_in_docker_repo; then
    return 1
  fi
  _arguments -s \
    '1: :_compadd_compositions' \
}

compdef _dockmaster dockmaster
