(require 'region-bindings-mode)
(region-bindings-mode-enable)

(el-get 'sync 'multiple-cursors)
(when (featurep 'multiple-cursors)
  (define-many-keys region-bindings-mode-map
    '(("a" . mc/mark-all-like-this)
      ("p" . mc/mark-previous-like-this)
      ("n" . mc/mark-next-like-this)
      ("m" . mc/mark-more-like-this-extended))))

(el-get 'sync 'expand-region)
(when (featurep 'expand-region)
  (define-many-keys region-bindings-mode-map
    '(("h" . er/expand-region))))
