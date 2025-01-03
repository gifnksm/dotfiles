const nu_config_dir = $nu.default-config-dir
const nu_scripts_dir = ($nu_config_dir | path join "nu_scripts")
const nu_aliases_dir = ($nu_scripts_dir | path join "aliases")

#export use ($nu_aliases_dir | path join "bat/bat-aliases.nu") *
export use ($nu_aliases_dir | path join "docker/docker-aliases.nu") *
#export use ($nu_aliases_dir | path join "eza/eza-aliases.nu") *
#export use ($nu_aliases_dir | path join "git/git-aliases.nu") *
