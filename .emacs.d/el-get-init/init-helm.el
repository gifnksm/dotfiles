(require 'helm-config)
(define-many-keys global-map
  '(("C-;" . helm-mini)
    ("C-M-y" . helm-show-kill-ring)
    ("C-M-z" . helm-resume)))

;; (define-key helm-map (kbd "C-h") 'delete-backward-char)
;; (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)

(el-get 'sync 'popwin)
(when (featurep 'popwin)
  (setq helm-samewindow nil)
  (push '("helm" :regexp t :height 20) popwin:special-display-config))
