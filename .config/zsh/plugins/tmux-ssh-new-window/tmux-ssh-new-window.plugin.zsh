.tmux-ssh-new-window:ssh() {
    local has_command=false
    local destination=""
    local has_tty

    if [[ -t 0 ]] && [[ -t 1 ]] && [[ -t 2 ]]; then
        has_tty=true
    else
        has_tty=false
    fi

    local args=("$@")
    local i=0
    while [[ $i -lt ${#args} ]]; do
        local arg="${args:$i:1}"
        ((i += 1))

        case "$arg" in
        -*)
            if [[ "$arg" =~ ^(\-[^BbcDEeFIiJLlmOoPpQRSWw]*[BbcDEeFIiJLlmOoPpQRSWw])(.*)$ ]]; then
                # the flag has an argument
                arg="${match[1]}"
                if [[ -z "${match[2]}" ]]; then
                    # next arg is the argument to this option, so skip it
                    ((i += 1))
                fi
            fi

            if [[ $arg =~ T ]]; then
                has_tty=false
            fi
            ;;
        *)
            destination="$arg"
            break
            ;;
        esac
    done

    if [[ $i -lt ${#args} ]]; then
        has_command=true
    fi

    if ! $has_tty || $has_command || [[ -z "$destination" ]]; then
        command ssh "$@"
        return $?
    fi

    local window_name="${destination}"
    tmux -q \
        new-window -n "${window_name}" ssh "$@" \; \
        set -w remain-on-exit on
}

if [[ -n "${TMUX}" ]]; then
    alias ssh=".tmux-ssh-new-window:ssh"
fi
