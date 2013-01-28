(require 'sequential-command)
(define-sequential-command seq-home
  back-to-indentation beginning-of-line seq-return)
(define-sequential-command seq-end
  end-of-line seq-return)
(define-key global-map (kbd "C-a") 'seq-home)
(define-key global-map (kbd "C-e") 'seq-end)
