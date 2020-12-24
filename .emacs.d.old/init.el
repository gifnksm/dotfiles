
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(require 'server)
(unless (server-running-p)
  (server-start))

(require 'url)
(require 'url-http)

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

;;; encoding config
(set-language-environment "Japanese")
(setenv "LANG" "ja_JP.UTF-8")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)

(defun my-set-font (height ascii-font jp-font)
  (let ((ascii-fontspec (font-spec :family ascii-font))
        (jp-fontspec    (font-spec :family jp-font)))
    (set-face-attribute 'default nil :family ascii-font :height height)
    (set-fontset-font nil 'japanese-jisx0213.2004-1 jp-fontspec)
    (set-fontset-font nil 'japanese-jisx0213-2      jp-fontspec)
    (set-fontset-font nil 'japanese-jisx0212        jp-fontspec)
    (set-fontset-font nil 'japanese-jisx0208        jp-fontspec)
    (set-fontset-font nil 'katakana-jisx0201        jp-fontspec)
    (set-fontset-font nil '(#x0080 . #x024F) ascii-fontspec)
    (set-fontset-font nil '(#x0370 . #x03FF) ascii-fontspec)))

(cond
 ((eq window-system 'ns)
  (setq default-input-method "MacOSX")
  (define-key global-map [C-s-268632070] 'toggle-fullscreen)

  (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
  (set-fontset-font "fontset-menlokakugo" 'unicode (font-spec :family "Hiragino Kaku Gothic ProN" :size 16) nil 'append)
  (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo")))

 ((eq window-system 'x)
  (my-set-font 120 "Inconsolata" "Ricty")))

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

(when window-system
  (set-frame-parameter nil 'alpha '(85 70 70 70)))

;;; path config
(add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))
(add-to-list 'load-path (concat user-emacs-directory "el-get/el-get"))

(require 'my-utils)

(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

(defun add-to-exec-path (path)
  (setenv "PATH" (concat path ":" (getenv "PATH")))
  (add-to-list 'exec-path path))

(cond
 ((equal (system-name) "MacBook-Pro.local")
  (add-to-exec-path "/Library/TeX/texbin")))
(add-to-exec-path "/usr/local/bin")
(add-to-exec-path "/usr/share/gtags/script/")

;; el-get
(setq el-get-dir "~/.emacs.d/el-get/")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(add-to-list 'el-get-recipe-path
             (concat user-emacs-directory "el-get-recipes"))
(setq el-get-user-package-directory
      (concat user-emacs-directory "el-get-init"))

;; Misc
(el-get 'sync '(el-get))
(el-get 'sync '(cl-lib))
(el-get 'sync '(f))
(el-get 'sync '(projectile))
(el-get 'sync '(magit))

;;; Utilities
(el-get 'sync '(helm))
(el-get 'sync '(helm-gtags))
(el-get 'sync '(helm-descbinds))
(el-get 'sync '(helm-projectile))
(el-get 'sync '(direx popwin shell-pop))
(el-get 'sync '(zlc))
(el-get 'sync '(pos-tip))
(el-get 'sync '(keychain-environment))

(el-get 'sync '(undo-tree undohist))
(el-get 'sync '(revive revive-plus))
(el-get 'sync '(recentf-ext))
(el-get 'sync '(wgrep))

;;; Input
(el-get 'sync '(flex-autopair))
(el-get 'sync '(auto-complete auto-complete-clang))
(el-get 'sync '(company-mode))
(el-get 'sync '(sequential-command smartrep))
(el-get 'sync '(key-combo))

;;; Visual
(el-get 'sync '(fill-column-indicator))

;;; Languages
(el-get 'sync '(gtags))
(el-get 'sync '(doxymacs))
(el-get 'sync '(graphviz-dot-mode))
(el-get 'sync '(flycheck))

;;; Documents
(el-get 'sync '(markdown-mode))
(el-get 'sync '(yaml-mode))
(el-get 'sync '(toml-mode))

;;; System
(el-get 'sync '(pkgbuild-mode))

(setq recentf-save-file (concat user-emacs-directory "recentf"))

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


;;; Edit
(setq-default indent-tabs-mode nil)
(delete-selection-mode t)

;;; user interface config
;; モードライン
(line-number-mode t)              ;行番号表示
(column-number-mode t)            ;列番号
(which-function-mode t)           ;関数名
;; 表示系
(setq-default indicate-empty-lines t)
(setq visible-bell nil)
(show-paren-mode t)
;; GUI
(tool-bar-mode -1)
(setq mouse-drag-copy-region t)
;; Others
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)

;;; misc config
(setq make-backup-files nil)            ;バックアップファイルを作成しない
(setq backup-inhibited t)
(setq delete-auto-save-files t)         ;終了時にバックアップファイルを消す

(setq view-read-only t)           ;読み込み専用にした時view-modeにする
(temp-buffer-resize-mode t) ; C-hv とか ファイル名補完時のウィンドウを自動的にリサイズする

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
    ("C-x C-b" . electric-buffer-list)
    ("C-x j" . skk-mode)))

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
(defun global-hl-line-timer-function ()
  (global-hl-line-unhighlight-all)
  (let ((global-hl-line-mode t))
    (global-hl-line-highlight)))
(setq global-hl-line-timer
      (run-with-idle-timer 0.03 t 'global-hl-line-timer-function))
;; (cancel-timer global-hl-line-timer)
;; (global-hl-line-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(require 'whitespace)
(setq whitespace-line-column nil
      whitespace-style '(face trailing lines-tail tabs tab-mark
                              space-before-tab space-after-tab))
(global-whitespace-mode 1)

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

(require 'tramp)
(add-to-list 'tramp-remote-path 'tramp-own-remote-path) ;リモートで設定される PATH を利用する

(defun after-change-major-mode-hook-fn ()
  (unless (eq major-mode 'rust-mode)
    (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p nil t)))
(add-hook 'after-change-major-mode-hook 'after-change-major-mode-hook-fn)

(setq-default flyspell-mode nil)
(setq ispell-dictionary "american")

(add-to-list 'auto-mode-alist '("\\.zsh" . sh-mode))

(setq c-default-style "k&r")
(defun c-mode-common-hook-fn ()
  (setq c-basic-offset 4)
  (subword-mode 1)
  (setq whitespace-line-column 120)
  (setq fill-column 120)
  (setq fci-rule-column 120)
  (fci-mode 1)
  (whitespace-mode 1)
  (helm-gtags-mode)
  ;; (gtags-mode)

  (c-toggle-hungry-state 1)
  (c-toggle-auto-hungry-state 1)
  (c-toggle-electric-state 1)
  (c-toggle-auto-newline 1)
  (c-toggle-auto-state 1)

  ;; (add-to-list 'ac-sources 'ac-source-clang)
  ;; (add-to-list 'ac-sources 'ac-source-clang-complete)
  )
(add-hook 'c-mode-common-hook 'c-mode-common-hook-fn)
;; (add-hook 'after-save-hook 'update-gtags)

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anything-command-map-prefix-key "C-:")
 '(custom-enabled-themes '(tango-2))
 '(custom-safe-themes
   '("e9a1226ffed627ec58294d77c62aa9561ec5f42309a1f7a2423c6227e34e3581" default))
 '(package-selected-packages '(sequential-command key-combo))
 '(rust-format-on-save t)
 '(rust-rustfmt-bin "~/.cargo/bin/rustfmt")
 '(shell-pop-universal-key "C-S-q")
 '(skk-check-okurigana-on-touroku 'ask)
 '(skk-kakutei-key (kbd "C-S-j"))
 '(skk-show-annotation t)
 '(skk-show-inline 'vertical)
 '(skk-show-tooltip t)
 '(skk-use-color-cursor t)
 '(skk-user-directory "~/.emacs.d/ddskk"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
