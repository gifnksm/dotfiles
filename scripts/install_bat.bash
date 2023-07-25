# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: bat
    ubuntu_22_04: bat
    rocky_9: bat
END

if [[ "${OS_NAME}" = "${OS_UBUNTU_22_04}" ]]; then
    SUDO=true ensure_symlink_exists /usr/bin/batcat /usr/local/bin/bat
fi

assert_command bat
