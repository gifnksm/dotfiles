# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: git-delta
END

assert_command delta

ensure_git_config core.pager delta
ensure_git_config interactive.diffFilter "delta --color-only"
