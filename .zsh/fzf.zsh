if which sk > /dev/null 2>&1; then
  alias __fzfcmd=sk
elif which fzf > /dev/null 2>&1; then
  alias __fzfcmd=fzf
else
  echo "warning: sk or fzf are not installed" >&2
fi

function __fzf-exec() {
  if zle; then
    BUFFER="$@"
    zle accept-line
  else
    $@
  fi
}

function __fzf-message() {
  if zle; then
    zle -M "zsh: $1"
  else
    echo "zsh: $1" >&2
  fi
}

function __fzf-is-in-git-repo() {
  if ! git rev-parse HEAD > /dev/null 2>&1; then
    __fzf-message "not a git repository"
    return 1
  fi
  return 0
}

function __fzf-cd-repository() {
  local selected=$(rhq list | __fzfcmd --query="$LBUFFER" --exit-0 --prompt='CHANGE DIRECTORY> ')
  if [[ -n $selected ]]; then
    BUFFER="cd \"${selected}\""
    zle accept-line
  fi
  zle clear-screen
}

function __fzf-select-git-ref() {
  local fzf_target="${1}"
  local fzf_prompt="${2}"
  local fzf_query="${3}"
  [[ "${fzf_target}" =~ "\*" ]] && fzf_target+="btc"
  (
    [[ "${fzf_target}" =~ "b" ]] && git branch --color=always -a -vv | sed 's/^../B /';
    [[ "${fzf_target}" =~ "t" ]] && git tag    --color=always --sort -version:refname | sed 's/^/T /';
    [[ "${fzf_target}" =~ "c" ]] && git log    --color=always --date=short --format="%C(auto)%h %C(blue)%C(bold)%cd %C(green)%<(20)%an %C(auto)%d %C(reset)%s" | sed 's/^/C /';
  ) |
    __fzfcmd --prompt="${fzf_prompt}> " --query="${fzf_query}" --ansi --exit-0 --preview='git show --color=always {2} | delta' |
    awk '{print $2}'
}

function __fzf-select-files-to-be-staged() {
  git status --porcelain |
    sed -n '/^.[^ ]/s/^.//p' |
    sk --multi --ansi --tac --exit-0 --preview 'git diff {2} | delta' |
    sed 's/^..//'
}

function __fzf-input-git-ref-common() {
  __fzf-is-in-git-repo || return 1
  local fzf_target="${1}"
  local fzf_prompt="${2}"
  LBUFFER+="$(__fzf-select-git-ref "${fzf_target}" "${fzf_prompt}" "")"
}

function __fzf-git-checkout-common() {
  __fzf-is-in-git-repo || return 1
  local fzf_target="${1}"
  local fzf_prompt="${2}"
  local selected="$(__fzf-select-git-ref "${fzf_target}" "${fzf_prompt}" "${LBUFFER}" | sed 's#^remotes/[^/]*/##')"
  if [[ -n "${selected}" ]]; then
    __fzf-exec git checkout "${selected}"
  else
    __fzf-message "no refs selected"
  fi
}

function __fzf-input-git-ref()    { __fzf-input-git-ref-common "*" "INPUT GIT REF" }
function __fzf-input-git-branch() { __fzf-input-git-ref-common "b" "INPUT GIT BRANCH" }
function __fzf-input-git-tag()    { __fzf-input-git-ref-common "t" "INPUT GIT TAG" }
function __fzf-input-git-commit() { __fzf-input-git-ref-common "c" "INPUT GIT COMMIT" }
function __fzf-git-checkout()     { __fzf-git-checkout-common  "*" "GIT CHECKOUT" }
function __fzf-git-switch()       { __fzf-git-checkout-common  "b" "GIT SWITCH" }

function __fzf-git-add() {
  __fzf-is-in-git-repo || return 1
  local -a selected
  selected+=("$(__fzf-select-files-to-be-staged)")
  if [[ "${#selected[@]}" -gt 0 ]]; then
    __fzf-exec git add $@ ${selected[@]}
  else
    __fzf-message "no files selected"
  fi
}

while read key fn; do
  zle -N "${fn}"
  bindkey "${key}" "${fn}"
done <<END
^g      __fzf-cd-repository
^g^g    __fzf-cd-repository
^g^r    __fzf-input-git-ref
^g^b    __fzf-input-git-branch
^g^t    __fzf-input-git-tag
^g^l    __fzf-input-git-commit
^g^h    __fzf-git-checkout
^g^s    __fzf-git-switch
^g^a    __fzf-git-add
END
