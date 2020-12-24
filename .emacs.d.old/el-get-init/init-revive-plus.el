(el-get 'sync 'revive)
(require 'revive+)
(setq revive-plus:all-frames t)
(revive-plus:demo)
(add-hook 'auto-save-hook 'desktop-save-in-desktop-dir)

