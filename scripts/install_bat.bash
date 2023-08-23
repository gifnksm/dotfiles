# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    install_package_by_spec <<END
        arch: bat
        ubuntu-22.04: bat
        rocky-9: bat@epel
END

    if [[ "${OS_ID}" = "${OS_UBUNTU_22_04}" ]]; then
        SUDO=true ensure_symlink_exists /usr/bin/batcat /usr/local/bin/bat
    fi

    assert_command bat

}
group_end
