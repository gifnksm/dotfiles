# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: git
    ubuntu-22.04: git ca-certificates
    rocky-9: git
END

assert_command git

ensure_git_config_added include.path ~/.config/git/config.d/index

ensure_git_config_included base.conf

# detect virtual environment
if command -v systemd-detect-virt >/dev/null; then
    virt="$(systemd-detect-virt)"
elif [[ -e ~/.dockerenv ]]; then
    virt=docker
elif grep -qE "(Microsoft|WSL)" /proc/version; then
    virt=wsl
else
    virt=unknown
fi

if [[ "${virt}" = "wsl" ]]; then
    ensure_git_config_included wsl.conf
fi

ensure_line_in_file ".vscode/" ~/.config/git/ignore

# remove old settings
ensure_git_config_unset pull.ff only
ensure_git_config_unset core.excludesfile ~/.config/git/ignore
ensure_git_config_unset credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
ensure_git_config_unset credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
ensure_git_config_unset credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"

# initialize git repository if needed
if ! [[ -d .git ]]; then
    info "initializing git repository"
    ACTION="" execute git init -q
    ACTION="" execute git remote add origin https://github.com/gifnksm/dotfiles.git
    ACTION="" execute git fetch -q --depth 1 origin
    ACTION="" execute git reset -q --mixed origin/main
fi
