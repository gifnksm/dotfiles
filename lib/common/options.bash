# shellcheck source-path=SCRIPTDIR/../..

is_executed && return

source vendor/getoptions.sh

parser_definition() {
    setup REST_ARGS help:usage -- "Usage: $0 [options]... [modules]..."
    msg -- "Options:"

    flag FLG_LIST_MODULES -l --list-modules -- "List available modules"
    flag FLG_LIST_INSTALLED --list-installed -- "list installed modules"
    flag FLG_DRY_RUN -n --dry-run -- "Dry run"
    param OPT_PROFILE -p --profile -- "Profile to install"
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
