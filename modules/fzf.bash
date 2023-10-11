# shellcheck source-path=SCRIPTDIR/..

if [[ "${OS_ID}" == "${OS_ROCKY_9}" ]]; then
    if ! [[ -x ~/.local/bin/fzf ]]; then
        install_module git
        ensure_directory_exists ~/.local/share/fzf
        execute git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.local/share/fzf
        execute ~/.local/share/fzf/install --bin
        ensure_symlink_exists ~/.local/share/fzf/bin/fzf ~/.local/bin/fzf
        ensure_symlink_exists ~/.local/share/fzf/bin/fzf-tmux ~/.local/bin/fzf-tmux
    fi
else
    install_package_by_spec <<END
        arch: fzf
        ubuntu-22.04: fzf
        debian-12: fzf
END
    assert_command fzf
fi
