HISTFILE=~/.zsh/history
HISTSIZE=5000
SAVEHIST=10000
setopt appendhistory autocd extendedglob
bindkey -e

autoload -Uz compinit
compinit

# autoload predict-on
# predict-on

autoload -U colors
colors

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

zstyle ':completion:*:default' menu select=1
eval `dircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

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

set_prompt() {
    local host_color
    case "$HOST" in
        minuano) host_color="cyan"   ;;
        paris)   host_color="yellow" ;;
        pnem-00) host_color="red"    ;;
    esac

    PROMPT="
%{$fg[green]%}%n@%{$fg[$host_color]%}%m %{$fg[yellow]%}[%~]%{$reset_color%}
%(!.#.$) "
}

set_prompt
PROMPT2="%{${fg[green]}%}%_> %{${reset_color}%}"
SPROMPT="%{${fg[yellow]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"

ulimit -c unlimited

[ -f ~/.zsh/alias.zsh ] && source ~/.zsh/alias.zsh
[ -f ~/.zsh/ssh.zsh   ] && source ~/.zsh/ssh.zsh
[ -f ~/.zsh/local.zsh ] && source ~/.zsh/local.zsh
