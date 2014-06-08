(require 'helm-config)
(define-many-keys global-map
  '(("C-;" . helm-mini)
    ("C-M-y" . helm-show-kill-ring)))

(el-get 'sync 'popwin)
(when (featurep 'popwin)
  (setq helm-samewindow nil)
  (push '("helm" :regexp t :height 20) popwin:special-display-config))
