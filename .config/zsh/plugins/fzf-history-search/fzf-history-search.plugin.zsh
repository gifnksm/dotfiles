function fzf-history-search() {
    local candidates=(${(f)"$(builtin history -n -r 1 | fzf-tmux -p -w100% -h100% -- --reverse --query="${LBUFFER}" --prompt="History>")"})
    local ret=$?
    if [[ -n "$candidates" ]]; then
        BUFFER="${candidates[*]}"
        CURSOR=$#BUFFER
    fi
    zle reset-prompt
    return $ret
}

zle -N fzf-history-search
bindkey '^R' fzf-history-search
