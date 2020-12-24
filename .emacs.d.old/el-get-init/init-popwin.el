(require 'popwin)
(global-set-key (kbd "C-x C-p") popwin:keymap)
(setq popwin:close-popup-window-timer-interval 0.5)
(popwin-mode 1)
