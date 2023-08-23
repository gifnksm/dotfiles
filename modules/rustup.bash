# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    if ! [[ -x ~/.cargo/bin/rustup ]]; then
        install_module curl

        info "Installing rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -yq
    fi

    # shellcheck source=/dev/null
    source ~/.cargo/env

    assert_command rustup
    assert_command cargo
}
group_end
