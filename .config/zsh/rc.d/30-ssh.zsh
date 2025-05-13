if command -v keychain >/dev/null; then
    eval "$(keychain --nogui --eval --timeout 30 -q)"
fi
