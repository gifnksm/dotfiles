# shellcheck source-path=SCRIPTDIR/..

install_module starship
install_module git

install_package_by_spec <<END
    arch: nushell
    ubuntu-22.04: nu@cargo
    debian-12: nu@cargo
    rocky-9: nu@cargo
END

assert_command nu

cargo_install nu_plugin_skim

ensure_symlink_to_config_exists .config/nushell

execute git submodule update --init --depth 1

# register nu plugins
declare -A plugin_dirs
plugin_dirs=(
    ["${CARGO_HOME:-$HOME/.cargo}/bin"]=true
)

if command -v nu >/dev/null; then
    nu_dir="$(dirname "$(command -v nu)")"
    plugin_dirs["${nu_dir}"]=true
fi

readarray -t plugins < <(find -L "${!plugin_dirs[@]}" -maxdepth 1 -name "nu_plugin_*" -type f -executable)
for plugin in "${plugins[@]}"; do
    execute nu -c "plugin add \"${plugin}\""
done
