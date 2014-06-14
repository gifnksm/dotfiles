(require 'key-combo)
(key-combo-mode 1)
(key-combo-load-default)
(defun key-combo-c-mode-hook-fn ()
  (key-combo-define-local (kbd "/") '(" / " "// " "//! " "//!< " "//!< [in] " "//!< [out] " "//!< [in,out] ")))
(add-hook 'c-mode-common-hook #'key-combo-c-mode-hook-fn)
