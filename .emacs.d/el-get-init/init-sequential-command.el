(require 'sequential-command)
(define-sequential-command seq-home
  back-to-indentation beginning-of-line seq-return)
(define-sequential-command seq-end
  end-of-line seq-return)
(define-many-keys global-map
  '(("C-a" . seq-home)
    ("C-e" . seq-end)))
