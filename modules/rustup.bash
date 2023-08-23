# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    if ! [[ -x ~/.cargo/bin/rustup ]]; then
        source modules/curl.bash

        info "Installing rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -yq
    fi

    # shellcheck source=/dev/null
    source ~/.cargo/env

    assert_command rustup
    assert_command cargo

    install_package_by_spec <<END
        arch: base-devel
        ubuntu-22.04: build-essential
        rocky-9: $(pkg_encode <<<"@Development Tools")
END
}
group_end
