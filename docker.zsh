# utility for directory of compositions
function dockmaster() {
  # check proper usage
  if ! _is_in_docker_repo; then
    echo "Compositions directory not found -- are you in devops-docker?"
    return 1;
  fi
  if [ -z "$1" ]; then
    echo "dockmaster requires a <composition> argument"
    return 1;
  fi
  local composition_dir="$(_get_repo_root)/compositions/$1" && shift
  if [ ! -d "$composition_dir" ]; then
    echo "composition directory not found: $composition_dir"
    return 1;
  fi

  # forward args to docker-compose, executing from composition directory
  cd "$composition_dir"
  docker-compose $@
  cd ~-
}

# check cwd is in git repo
function _is_in_git_dir() {
  [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
}

# get repo root
function _get_repo_root() {
  git rev-parse --show-toplevel
}

# check cwd is in devops-docker repo
function _is_in_docker_repo() {
   _is_in_git_dir && \
   [[ $(git remote -v) =~ .*devops-docker.* ]] && \
   [ -d "$(_get_repo_root)/compositions" ]
}
