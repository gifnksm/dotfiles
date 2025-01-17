# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: git-delta
    ubuntu-24.04: git-delta@cargo
    debian-12: git-delta@cargo
    rocky-9: git-delta@cargo
END

assert_command delta

ensure_git_config_included delta.conf

# remove old settings
ensure_git_config_unset core.pager delta
ensure_git_config_unset interactive.diffFilter "delta --color-only"
