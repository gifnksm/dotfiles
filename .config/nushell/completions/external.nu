const nu_config_dir = $nu.default-config-dir
const nu_scripts_dir = ($nu_config_dir | path join "nu_scripts")
const nu_completions_dir = ($nu_scripts_dir | path join "custom-completions")
export use ($nu_completions_dir | path join "bat/bat-completions.nu") *
export use ($nu_completions_dir | path join "cargo-make/cargo-make-completions.nu") *
export use ($nu_completions_dir | path join "cargo/cargo-completions.nu") *
export use ($nu_completions_dir | path join "curl/curl-completions.nu") *
export use ($nu_completions_dir | path join "docker/docker-completions.nu") *
export use ($nu_completions_dir | path join "eza/eza-completions.nu") *
export use ($nu_completions_dir | path join "gh/gh-completions.nu") *
export use ($nu_completions_dir | path join "git/git-completions.nu") *
export use ($nu_completions_dir | path join "less/less-completions.nu") *
export use ($nu_completions_dir | path join "make/make-completions.nu") *
export use ($nu_completions_dir | path join "rg/rg-completions.nu") *
export use ($nu_completions_dir | path join "rustup/rustup-completions.nu") *
export use ($nu_completions_dir | path join "ssh/ssh-completions.nu") *
export use ($nu_completions_dir | path join "tar/tar-completions.nu") *
