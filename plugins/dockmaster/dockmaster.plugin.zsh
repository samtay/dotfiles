#compdef dockmaster

_list_compositions () {
  if ! _is_in_docker_repo; then
    return "";
  fi
  local compositions_dir="$(_get_repo_root)/compositions"
  local escaped_compositions_dir=$(echo $compositions_dir | sed -e "s/\//\\\\\//g")
  find $compositions_dir -maxdepth 1 -mindepth 1 \
    | sed -e "s/$escaped_compositions_dir//" \
    | sed -e "s/\///g"
}

_dockmaster () {
  compadd `_list_compositions`
}

compdef _dockmaster dockmaster

