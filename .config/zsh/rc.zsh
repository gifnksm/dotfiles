() {
    for script in ~/.config/zsh/rc.d/*.zsh; do
        source "${script}"
    done
}
