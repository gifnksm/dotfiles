# shellcheck source-path=SCRIPTDIR/../..

is_executed && return

# shellcheck source=/dev/null
source vendor/getoptions.sh

parser_definition() {
    setup REST help:usage -- "Usage: $0 [options]..."
    msg -- "Options:"

    param OPT_LOG_LEVEL -l --log-level -- "Log level"
    disp :usage -h --help
}

eval "$(getoptions parser_definition parse_args_body)"

_option_parsed=false

parse_args() {
    if "${_option_parsed}"; then
        trace "parse_args: already parsed"
        return 0
    fi
    _option_parsed=true

    parse_args_body "$@"

    set_log_level "${OPT_LOG_LEVEL:-info}"
}
