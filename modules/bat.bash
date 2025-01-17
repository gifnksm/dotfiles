# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: bat
    ubuntu-24.04: bat
    debian-12: bat
    rocky-9: bat@epel
END

case "${OS_ID}" in
"${OS_UBUNTU_24_04}" | "${OS_DEBIAN_12}")
    SUDO=true ensure_symlink_exists /usr/bin/batcat /usr/local/bin/bat
    ;;
esac

assert_command bat
