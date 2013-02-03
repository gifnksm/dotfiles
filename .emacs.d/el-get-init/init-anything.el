(require 'anything-config)
(define-many-keys global-map
  '(("C-;" . anything)
    ("C-M-y" . anything-show-kill-ring)))
(custom-set-variables '(anything-command-map-prefix-key "C-:"))

(el-get 'sync 'popwin)
(when (featurep 'popwin)
  (setq anything-samewindow nil)
  (push '("*anything*" :height 20) popwin:special-display-config))
