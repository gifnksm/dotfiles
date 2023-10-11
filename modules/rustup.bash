# shellcheck source-path=SCRIPTDIR/..

CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"

if ! [[ -x "${CARGO_HOME}/bin/rustup" ]]; then
    install_module curl

    ACTION="installing rustup" execute bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -yq"
fi

if [[ -e "${CARGO_HOME}/env" ]]; then
    # shellcheck source=/dev/null
    source "${CARGO_HOME}/env"
fi

assert_command rustup
assert_command cargo

# shellcheck disable=SC2016
ensure_line_not_in_file '. "$HOME/.cargo/env"' ~/.zshenv
# shellcheck disable=SC2016
ensure_line_in_file '. "${CARGO_HOME:-$HOME/.cargo}/env"' ~/.zshenv
