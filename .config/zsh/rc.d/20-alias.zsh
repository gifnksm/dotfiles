if command -v eza >/dev/null; then
  alias ls='eza --icons --group --git --sort Name --time-style=iso'
else
  alias ls='ls -h --color=auto'
fi
alias ll="ls -l"

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

alias du="du -h"
alias df="df -h"

alias history="history -i"

alias grep='grep --color=auto'
rg() {
  command rg --json -C2 "$@" | delta
  return "${PIPESTATUS[1]}"
}

alias ta="tmux new-session -A -s default"
