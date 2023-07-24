# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: ripgrep
    ubuntu_22_04: ripgrep
END

assert_command rg
