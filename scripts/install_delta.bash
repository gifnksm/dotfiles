# shellcheck source-path=SCRIPTDIR/..

is_executed && return

install_package_by_spec <<END
    arch: git-delta
    ubuntu-22.04: git-delta@cargo
    rocky-9: git-delta@cargo
END

assert_command delta

ensure_git_config core.pager delta
ensure_git_config interactive.diffFilter "delta --color-only"
