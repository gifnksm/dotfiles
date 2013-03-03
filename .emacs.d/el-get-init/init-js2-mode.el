(defun js2-mode-hook-fn ()
  (subword-mode 1)
  (whitespace-mode 1))
(add-hook 'js2-mode-hook 'js2-mode-hook-fn)
