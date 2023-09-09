# shellcheck source-path=SCRIPTDIR/..

if ! [[ -x ~/.cargo/bin/rustup ]]; then
    install_module curl

    ACTION="installing rustup" execute bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -yq"
fi

if [[ -e ~/.cargo/env ]]; then
    # shellcheck source=/dev/null
    source ~/.cargo/env
fi

assert_command rustup
assert_command cargo
