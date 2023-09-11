if [[ -z "${EDITOR:-}" ]]; then
  if command -v vim >/dev/null; then
    export EDITOR=vim
  fi
fi

if [[ -z "${PAGER:-}" ]]; then
  if command -v less >/dev/null; then
    export PAGER=less
  fi
fi

if [[ -z "${BROWSER:-}" ]]; then
  if [[ $(uname -r) =~ (m|M)icrosoft ]]; then
    if command -v wsl-open >/dev/null; then
      export BROWSER=wsl-open
    fi
  fi
fi

if [[ -z "${LS_COLORS:-}" ]]; then
  eval "$(dircolors)"
fi
if [[ -z "${ZLS_COLORS:-}" ]]; then
  export ZLS_COLORS="${LS_COLORS}"
fi
