## History
mkdir -p ~/.local/share/zsh
HISTFILE=~/.local/share/zsh/history
HISTSIZE=100000
SAVEHIST=100000


## Completion
autoload -Uz compinit && compinit

# see zshcompsys(1) for details
if [[ -n "${LS_COLORS:-}" ]]; then
    zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
fi
zstyle ':completion:*:default' menu select=1

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitive completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _oldlist _complete _match _ignored _approximate _list _history
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' group-name ''

zstyle ':completion:*:descriptions' format \
    "%F{yellow}%B%d%b%f"
zstyle ':completion:*:messages' format \
    "%F{yellow}%d%f"
zstyle ':completion:*:warnings' format \
    "%F{red}No matches for: %F{yellow}%d%f"
zstyle ':completion:*:options' desctiption 'yes'


## Prompt
# Use starship for prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
    # startship sets PROMPT, RPROMPT, PROMPT2
fi
# Add color to SPROMPT
SPROMPT="%F{yellow}${SPROMPT}%f"


## Zle
bindkey -e # Emacs keybinding
