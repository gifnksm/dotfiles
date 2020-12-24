(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(define-many-keys global-map
  '(("C-:" . helm-projectile)))
