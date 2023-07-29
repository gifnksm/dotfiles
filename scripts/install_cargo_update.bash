# shellcheck source-path=SCRIPTDIR/..

# requires rust toolchain
source scripts/install_rustup.bash

install_package_by_spec <<END
    arch: cargo-update
    ubuntu-22.04: cargo-update@cargo
    rocky-9: cargo-update@cargo
END

assert_command cargo-install-update
