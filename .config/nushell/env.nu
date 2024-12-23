# env.nu
#
# Installed by:
# version = "0.101.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

const nu_config_dir = $nu.default-config-dir
use ($nu_config_dir | path join "starship.nu")
use ($nu_config_dir | path join "jump.nu") *

const nu_scripts_dir = ($nu_config_dir | path join "nu_scripts")
const nu_completions_dir = ($nu_scripts_dir | path join "custom-completions")
use ($nu_completions_dir | path join "bat/bat-completions.nu") *
use ($nu_completions_dir | path join "cargo-make/cargo-make-completions.nu") *
use ($nu_completions_dir | path join "cargo/cargo-completions.nu") *
use ($nu_completions_dir | path join "curl/curl-completions.nu") *
use ($nu_completions_dir | path join "docker/docker-completions.nu") *
use ($nu_completions_dir | path join "eza/eza-completions.nu") *
use ($nu_completions_dir | path join "gh/gh-completions.nu") *
use ($nu_completions_dir | path join "git/git-completions.nu") *
use ($nu_completions_dir | path join "less/less-completions.nu") *
use ($nu_completions_dir | path join "make/make-completions.nu") *
use ($nu_completions_dir | path join "rg/rg-completions.nu") *
use ($nu_completions_dir | path join "rustup/rustup-completions.nu") *
use ($nu_completions_dir | path join "ssh/ssh-completions.nu") *
use ($nu_completions_dir | path join "tar/tar-completions.nu") *
