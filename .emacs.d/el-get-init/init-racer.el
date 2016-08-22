(setq racer-cmd "~/.cargo/bin/racer")
(cond ((file-exists-p "~/work/repos")
       (setq racer-rust-src-path "~/work/repos/rust-lang/rust/src"))
      ((file-exists-p "~/repos")
       (setq racer-rust-src-path "~/repos/rust-lang/rust/src")))

