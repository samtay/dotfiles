#compdef dm

#######
# utils

# check cwd is in git repo
_is_in_git_dir() {
  [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
}

# get repo root
_get_repo_root() {
  git rev-parse --show-toplevel
}

# check cwd is in devops-docker repo
_is_in_docker_repo() {
  _is_in_git_dir && \
    [[ $(git remote -v) =~ .*devops-docker.* ]] && \
    [ -d "$(_get_repo_root)/compositions" ]
}

# list compositions
_list_compositions() {
  local compositions_dir="$(_get_repo_root)/compositions"
  local escaped_compositions_dir=$(echo $compositions_dir | sed -e "s/\//\\\\\//g")
  find $compositions_dir -maxdepth 1 -mindepth 1 \
    | sed -e "s/$escaped_compositions_dir//" \
    | sed -e "s/\///g"
}

# wrapper around compadd
_compadd_compositions () {
  compadd $(_list_compositions)
}

_dm () {
  if ! _is_in_docker_repo; then
    return 1
  fi
  _arguments -s \
    '1: :_compadd_compositions' \
}

compdef _dm dm
