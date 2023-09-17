if command -v keychain >/dev/null; then
    eval "$(keychain --nogui --eval --agents ssh --timeout 30 -q)"
fi

if [ -n "$TMUX" ]; then
    function ssh() {
        local has_command=false
        local destination=""
        local has_tty

        if [[ -t 1 ]]; then
            has_tty=true
        else
            has_tty=false
        fi

        local args=("$@")
        local i=0
        while [[ $i -lt ${#args} ]]; do
            local arg="${args:$i:1}"
            case "$arg" in
            -*)
                # Only if the last character is a flag that takes an argument, skip the next argument.
                # This is to handle the case of `ssh -i identity_file` or `ssh -iidentity_file`
                if [[ "$arg" =~ [BbcDEeFIiJLlmOoPpQRSWw]$ ]]; then
                    ((i += 2))
                else
                    ((i += 1))
                fi
                ;;
            *)
                destination="$arg"
                ((i += 1))
                break
                ;;
            esac
        done

        if [[ $i -lt ${#args} ]]; then
            has_command=true
        fi

        if $has_command || [[ -z "$destination" ]]; then
            command ssh "$@"
            return $?
        fi

        local window_name="${destination}"
        tmux -q \
            new-window -n "${window_name}" ssh "$@" \; \
            set -w remain-on-exit on
    }
fi
