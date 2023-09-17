if command -v keychain >/dev/null; then
    eval "$(keychain --nogui --eval --agents ssh --timeout 30 -q)"
fi
