# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: git-delta
    ubuntu_22_04: git-delta@cargo
    rocky_9: git-delta@cargo
END

assert_command delta

ensure_git_config core.pager delta
ensure_git_config interactive.diffFilter "delta --color-only"
