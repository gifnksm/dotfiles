alias __fzfcmd=sk

function __fzf-is-in-git-repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

function __fzf-cd-repositories() {
  local selected=$(rhq list | __fzfcmd --prompt='REPOS> ' --query="$LBUFFER")
  if [[ -n $selected ]]; then
    BUFFER="cd \"${selected}\""
    zle accept-line
  fi
  zle clear-screen
}

function __fzf-select-git-branch() {
  __fzf-is-in-git-repo || return 1
  git branch -a -vv --color=always |
    sed 's/^..//' |
    __fzfcmd --prompt='BRANCH> ' --query="${1:-}" --ansi --preview='git show --color=always {1}' |
    awk '{print $1}'
}

function __fzf-select-git-tag() {
  __fzf-is-in-git-repo || return 1
  git tag --color=always --sort -version:refname |
    __fzfcmd --prompt='TAG> ' --query="${1:-}" --ansi --preview='git show --color=always {}'
}

function __fzf-input-git-branch() { LBUFFER+="$(__fzf-select-git-branch)" }
function __fzf-git-switch-branch() {
  local query="${LBUFFER}"
  local selected="$(__fzf-select-git-branch "${query}" | sed 's#^remotes/[^/]*/##')"
  if [[ -n "${selected}" ]]; then
    BUFFER="git checkout \"${selected}\""
    zle accept-line
  fi
  zle clear-screen
}

function __fzf-input-git-tag() { LBUFFER+="$(__fzf-select-git-tag)" }
function __fzf-git-switch-tag() {
  local query="${LBUFFER}"
  local selected="$(__fzf-select-git-tag "${query}")"
  if [[ -n "${selected}" ]]; then
    BUFFER="git checkout \"${selected}\""
    zle accept-line
  fi
  zle clear-screen
}

zle -N __fzf-cd-repositories
bindkey '^g' __fzf-cd-repositories
zle -N __fzf-input-git-branch
bindkey '^g^b' __fzf-input-git-branch
zle -N __fzf-git-switch-branch
bindkey '^g^s^b' __fzf-git-switch-branch
zle -N __fzf-input-git-tag
bindkey '^g^t' __fzf-input-git-tag
zle -N __fzf-git-switch-tag
bindkey '^g^s^t' __fzf-git-switch-tag
