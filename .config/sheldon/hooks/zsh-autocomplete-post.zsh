# Make `Tab` go straight to the menu and cycle there
# source: https://github.com/marlonrichert/zsh-autocomplete#make-tab-go-straight-to-the-menu-and-cycle-there
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# Reset history key bindings to Zsh default
# Reset CtrlR and CtrlS
# source: https://github.com/marlonrichert/zsh-autocomplete#reset-ctrlr-and-ctrls
zle -A {.,}history-incremental-search-backward
zle -A {.,}vi-history-search-backward
bindkey -M emacs '^S' history-incremental-search-forward
bindkey -M vicmd '/' vi-history-search-forward
