;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  NAKASHIMA, Makoto

;; Author: NAKASHIMA, Makoto <makoto.nksm@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; My init.el.

;;; Code:

(require 'url)
(require 'url-http)

;; proxy settings
(defun parse-proxy-env (protocol envname)
  (when (getenv envname)
    (let* ((url (getenv envname))
           (auth-info (replace-regexp-in-string "^https?://\\([^@]*\\)@.*$" "\\1" url))
           (hostport (replace-regexp-in-string "^https?://\\([^@]*@\\)?\\|/$" "" url)))
      (setenv envname hostport)
      (add-to-list 'url-proxy-services `(,protocol . ,hostport))
      (unless (string= auth-info "")
        (add-to-list 'url-http-proxy-basic-auth-storage `(,hostport ("Proxy" . ,(base64-encode-string auth-info))))))))

(parse-proxy-env "http" "HTTP_PROXY")
(parse-proxy-env "https" "HTTPS_PROXY")

;; workarond for emacs <= 27's bug
;; https://stackoverflow.com/a/64722682
;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=42422
(if (<= emacs-major-version 27)
    (with-eval-after-load 'url-http
      (defun url-https-proxy-connect (connection)
        (setq url-http-after-change-function 'url-https-proxy-after-change-function)
        (process-send-string connection (format (concat "CONNECT %s:%d HTTP/1.1\r\n"
                                                        "Host: %s\r\n"
                                                        (let ((proxy-auth (let ((url-basic-auth-storage
                                                                                 'url-http-proxy-basic-auth-storage))
                                                                            (url-get-authentication url-http-proxy nil 'any nil))))
                                                          (if proxy-auth (concat "Proxy-Authorization: " proxy-auth "\r\n")))
                                                        "\r\n")
                                                (url-host url-current-object)
                                                (or (url-port url-current-object)
                                                    url-https-default-port)
                                                (url-host url-current-object))))))

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

;; load path
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

;; install leaf
(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; ここにいっぱい設定を書く

(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

(leaf my-utils
  :doc "My utilities."
  :tag "out-of-MELPA"
  :added "2020-12-23"
  :require t
  :bind ("C-S-k" . backward-kill-line))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :added "2020-12-23"
  :custom '((create-lockfiles . nil)
            (enable-recursive-minibuffers . t)
            (history-length . 10000)
            (history-delete-duplicates . t)
            (text-quoting-style . 'straight)
            (truncate-lines . t)
            (indent-tabs-mode . nil)))

(leaf tango-2-theme
  :doc "Tango 2 color theme for GNU Emacs 24"
  :added "2020-12-23"
  :ensure t
  :config (load-theme 'tango-2 t))

(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :added "2020-12-23"
  :bind ("C-h" . backward-delete-char-untabify)
  :custom '((line-number-mode . t)
            (column-number-mode . t)))

(leaf frame
  :doc "multi-frame management independent of window systems"
  :tag "builtin" "internal"
  :added "2020-12-23"
  :bind ("C-x p" . previous-window-any-frame))

(leaf which-func
  :doc "print current function in mode line"
  :tag "builtin"
  :added "2020-12-23"
  :custom (which-function-mode . t))

(leaf savehist
  :doc "Save minibuffer history"
  :tag "builtin"
  :added "2020-12-23"
  :custom (savehist-mode . t))

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :added "2020-12-23"
  :custom '((inhibit-startup-screen . t)))

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :added "2020-12-23"
  :custom ((auto-revert-internal . 1))
  :global-minor-mode global-auto-revert-mode)

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :added "2020-12-23"
  :global-minor-mode delete-selection-mode)

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :added "2020-12-23"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :added "2020-12-23"
  :custom ((make-backup-files . nil)
           (backup-inhibited . t)
           (delete-auto-save-files . t)
           (view-read-only . t)))

(leaf help
  :doc "help commands for Emacs"
  :tag "builtin" "internal" "help"
  :added "2020-12-23"
  :custom (temp-buffer-resize-mode . t))

(leaf recentf
  :doc "setup a menu of recently opened files"
  :tag "builtin"
  :added "2020-12-23"
  :custom ((recentf-auto-cleanup . 600)
           (recentf-max-saved-items . 1000))
  :config
  (leaf recentf-ext
    :doc "Recentf extensions"
    :tag "files" "convenience"
    :added "2020-12-23"
    :url "http://www.emacswiki.org/cgi-bin/wiki/download/recentf-ext.el"
    :require t
    :ensure t))

(leaf desktop
  :doc "save partial status of Emacs when killed"
  :tag "builtin"
  :added "2020-12-23"
  :custom
  (desktop-save-mode . t))

(leaf generic-x
  :doc "A collection of generic modes"
  :tag "builtin" "font-lock" "comment" "generic"
  :added "2020-12-23"
  :require t)

(leaf dired
  :doc "directory-browsing commands"
  :tag "builtin" "files"
  :added "2020-12-23"
  :config
  (leaf dired-x
    :doc "extra Dired functionality"
    :tag "builtin" "files" "extensions" "dired"
    :added "2020-12-23"
    :require t)
  (leaf wdired
    :doc "Rename files editing their names in dired buffers"
    :tag "builtin"
    :added "2020-12-23"
    :require t
    :bind (dired-mode-map
           ("r" . wdired-change-to-wdired-mode))
    :custom ((wdired-allow-to-change-permissions . t))))

(leaf hl-line
  :doc "highlight the current line"
  :tag "builtin"
  :added "2020-12-23"
  :global-minor-mode global-hl-line-mode)

(leaf whitespace
  :doc "minor mode to visualize TAB, (HARD) SPACE, NEWLINE"
  :tag "builtin"
  :added "2020-12-23"
  :require t
  :global-minor-mode t
  :custom ((whitespace-line-column . nil)
           (whitespace-style . '(face trailing lines-tail tabs tab-mark
                                      space-before-tab space-after-tab))))

(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :added "2020-12-23"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :leaf-defer nil
  :custom ((ivy-intial-inputs-alias . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :bind ("C-M-z" . ivy-resume)
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :added "2020-12-23"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :after ivy
    ;; :bind ("C-s" . swiper)
    )

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :added "2020-12-23"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :after swiper
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :added "2020-12-23"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)

(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-5.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :added "2020-12-23"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

(leaf counsel-gtags
  :doc "ivy for GNU global"
  :req "emacs-25.1" "counsel-0.8.0" "seq-1.0"
  :tag "emacs>=25.1"
  :added "2020-12-23"
  :url "https://github.com/FelipeLema/emacs-counsel-gtags"
  :emacs>= 25.1
  :ensure t
  :after counsel
  :hook (c-mode-hook c++-mode-hook dired-mode-hook)
  :bind '(counsel-gtags-mode-map
          ("C-c f" . counsel-gtags-find-file)
          ("C-c s" . counsel-gtags-find-symbol)
          ("C-c r" . counsel-gtags-find-reference)
          ("C-c d" . counsel-gtags-find-definition)
          ("M-." . counsel-gtags-find-definition)
          ("M-*" . counsel-gtags-go-backward)))

(leaf projectile
  :doc "Manage and navigate projects in Emacs easily"
  :req "emacs-25.1" "pkg-info-0.4"
  :tag "convenience" "project" "emacs>=25.1"
  :added "2020-12-23"
  :url "https://github.com/bbatsov/projectile"
  :emacs>= 25.1
  :ensure t
  :global-minor-mode projectile
  :bind (projectile-mode-map
         ("C-c p" . projectile-command-map))
  :config
  (leaf ripgrep
    :doc "Front-end for ripgrep, a command line search tool"
    :tag "search" "grep" "sift" "ag" "pt" "ack" "ripgrep"
    :added "2020-12-23"
    :url "https://github.com/nlamirault/ripgrep.el"
    :ensure t)
  (leaf counsel-projectile
    :doc "Ivy integration for Projectile"
    :req "counsel-0.13.0" "projectile-2.0.0"
    :tag "convenience" "project"
    :added "2020-12-23"
    :url "https://github.com/ericdanan/counsel-projectile"
    :ensure t
    :after counsel projectile
    :global-minor-mode t))

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "tools" "languages" "convenience" "emacs>=24.3"
  :added "2020-12-23"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind '(("M-n" . flycheck-next-error)
          ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :added "2020-12-23"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode
  :config
  (leaf company-c-headers
    :doc "Company mode backend for C/C++ header files"
    :req "emacs-24.1" "company-0.8"
    :tag "company" "development" "emacs>=24.1"
    :added "2020-12-23"
    :emacs>= 24.1
    :ensure t
    :after company
    :defvar company-backends
    :config
    (add-to-list 'company-backends 'company-c-headers)))

(leaf undo-tree
  :doc "Treat undo history as a tree"
  :tag "tree" "history" "redo" "undo" "files" "convenience"
  :added "2020-12-23"
  :url "http://www.dr-qubit.org/emacs.php"
  :ensure t
  :global-minor-mode t)

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "async-20200113" "dash-20200524" "git-commit-20200516" "transient-20200601" "with-editor-20200522"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :added "2020-12-23"
  :emacs>= 25.1
  :ensure t
  :after git-commit with-editor)

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(create-lockfiles nil)
 '(enable-recursive-minibuffers t)
 '(history-delete-duplicates t)
 '(history-length 10000)
 '(imenu-list-position 'left t)
 '(imenu-list-size 30 t)
 '(indent-tabs-mode nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("org" . "https://orgmode.org/elpa/")))
 '(package-selected-packages
   '(counsel-gtags magit counsel-projectile tango-2-theme undo-tree ripgrep company-c-headers company flycheck recentf-ext projectile ivy-prescient prescient counsel swiper leaf-tree leaf-convert ivy hydra el-get blackout))
 '(text-quoting-style 'straight)
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
