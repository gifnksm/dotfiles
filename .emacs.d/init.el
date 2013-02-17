(require 'server)
(unless (server-running-p)
  (server-start))

;;; encoding config
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)

(cond
 ((eq window-system 'ns)
  (setq default-input-method "MacOSX")
  (mac-set-input-method-parameter "com.justsystems.inputmethod.atok25.Japanese" 'title "漢")
  (mac-set-input-method-parameter "com.justsystems.inputmethod.atok25.Japanese" 'cursor-type 'box)
  (mac-set-input-method-parameter "com.justsystems.inputmethod.atok25.Japanese" 'cursor-color "blue")
  (mac-set-input-method-parameter "com.justsystems.inputmethod.atok25.Roman" 'title "A")
  (mac-set-input-method-parameter "com.justsystems.inputmethod.atok25.Roman" 'cursor-type 'box)
  (mac-set-input-method-parameter "com.justsystems.inputmethod.atok25.Roman" 'cursor-color "white")
  (mac-set-input-method-parameter "com.apple.keylayout.US" 'title "A")
  (mac-set-input-method-parameter "com.apple.keylayout.US" 'cursor-type 'box)
  (mac-set-input-method-parameter "com.apple.keylayout.US" 'cursor-type "white")

  (define-key global-map [C-s-268632070] 'ns-toggle-fullscreen)
  (set-face-attribute 'default nil :family "menlo" :weight 'normal :height 125)
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0208 (font-spec :family "Hiragino Kaku Gothic ProN" :size 13) nil 'append)
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0212 (font-spec :family "Hiragino Kaku Gothic ProN" :size 13) nil 'append))
 ((eq window-system 'x)
  (set-face-attribute 'default nil :family "M+1MN" :weight 'normal :height 105)))

(when window-system
  (set-frame-parameter nil 'alpha '(85 70 70 70)))

;;; path config
(add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))
(add-to-list 'load-path (concat user-emacs-directory "el-get/el-get"))

(require 'my-utils)

(defun add-to-exec-path (path)
  (setenv "PATH" (concat path ":" (getenv "PATH")))
  (add-to-list 'exec-path path))

(cond
 ((equal (system-name) "MacBook-Pro.local")
  (add-to-exec-path "/usr/texbin")
  (add-to-exec-path "/usr/local/bin")))


;; el-get
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'el-get-recipe-path
             (concat user-emacs-directory "el-get-recipes"))
(setq el-get-user-package-directory
      (concat user-emacs-directory "el-get-init"))

(el-get 'sync '(el-get anything auto-complete auto-complete-clang auto-complete-emacs-lisp d-mode
                       descbinds-anything direx el-get fill-column-indicator flex-autopair
                       haskell-mode hlinum js2-mode key-combo linum-ex markdown-mode pkgbuild-mode
                       popwin pos-tip recentf-ext sequential-command undo-tree undohist zlc smartrep
                       region-bindings-mode multiple-cursors expand-region revive revive-plus auctex
                       auto-complete-latex))

(setq  recentf-save-file (concat user-emacs-directory "recentf"))

;;; completion
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
;; http://shakenbu.org/yanagi/d/?date=20120109#p01
;; find-fileで*Completions*バッファに`../'と`./'を出さない
(defun find-file-read-args (prompt mustmatch)
  (list (read-file-name prompt nil default-directory mustmatch nil
                        (lambda (name)
                          (and (file-exists-p name)
                               (not (member name '("../" "./"))))
                          ))
        t))



;;; user interface config
(setq-default indicate-empty-lines t)
(setq-default indent-tabs-mode nil)
(setq visible-bell t)
(line-number-mode t)              ;モードラインに表示
(column-number-mode t)            ;列番号をモードラインに表示
(show-paren-mode t)               ;括弧の対応付け

(setq mouse-drag-copy-region t)
(delete-selection-mode t)

;;; misc config
(setq make-backup-files nil)		;バックアップファイルを作成しない
(setq backup-inhibited t)
(setq delete-auto-save-files t)         ;終了時にバックアップファイルを消す

(setq view-read-only t)           ;読み込み専用にした時view-modeにする
(temp-buffer-resize-mode t) ; C-hv とか ファイル名補完時のウィンドウを自動的にリサイズする
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(tool-bar-mode -1)

(setq history-length 10000)
(savehist-mode 1)
(desktop-save-mode 1)

;;; key config
(define-many-keys global-map
  `(("C-S-h" . ,help-map)
    ("M-?" . help-for-help)
    ("C-h" . backward-delete-char-untabify)
    ("C-S-k" . backward-kill-line)
    ("C-x p" . previous-multiframe-window) ; C-x o の逆向きに Window を移動
    ("C-x C-b" . electric-buffer-list)))

(define-many-keys read-expression-map
  '(("TAB" . lisp-complete-symbol)))

;;; builtin modes (installed in system path)
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets
      uniquify-ignore-buffers-re "*[^*]+*")
(require 'generic-x)
(require 'wdired)
(setq wdired-allow-to-change-permissions t)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
(require 'dired-x)
(require 'hl-line)
(global-hl-line-mode 1)
(require 'linum)
(setq linum-format "%5d ")
(global-linum-mode t)
(set-fill-column 100)
(require 'whitespace)
(setq whitespace-style '(face trailing lines-tail tabs tab-mark
                              space-before-tab space-after-tab))
;; (global-whitespace-mode 1)

(defvar hs-fringe-mark 'right-arrow
  "*隠れた行の fringe に表示する bitmap 名。
`fringe-bitmaps' 内に設定されているシンボルから選ぶ。")
(defun hs-mark-fringe (ovr)
  "`hs-toggle-hiding' で隠された行の OVR を編集して fringe にマークを付ける。"
  (when (eq 'code (overlay-get ovr 'hs))
    (let ((hiding-text "...")
          (fringe-anchor (make-string 1 ?x)))
      (put-text-property 0 1 'display (list 'left-fringe hs-fringe-mark) fringe-anchor)
      (overlay-put ovr 'before-string fringe-anchor)
      (overlay-put ovr 'display hiding-text))))
(setq hs-set-up-overlay 'hs-mark-fringe)

(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/places")

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(setq-default flyspell-mode nil)
(setq ispell-dictionary "american")

(defun c-mode-common-hook-fn ()
  (c-toggle-electric-state 1)
  (c-toggle-auto-newline 1)
  (c-toggle-auto-state 1)
  (subword-mode 1)
  (setq c-default-style "bsd")
  (setq c-basic-offset 4)
  ;; (add-to-list 'ac-sources 'ac-source-clang)
  ;; (add-to-list 'ac-sources 'ac-source-clang-complete)
  )
(add-hook 'c-mode-common-hook 'c-mode-common-hook-fn)

(defun view-mode-hook-fn ()
  (define-many-keys view-mode-map
    '(("h" . backward-char)
      ("j" . next-line)
      ("k" . previous-line)
      ("l" . forward-char))))
(add-hook 'view-mode-hook 'view-mode-hook-fn)

(when (require 'mozc nil t)
  (require 'ccc)
  (setq default-input-method "japanese-mozc")
  (setq mozc-cand 'overlay)
  (setq mozc-color "blue")
  (defun mozc-change-cursor-color ()
    (if mozc-mode
        (progn
          (key-combo-mode 0)
          (set-buffer-local-cursor-color mozc-color))
      (progn
        (key-combo-mode 1)
        (set-buffer-local-cursor-color nil))))

  (add-hook 'input-method-activate-hook 'mozc-change-cursor-color)
  (add-hook 'input-method-inactivate-hook 'mozc-change-cursor-color))

(when (require 'rust-mode nil t)
  (defun rust-mode-hook-fn ()
    (setq fill-column 78)
    (subword-mode 1)
    (setq indent-tabs-mode nil)
    (setq c-basic-offset 4)
    (setq comment-style 'multi-line)
    (fci-mode 1))
  (add-hook 'rust-mode-hook 'rust-mode-hook-fn))

(when (require 'typescript nil t)
  (add-to-list 'auto-mode-alist '("\\.ts" . typescript-mode))
  (add-to-list 'ac-modes 'typescript-mode)
  (defun typescript-mode-hook-fn ()
    (subword-mode 1)
    (whitespace-mode 1))
  (add-hook 'typescript-mode-hook 'typescript-mode-hook-fn))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anything-command-map-prefix-key "C-:")
 '(custom-enabled-themes (quote (tango-2)))
 '(custom-safe-themes (quote ("e9a1226ffed627ec58294d77c62aa9561ec5f42309a1f7a2423c6227e34e3581" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
