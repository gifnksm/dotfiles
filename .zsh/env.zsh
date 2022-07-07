export EDITOR=vim
export PAGER=less

# Assing wsl-open as a browser for WSL
if [[ $(uname -r) =~ (m|M)icrosoft ]]; then
  if [[ -z $BROWSER ]]; then
    export BROWSER=wsl-open
  fi
fi
