alias ls='ls -h --color=auto'
alias ll="ls -l"

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

alias du="du -h"
alias df="df -h"

alias grep='grep --color=auto'
alias j=z

alias history="history -E"

rg() {
  command rg --json -C2 "$@" | delta
  return "${PIPESTATUS[1]}"
}

alias ta="tmux new-session -A"
