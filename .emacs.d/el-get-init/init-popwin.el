(require 'popwin)
(global-set-key (kbd "C-x C-p") popwin:keymap)
(setq display-buffer-function 'popwin:display-buffer)
(push '(dired-mode :position top) popwin:special-display-config)
