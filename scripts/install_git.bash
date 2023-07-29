# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: git
    ubuntu-22.04: git
    rocky-9: git
END

assert_command git

ensure_git_config core.excludesfile ~/.config/git/ignore
ensure_git_config pull.ff only

virt="$(systemd-detect-virt)"
if [[ "${virt}" = "wsl" ]]; then
    ensure_git_config credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
fi

ensure_line_in_file ".vscode/" ~/.config/git/ignore
