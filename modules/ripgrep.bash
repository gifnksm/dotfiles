# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: ripgrep
    ubuntu-22.04: ripgrep
    debian-11: ripgrep
    rocky-9: ripgrep@epel
END

assert_command rg
