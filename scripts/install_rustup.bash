# shellcheck source-path=SCRIPTDIR/..

if ! [[ -x ~/.cargo/bin/rustup ]]; then
    info "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -yq

    # shellcheck source=/dev/null
    source ~/.cargo/env
fi

assert_command rustup
assert_command cargo
