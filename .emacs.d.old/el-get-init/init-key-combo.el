(require 'key-combo)
(key-combo-mode 1)
(key-combo-load-default)
(defun key-combo-c-mode-hook-fn ()
  (key-combo-define-local (kbd "/") '(" / " "// " "//! " "//!< " "//!< [in] " "//!< [out] " "//!< [in,out] ")))
(defun key-combo-c++-mode-hook-fn ()
  "My key-combo C++ setting."
  (key-combo-define-local (kbd "//") "// ")
  (key-combo-define-local (kbd "/*") "/* `!!' */")
  (key-combo-define-local (kbd "/**") "/**\n*`!!'\n*/")
  (key-combo-define-local (kbd "::") "::")
  ;; (key-combo-define-local (kbd ">") '(key-combo-execute-orignal " >> "))
  ;; (key-combo-define-local (kbd "<") '(" < " " << "))
)
(add-hook 'c-mode-common-hook #'key-combo-c-mode-hook-fn)
(add-hook 'c++-mode-hook 'key-combo-c++-mode-hook-fn)
