_stack-ghcid()
{
    local CMDLINE
    local IFS=$'\n'
    export COMP_LINE="${COMP_LINE/stack-ghcid/'stack ghci'}"
    export COMP_POINT=$(($COMP_POINT - 1))
    export COMP_WORDS=("stack" "ghci" "${COMP_WORDS[@]:1}" )
    export COMP_CWORD=$(($COMP_CWORD + 1))
    CMDLINE=(--bash-completion-index $COMP_CWORD)

    for arg in ${COMP_WORDS[@]}; do
        CMDLINE=(${CMDLINE[@]} --bash-completion-word $arg)
    done

    COMPREPLY=( $(stack "${CMDLINE[@]}") )
}

complete -o filenames -F _stack-ghcid stack-ghcid
