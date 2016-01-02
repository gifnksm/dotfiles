(require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)

(setq company-tooltip-align-annotations t)
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 2)
(setq company-selection-wrap-around t)

;; workaround https://github.com/company-mode/company-mode/issues/180
(defvar-local company-fci-mode-on-p nil)

(defun company-turn-off-fci (&rest ignore)
  (when (boundp 'fci-mode)
    (setq company-fci-mode-on-p fci-mode)
    (when fci-mode (fci-mode -1))))

(defun company-maybe-turn-on-fci (&rest ignore)
  (when company-fci-mode-on-p (fci-mode 1)))

(add-hook 'company-completion-started-hook 'company-turn-off-fci)
(add-hook 'company-completion-finished-hook 'company-maybe-turn-on-fci)
(add-hook 'company-completion-cancelled-hook 'company-maybe-turn-on-fci)

(eval-after-load "company"
  '(progn
     (define-many-keys company-active-map
       '(("C-S-h" . company-show-doc-buffer)
         ("C-h" . delete-backward-char)
         ("C-i" .  company-complete)))))

;; (define-many-keys global-map
;;   '(("C-S-i" . company-manual-begin)))
