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
(let ((parse-proxy-env
       (lambda (protocol envname)
         (when (getenv envname)
           (let* ((url (getenv envname))
                  (auth-info (replace-regexp-in-string "^https?://\\([^@]*\\)@.*$" "\\1" url))
                  (hostport (replace-regexp-in-string "^https?://\\([^@]*@\\)?\\|/$" "" url)))
             (add-to-list 'url-proxy-services `(,protocol . ,hostport))
             (unless (string= auth-info "")
               (add-to-list 'url-http-proxy-basic-auth-storage `(,hostport ("Proxy" . ,(base64-encode-string auth-info))))))))))
  (funcall parse-proxy-env "http" "HTTP_PROXY")
  (funcall parse-proxy-env "https" "HTTPS_PROXY"))

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
    ;; (leaf hydra :ensure t)
    ;; (leaf el-get :ensure t)
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

(leaf mule-cmds
  :doc "commands for multilingual environment"
  :tag "builtin" "i18n" "mule"
  :added "2020-12-24"
  :config
  (set-language-environment "Japanese")
  (setenv "LANG" "ja_JP.UTF-8")
  (prefer-coding-system 'utf-8-unix)
  (set-default-coding-systems 'utf-8-unix))

(leaf font
  :config
  (set-face-attribute 'default nil :height 120)
  (let ((set-base-font
         (lambda (name)
           (when (member name (font-family-list))
             (set-face-attribute 'default nil :family name)
             t)))
        (set-jp-font
         (lambda (name)
           (when (member name (font-family-list))
             (let ((spec (font-spec :family name)))
               (set-fontset-font nil 'japanese-jisx0213.2004-1 spec)
               (set-fontset-font nil 'japanese-jisx0213-2      spec)
               (set-fontset-font nil 'japanese-jisx0212        spec)
               (set-fontset-font nil 'japanese-jisx0208        spec)
               (set-fontset-font nil 'katakana-jisx0201        spec))
             t)))
        (set-symbol-font
         (lambda (name)
           (when (member name (font-family-list))
             (let ((spec (font-spec :family name)))
               (set-fontset-font nil 'symbol spec))
             t))))
    (or
     (funcall set-base-font "HackGenNerd Console")
     (funcall set-base-font "Ricty"))
    (or
     (funcall set-jp-font "HackGenNerd Console")
     (funcall set-jp-font "Ricty"))
    (or
     (funcall set-symbol-font "Noto Color Emoji"))))

;; Sample texts
;;  !"#$%&'()*+,-./
;; 0123456789:;<=>?
;; @ABCDEFGHIJKLMNO
;; PQRSTUVWXYZ[\]^_
;; `abcdefghijklmno
;; pqrstuvwxyz{|}~
;; にほんご
;; ニホンゴ
;; 日本語
;; ばびぶべぼ
;; ぱぴぷぺぽ
;; 😊

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
            (indent-tabs-mode . nil)
            (menu-bar-mode .  nil)
            (tool-bar-mode . nil)))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :added "2020-12-24"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :added "2021-02-15"
  :custom '(safe-local-variable-values . '((clang-format-on-save))))

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

(leaf executable
  :doc "base functionality for executable interpreter scripts"
  :tag "builtin"
  :added "2021-01-03"
  :hook (after-save-hook . executable-make-buffer-file-executable-if-script-p))

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

(leaf display-line-numbers
  :doc "interface for display-line-numbers"
  :tag "builtin"
  :added "2020-12-24"
  :global-minor-mode global-display-line-numbers-mode)

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

(leaf xt-mouse
  :doc "support the mouse when emacs run in an xterm"
  :tag "builtin"
  :added "2020-12-23"
  :global-minor-mode xterm-mouse-mode)

(leaf cc-mode
  :doc "user customization variables for CC Mode"
  :tag "builtin"
  :added "2020-12-24"
  :custom (c-default-style . ((java-mode . "java")
                              (awk-mode .  "awk")
                              (other . "k&r")))
  :defvar (c-basic-offset)
  :defun (c-toggle-auto-hungry-state c-toggle-hungry-state c-toggle-electric-state c-toggle-auto-newline c-toggle-auto-state)
  :hook (c-mode-common-hook
         . (lambda ()
             (setq c-basic-offset 4)
             (subword-mode t)
             (setq fill-column 120)
             (c-toggle-auto-hungry-state 1)
             (c-toggle-hungry-state 1)
             (c-toggle-electric-state 1)
             (c-toggle-auto-newline 1)
             (c-toggle-auto-state 1)))
  :config
  (leaf clang-format
    :doc "Format code using clang-format"
    :req "cl-lib-0.3"
    :tag "c" "tools"
    :added "2020-12-24"
    :ensure t
    :config
    (leaf clang-format+
      :doc "Minor mode for automatic clang-format application"
      :req "emacs-25.1" "clang-format-20180406.1514"
      :tag "clang-format" "c++" "c" "emacs>=25.1"
      :added "2020-12-24"
      :url "https://github.com/SavchenkoValeriy/emacs-clang-format-plus"
      :emacs>= 25.1
      :ensure t
      :after clang-format
      :hook (c-mode-common-hook . clang-format+-mode))))

;; this conflicts with ivy
;; (leaf view
;;   :doc "peruse file or buffer without editing"
;;   :tag "builtin"
;;   :added "2020-12-24"
;;   :bind (("h" . backward-char)
;;          ("j" . next-line)
;;          ("k" . previous-line)
;;          ("l" . forward-char)))

(leaf flex-autopair
  :doc "Automatically insert pair braces and quotes, insertion conditions & actions are highly customizable."
  :tag "input" "keyboard"
  :added "2020-12-24"
  :url "https://github.com/uk-ar/flex-autopair.el"
  :ensure t
  :global-minor-mode t)

(leaf mwim
  :doc "Switch between the beginning/end of line or code"
  :tag "convenience"
  :added "2021-05-06"
  :url "https://github.com/alezost/mwim.el"
  :ensure t
  :bind (("C-a" . mwim-beginning)
         ("C-e" . mwim-end)))

;; (leaf key-combo
;;   :doc "map key sequence to commands"
;;   :tag "input" "keyboard"
;;   :added "2020-12-24"
;;   :url "https://github.com/uk-ar/key-combo"
;;   :ensure t
;;   :require t
;;   :global-minor-mode t
;;   :hook ((c-mode-common-hook . (lambda ()
;;                                  (key-combo-define-local (kbd "/") '(" / " "// " "//! " "//!< " "//!< [in] " "//!< [out] " "//!< [in,out] ")))))
;;   :config
;;   ;; overwrite default configurations
;;   (setq key-combo-global-default
;;         '(("C-a" . (back-to-indentation move-beginning-of-line))))
;;   (key-combo-load-default))

;; (leaf fill-column-indicator
;;   :doc "Graphically indicate the fill column"
;;   :tag "convenience"
;;   :added "2020-12-24"
;;   :ensure t
;;   :hook (c-mode-common-hook . fci-mode))

(leaf highlight-indent-guides
  :doc "Minor mode to highlight indentation"
  :req "emacs-24.1"
  :tag "emacs>=24.1"
  :added "2021-01-06"
  :url "https://github.com/DarthFennec/highlight-indent-guides"
  :emacs>= 24.1
  :ensure t
  :hook (prog-mode-hook . highlight-indent-guides-mode)
  :custom
    (highlight-indent-guides-auto-enabled .  t)
    (highlight-indent-guides-responsive . t)
    (highlight-indent-guides-method . 'fill))

(leaf rainbow-delimiters
  :doc "Highlight brackets according to their depth"
  :tag "tools" "lisp" "convenience" "faces"
  :added "2021-01-06"
  :url "https://github.com/Fanael/rainbow-delimiters"
  :ensure t
  :hook (prog-mode-hook . rainbow-delimiters-mode))

(leaf popwin
  :doc "Popup Window Manager"
  :req "emacs-24.3"
  :tag "convenience" "emacs>=24.3"
  :added "2021-01-06"
  :url "https://github.com/emacsorphanage/popwin"
  :emacs>= 24.3
  :ensure t
  :global-minor-mode popwin-mode
  :defvar (popwin:keymap popwin:special-display-config)
  :custom (popwin:close-popup-window-timer-inteval .  0.5)
  :config
  (global-set-key (kbd "C-x C-p") popwin:keymap)
  (push '("^\\*Cargo.*" :regexp t :position right :width 80) popwin:special-display-config))

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

(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :added "2020-12-23"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :leaf-defer nil
  :defvar (ivy-format-functions-alist)
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
  (leaf ivy-rich
    :doc "More friendly display transformer for ivy"
    :req "emacs-25.1" "ivy-0.13.0"
    :tag "ivy" "convenience" "emacs>=25.1"
    :added "2021-01-06"
    :url "https://github.com/Yevgnen/ivy-rich"
    :emacs>= 25.1
    :ensure t
    :after ivy
    :global-minor-mode t
    :config
    (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))
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
    :global-minor-mode t
    :config
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
              ("M-*" . counsel-gtags-go-backward)))))

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
    ;; :after counsel projectile
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
          ("C-h" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("C-i" . company-complete-selection)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode
  :config
  (leaf company-prescient
    :doc "prescient.el + Company"
    :req "emacs-25.1" "prescient-5.0" "company-0.9.6"
    :tag "extensions" "emacs>=25.1"
    :added "2020-12-23"
    :url "https://github.com/raxod502/prescient.el"
    :emacs>= 25.1
    :ensure t
    :after prescient company))

(leaf undo-tree
  :doc "Treat undo history as a tree"
  :tag "tree" "history" "redo" "undo" "files" "convenience"
  :added "2020-12-23"
  :url "http://www.dr-qubit.org/emacs.php"
  :ensure t
  :global-minor-mode global-undo-tree-mode)

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "async-20200113" "dash-20200524" "git-commit-20200516" "transient-20200601" "with-editor-20200522"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :added "2020-12-23"
  :emacs>= 25.1
  :ensure t
  :after git-commit with-editor)

(leaf highlight-doxygen
  :doc "Highlight Doxygen comments"
  :tag "faces"
  :added "2020-12-24"
  :url "https://github.com/Lindydancer/highlight-doxygen"
  :ensure t
  :global-minor-mode highlight-doxygen-global-mode
  :custom-face (highlight-doxygen-comment
                . '((((background light)) :inherit font-lock-doc-face :background "grey95")
                    (((background dark))  :inherit font-lock-doc-face :background "grey15"))))

(leaf yasnippet
  :doc "Yet another snippet extension for Emacs"
  :req "cl-lib-0.5"
  :tag "emulation" "convenience"
  :added "2020-12-25"
  :url "http://github.com/joaotavora/yasnippet"
  :ensure t
  :hook (after-init-hook . yas-global-mode)
  :config
  (leaf yasnippet-snippets
    :doc "Collection of yasnippet snippets"
    :req "yasnippet-0.8.0"
    :tag "snippets"
    :added "2020-12-25"
    :url "https://github.com/AndreaCrotti/yasnippet-snippets"
    :ensure t
    :after yasnippet)
  (leaf ivy-yasnippet
    :doc "Preview yasnippets with ivy"
    :req "emacs-24.1" "cl-lib-0.6" "ivy-0.10.0" "yasnippet-0.12.2" "dash-2.14.1"
    :tag "convenience" "emacs>=24.1"
    :added "2020-12-25"
    :url "https://github.com/mkcms/ivy-yasnippet"
    :emacs>= 24.1
    :ensure t
    :after ivy yasnippet
    :bind (("C-c y" . ivy-yasnippet)
           ("C-c C-y" . ivy-yasnippet))))

(leaf lsp-mode
  :doc "LSP mode"
  :req "emacs-26.1" "dash-2.14.1" "dash-functional-2.14.1" "f-0.20.0" "ht-2.0" "spinner-1.7.3" "markdown-mode-2.3" "lv-0"
  :tag "languages" "emacs>=26.1"
  :added "2020-12-25"
  :url "https://github.com/emacs-lsp/lsp-mode"
  :emacs>= 26.1
  :ensure t
  ;; :after spinner markdown-mode lv
  :hook ((c-mode-hook . lsp-deferred)
         (rust-mode-hook . lsp-deferred))
  :custom ((lsp-rust-server . 'rust-analyzer))
  :config
  (define-key lsp-mode-map (kbd "C-M-l") lsp-command-map)
  (leaf lsp-ui
    :doc "UI modules for lsp-mode"
    :req "emacs-26.1" "dash-2.14" "dash-functional-1.2.0" "lsp-mode-6.0" "markdown-mode-2.3"
    :tag "tools" "languages" "emacs>=26.1"
    :added "2020-12-25"
    :url "https://github.com/emacs-lsp/lsp-ui"
    :emacs>= 26.1
    :ensure t
    ;; :after lsp-mode markdown-mode
    ))

(leaf rust-mode
  :doc "A major emacs mode for editing Rust source code"
  :req "emacs-25.1"
  :tag "languages" "emacs>=25.1"
  :added "2021-01-05"
  :url "https://github.com/rust-lang/rust-mode"
  :emacs>= 25.1
  :ensure t
  :custom ((rust-format-on-save . t))
  :config
  (leaf cargo
  :doc "Emacs Minor Mode for Cargo, Rust's Package Manager."
  :req "emacs-24.3" "rust-mode-0.2.0" "markdown-mode-2.4"
  :tag "tools" "emacs>=24.3"
  :added "2021-01-05"
  :emacs>= 24.3
  :ensure t
  :hook ((rust-mode-hook . cargo-minor-mode))))

(provide 'init)

;;; init.el ends here
