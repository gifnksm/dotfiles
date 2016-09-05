HISTFILE=~/.zsh/history
HISTSIZE=100000
SAVEHIST=100000
bindkey -e

autoload -Uz compinit
compinit

# autoload predict-on
# predict-on

autoload colors
colors

# source ~/.zprofile

setopt auto_cd appendhistory extendedglob notify
setopt prompt_subst
setopt nobeep
setopt long_list_jobs
setopt list_types
setopt auto_list
setopt auto_menu
setopt auto_param_keys
setopt auto_param_slash
setopt auto_remove_slash
setopt brace_ccl
setopt complete_aliases

setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt extended_history
setopt hist_verify

setopt auto_pushd
setopt pushd_ignore_dups
setopt equals
setopt magic_equal_subst
setopt numeric_glob_sort
setopt share_history
setopt correct
setopt noflowcontrol

setopt list_packed
setopt rec_exact

# source ~/.zsh/auto-fu.zsh
# function zle-line-init() {
#   auto-fu-init
# }
# zle -N zle-line-init
# zstyle ':auto-fu:var' postdisplay $''

case $(uname) in
    Darwin)
        eval `gdircolors`
        ;;
    Linux)
        eval `dircolors`
        ;;
esac
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _oldlist _complete _match _ignored \
    _approximate _list _history
zstyle ':completion:*:descriptions' format \
    "%F{yellow}%B%d%b%f"
zstyle ':completion:*:messages' format \
    "%F{yellow}%d%f"
zstyle ':completion:*:warnings' format \
    "%F{red}No matches for: %F{yellow}%d%f"
zstyle ':completion:*:options' desctiption 'yes'
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' group-name ''

[ -f ~/.git-completion.sh ] && source ~/.git-completion.sh

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"
  zstyle ':vcs_info:git:*' unstagedstr "-"
  zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
  zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u'
fi

function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%1(v|%F{green}%1v%f|)"

PROMPT="
%{$fg[green]%}(%n@%m)[%h] %{$fg[yellow]%}%~%{${reset_color}%}
%(!.#.$) "
PROMPT2="%{${fg[green]}%}%_> %{${reset_color}%}"
SPROMPT="%{${fg[yellow]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"

# コマンドラインスタックを表示させる
show_buffer_stack() {
  POSTDISPLAY="
stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack
bindkey "^[q" show_buffer_stack

limit coredumpsize unlimited
ulimit -c unlimited

# GNU screenのattach時に環境変数を自動的に引き継ぐ - 貳佰伍拾陸夜日記
# http://d.hatena.ne.jp/tarao/20101025/1287971794
typeset -ga preexec_functions
[ -f ~/.zsh/screen.zsh ] && source ~/.zsh/screen.zsh
[ -f ~/.zsh/screen-attach.zsh ] && source ~/.zsh/screen-attach.zsh
[ -f ~/.zsh/screen-alias.zsh ]  && source ~/.zsh/screen-alias.zsh

function ta() {
  if $(tmux has-session 2> /dev/null); then
    tmux attach
  else
    tmux
  fi
}

if which pbcopy > /dev/null 2>&1; then
  kill-line() { zle .kill-line ; echo -n $CUTBUFFER | pbcopy }
  zle -N kill-line # bound on C-k

  backward-kill-word() { zle .backward-kill-word ; echo -n $CUTBUFFER | pbcopy }
  zle -N backward-kill-word # bound on C-w

  copy-region-as-kill() { zle .copy-region-as-kill; echo -n $CUTBUFFER | pbcopy }
  zle -N copy-region-as-kill # bound on M-w
fi

#  yank() { LBUFFER=$LBUFFER$(pbpaste) }
#  zle -N yank # bound on C-y

[ -f ~/.zsh/alias.zsh ] && source ~/.zsh/alias.zsh
[ -f ~/.zsh/ssh.zsh   ] && source ~/.zsh/ssh.zsh
[ -f ~/.zsh/tmux.zsh  ] && source ~/.zsh/tmux.zsh
[ -f ~/.zsh/local.zsh ] && source ~/.zsh/local.zsh


# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# OPAM configuration
. $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
