case $(uname) in
    Linux)
        alias ls='ls -h --color=auto'
        ;;
    Darwin)
        alias ls="ls -Gh"
        ;;
esac
alias l.='ls -d .*'
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias du="du -h"
alias df="df -h"

alias grep='grep --color=auto'
alias where="command -v"

alias updrc="source $HOME/.zshrc"
alias etags_all="find -L -name \"*.[ch]\" -print | xargs etags"
alias j=z
alias vim="vim -X"
alias view="vim -R"
alias vless=$(echo /usr/share/vim/vim*/macros/less.sh)

alias screen="screen -U"
alias history="history -E"
alias sc="screen -D -RR"

alias -g L='| less -r'
alias -g V="| vless"
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g W='| wc'
alias -g S='| sed'
alias -g A='| awk'
alias -g W='| wc'

alias sd='svn diff --diff-cmd=colordiff'
alias sl='svn log --stop-on-copy'
normsd() { svn diff --diff-cmd diff -x -q $@ | sed -n '/.c$/s/^Index: //p' | sort | xargs svn diff $@ }

rgl() {
  rg -p "$@" | less -XFR
}
alias rg=rgl

alias ga=__fzf-git-add
alias gc=__fzf-git-checkout
alias gs=__fzf-git-switch

