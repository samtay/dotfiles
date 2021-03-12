# check cwd is in git repo
function _is_in_git_dir() {
  [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
}

# get repo root
_get_repo_root() {
  git rev-parse --show-toplevel
}

# check cwd is in a skel
_detect_skel() {
  _is_in_git_dir && \
    [ -d "$(_get_repo_root)/skel/bin" ]
}

# execute skel/bin/* commands from anywhere in repo
function ba-skel() {
  _detect_skel || { echo "skel not detected" ; return 1 }
  local repo_root=$(_get_repo_root);

  local command=$1
  if [ -z $command ]; then
    ls -l "$repo_root/skel/bin"
  elif [ -e "$repo_root/skel/bin/$command" ]; then
    shift
    $repo_root/skel/bin/$command $@
  else
    echo "skel/bin/$command not found" ; exit 1
  fi
}


