(require 'helm-gtags)
(setq helm-gtags-auto-update t)
(define-many-keys helm-gtags-mode-map
  '(("C-]" . helm-gtags-find-tag-from-here)
    ("C-<" . helm-gtags-previous-history)
    ("C->" . helm-gtags-next-history)
    ("M-*" . helm-gtags-pop-stack)
    ("M-." . helm-gtags-find-tag)
    ("C-c P" . helm-gtags-find-file)
    ("C-c r" . helm-gtags-find-rtag)
    ("C-c s" . helm-gtags-find-symbol)
    ("C-c t" . helm-gtags-find-tag)))

