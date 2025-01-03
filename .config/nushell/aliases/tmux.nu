export alias ta = tmux set-option -g default-shell (which nu | first | get path) ';' new-session -A -s default
