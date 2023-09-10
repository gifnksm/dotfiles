# Description: zsh configuration file

## Load utility modules
autoload colors && colors # for escape sequence shorthands (`${fg[yellow]}` etc.`)

## History
mkdir -p ~/.local/share/zsh
# See zshparam(1) for details
HISTFILE=~/.local/share/zsh/history
HISTSIZE=100000
SAVEHIST=100000

# See zshoptions(1) for details
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

## Prompt
# Use starship for prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
    # startship sets PROMPT, RPROMPT, PROMPT2
    # for details, see zshparam(1)
fi
SPROMPT="%{${fg[yellow]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"

## Key binding
bindkey -e # Emacs keybinding

## Others
autoload -Uz compinit
compinit

# autoload predict-on
# predict-on

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

setopt auto_pushd
setopt pushd_ignore_dups
setopt equals
setopt magic_equal_subst
setopt numeric_glob_sort
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

# コマンドラインスタックを表示させる
show_buffer_stack() {
    POSTDISPLAY="
stack: $LBUFFER"
    zle push-line-or-edit
}
zle -N show_buffer_stack
bindkey "^q" show_buffer_stack
bindkey "^[q" show_buffer_stack
bindkey "^[Q" show_buffer_stack

limit coredumpsize unlimited
ulimit -c unlimited

() {
    for script in ~/.config/zsh/rc.d/*.zsh; do
        source "${script}"
    done
}
