stack-ghcid()
{
  local testopt=""
  local commandopt=""
  if [ "$1" = "-t" ]; then
    commandopt="$2 $3 --ghci-options=-fobject-code"
    testopt="--test=main"
  else
    commandopt="$@"
  fi
  ghcid \
    --clear \
    --reverse-errors \
    --no-height-limit \
    -c 'stack ghci '"$commandopt"'' \
    "$testopt"
}

stack-clean()
{
find . -name .stack-work | xargs rm -rf
}

prun()
{
  (
    cd ~/git/range
    stack run portal-runner -- "$@"
  )
}
