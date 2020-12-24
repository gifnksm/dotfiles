;;; my-utils.el --- My utilities. -*- lexical-binding: t; -*-

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

;; My utilities.

;;; Code:

(defun backward-kill-line (arg)
  "Kill ARG lines backward."
  (interactive "p")
  (kill-line (- 1 arg)))

(defadvice kill-region (around kill-line-or-kill-region activate)
  "If no region marked, kill the current line."
  (if (and (called-interactively-p 'interactive) transient-mark-mode (not mark-active))
      (kill-whole-line)
    ad-do-it))

(defadvice kill-ring-save (around kill-line-save-or-kill-ring-save activate)
  "If no region marked, copy the current line."
  (if (and (called-interactively-p 'interactive) transient-mark-mode (not mark-active))
      (copy-line 1)
    ad-do-it))

(defun copy-line (arg)
  "Copy ARG lines in the kill ring."
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(provide 'my-utils)

;;; my-utils.el ends here
