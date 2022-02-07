#!/bin/bash -eu
is_wsl=0
if grep 'WSL2$' /proc/sys/kernel/osrelease >> /dev/null; then
  is_wsl=1
fi

make_symlinks=(
  .colordiffrc
  .vim
  .zsh
  .zshrc
  .config/starship.toml
  .config/emacs
  .config/tmux
)

remove_symlinks=(
  .emacs.d
  .vimrc
  .tmux.conf
)

required_commands=(
  bat
  cargo-install-update
  delta
  emacs
  keychain
  rg
  rhq
  sk
  starship
  tig
  tmux
  topgrade
  zsh
)

required_git_configs=(
  user.name
  user.email
)

set_git_configs=(
  core.pager delta
  core.excludesfile ~/.config/git/ignore
  interactive.diffFilter "delta --color-only"
  pull.ff only
)
if [[ "$is_wsl" = 1 ]]; then
  set_git_configs+=(
    credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"
  )
fi

repo_dir="$(readlink -f "$(dirname "$0")")"
error() { echo -e "\e[31;1merror\e[m:" "$@" >&2; }
warn()  { echo -e "\e[33;1mwarning\e[m:" "$@" >&2; }
info()  { echo -e "\e[32;1minfo\e[m:" "$@" >&2; }

make_link() {
  local rel_target="${1}"
  local source_dir="${2:-${HOME}}"

  local target="${repo_dir}/${rel_target}"
  local source="${source_dir}/${rel_target}"

  if [[ -L "${source}" ]]; then
    local cur_target="$(readlink "${source}")"
    if [[ "${cur_target}" != "${target}" ]]; then
      warn "symbolic link already exists, which has different target: ${source} -> ${cur_target}"
      return
    fi
    info "symbolic link already exists, skip: ${source} -> ${cur_target}"
    return
  fi

  if [[ -e "${source}" ]]; then
    warn "file already exists: ${source}"
    return
  fi

  ln -sv "${target}" "${source}"
}

remove_link() {
  local rel_target="${1}"
  local source_dir="${2:-${HOME}}"

  local target="${repo_dir}/${rel_target}"
  local source="${source_dir}/${rel_target}"

  if [[ -L "${source}" ]]; then
    local cur_target="$(readlink "${source}")"
    if [[ "${cur_target}" != "${target}" ]]; then
      warn "symbolic link already exists, which has different target: ${source} -> ${cur_target}"
      return
    fi
    rm -v "${source}"
    return
  fi

  if [[ -e "${source}" ]]; then
    warn "file already exists: ${source}"
    return
  fi
  info "symbolik link already removed: ${source}"
}

check_installed() {
  local cmd="${1}"
  if ! command -v "${cmd}" > /dev/null; then
    warn "${cmd} is not installed"
    return
  fi
  info "${cmd} is installed: $(command -v "${cmd}")"
}

check_git_config() {
  local name="${1}"
  if ! git config "${name}" > /dev/null; then
    warn "git config ${name} is not set"
    return
  fi
  info "git config ${name} is set: $(git config "${name}")"
}

set_git_config() {
  local name="${1}"
  local value="${2}"

  if git config --global "${name}" > /dev/null; then
    local cur_value="$(git config --global "${name}")"
    if [[ "${cur_value}" != "${value}" ]]; then
      warn "git config already exists, which has different value: ${name} = ${cur_value}, expected ${value}"
      return
    fi
    info "git config already exists: ${name} = ${cur_value}"
    return
  fi

  git config --global "${name}" "${value}"
  info "git congit set: ${name} = ${value}"
}

main() {
  mkdir -pv ~/.config
  mkdir -pv ~/.config/git
  if [[ -e ~/.gitconfig ]]; then
    warn "git config is ~/.gitconfig"
  else
    touch ~/.config/git/config
    info "git config is ~/.config/git/config"
  fi

  local link
  for link in "${make_symlinks[@]}"; do
    make_link "${link}"
  done
  for link in "${remove_symlinks[@]}"; do
    remove_link "${link}"
  done

  local cmd
  for cmd in "${required_commands[@]}"; do
    check_installed "${cmd}"
  done

  local name
  for name in "${required_git_configs[@]}"; do
    check_git_config "${name}"
  done

  local i
  for ((i = 0; i < "${#set_git_configs[@]}"; i+=2)); do
    local name="${set_git_configs[$i]}"
    local value="${set_git_configs[$i+1]}"
    set_git_config "${name}" "${value}"
  done
}

main
