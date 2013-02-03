(smartrep-define-key global-map "C-c"
  '(("{" . 'shrink-window-horizontally)
    ("}" . 'enlarge-window-horizontally)
    ("+" . 'balance-windows)
    ("^" . enlarge-window)
    ("%" . (enlarge-window -1))))

