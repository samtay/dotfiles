# compdef ba-skel

function _ba-skel() {
  _detect_skel || return 1
  _files -W "$(_get_repo_root)/skel/bin"
}

compdef _ba-skel ba-skel
