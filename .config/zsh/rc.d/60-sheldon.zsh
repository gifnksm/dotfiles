if command -v sheldon >/dev/null; then
    sheldon() {
        if command sheldon "$@"; then
            eval "$(command sheldon source)"
        fi
    }
    eval "$(command sheldon source)"
fi
