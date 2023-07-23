# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: ripgrep
END

assert_command rg
