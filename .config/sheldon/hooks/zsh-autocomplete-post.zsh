# Make `Tab` go straight to the menu and cycle there
# source: https://github.com/marlonrichert/zsh-autocomplete#make-tab-go-straight-to-the-menu-and-cycle-there
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# Reset history key bindings to Zsh default
# Reset CtrlR and CtrlS
# source: https://github.com/marlonrichert/zsh-autocomplete/blob/main/CONFIGURATION.md#restore-zsh-default-history-shortcuts
bindkey '^R' .history-incremental-search-backward
bindkey -M emacs '^S' history-incremental-search-forward

# Disable zsh-autocomplete's behavior of adding a semicolon ';' to the end of history items.
# This prevents conflicts with zsh-abbr and zsh-autosuggestions.
zstyle ':autocomplete:*' add-semicolon no

