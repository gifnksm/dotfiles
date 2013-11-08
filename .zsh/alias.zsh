alias updrc="source $HOME/.zshrc"
alias j="jobs -l -d"

alias ls='ls -h --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias la="ls -1"
alias grep='grep --color=auto'

alias etags_all="find -L -name \"*.[ch]\" -print | etags -"

if [ -f /usr/share/vim/vim72/macros/less.sh ]; then
    alias vless="/usr/share/vim/vim72/macros/less.sh"
elif [ -f /usr/share/vim/vim70/macros/less.sh ]; then
    alias vless="/usr/share/vim/vim70/macros/less.sh"
elif [ -f /usr/share/vim/vim63/macros/less.sh ]; then
    alias vless="/usr/share/vim/vim63/macros/less.sh"
fi

alias screen="screen -U"
alias history="history -E"
alias du="du -h"
alias df="df -h"
alias sc="screen -D -RR"
alias ta="tmux attach"

alias -g L='| less -r'
alias -g V="| vless"
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g W='| wc'
alias -g S='| sed'
alias -g A='| awk'
alias -g W='| wc'
