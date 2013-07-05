(defun define-many-keys (key-map key-table)
  (loop for (key . cmd) in key-table
        do (define-key key-map (read-kbd-macro key) cmd)))

;; カーソル位置から行頭までにある文字を削除
(defun backward-kill-line (arg)
  "Kill chars backward until encountering the end of a line."
  (interactive "p")
  (kill-line 0))

;; リージョンを選択していないときに行をキルするコマンド
(defadvice kill-region (around kill-line-or-kill-region activate)
  (if (and (interactive-p) transient-mark-mode (not mark-active))
      (kill-whole-line)
    ad-do-it))

;; リージョンを選択していないときに行をコピーするコマンド
(defadvice kill-ring-save (around kill-line-save-or-kill-ring-save activate)
  (if (and (interactive-p) transient-mark-mode (not mark-active))
      (copy-line 1)
    ad-do-it))

;; http://dev.ariel-networks.com/Members/matsuyama/tokyo-emacs-02
;; http://www.emacswiki.org/emacs/CopyingWholeLines
(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

;; http://qiita.com/yewton@github/items/d9e686d2f2a092321e34
(defun update-gtags (&optional prefix)
  (interactive "P")
  (let ((rootdir (gtags-get-rootpath))
        (args (if prefix "-v" "-iv")))
    (when rootdir
      (let* ((default-directory rootdir)
             (buffer (get-buffer-create "*update GTAGS*")))
        (with-current-buffer buffer
          (erase-buffer)
          (let ((result (process-file "gtags" nil buffer nil args)))
            (if (= 0 result)
                (message "GTAGS successfully updated.")
              (message "update GTAGS error with exit status %d" result))))))))

(provide 'my-utils)
