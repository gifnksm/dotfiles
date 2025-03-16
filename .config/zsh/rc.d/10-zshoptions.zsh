# Description: setup zsh options
# see zshoptions(1) for details

## Changing Directories
setopt AUTO_CD
setopt AUTO_PUSHD
# unsetopt CDABLE_VARS
# unsetopt CD_SILENT
# unsetopt CHASE_DOTS
# unsetopt CHASE_LINKS
# unsetopt POSIX_CD
setopt PUSHD_IGNORE_DUPS
# unsetopt PUSHD_MINUS
# unsetopt PUSHD_SILENT
# unsetopt PUSHD_TO_HOME

## Completion
# setopt ALWAYS_LAST_PROMPT # <D>
# setopt AUTO_LIST # <D>
# setopt AUTO_MENU # <D>, overridden by MENU_COMPLETE
# unsetopt AUTO_NAME_DIRS
# setopt AUTO_PARAM_KEYS # <D>
# setopt AUTO_PARAM_SLASH # <D>
# setopt AUTO_REMOVE_SLASH # <D>
# unsetopt BASH_AUTO_LIST
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD
unsetopt GLOB_COMPLETE
# setopt HASH_LIST_ALL # <D>
# setopt LIST_AMBIGUOUS # <D>
unsetopt LIST_BEEP # <D>
setopt LIST_PACKED
setopt LIST_ROWS_FIRST
# setopt LIST_TYPES # <D>
setopt MENU_COMPLETE
unsetopt REC_EXACT

## Expansion and Globbing
# setopt BAD_PATTERN # <Z>
# setopt BARE_GLOB_QUAL # <Z>
setopt BRACE_CCL
# setopt CASE_GLOB # <Z>
# setopt CASE_MATCH # <Z>
# unsetopt CASE_PATHS
# unsetopt CSH_NULL_GLOB
# setopt EQUALS # <Z>
setopt EXTENDEDGLOB
# unsetopt FORCE_FLOAT
# setopt GLOB # <D>
# unsetopt GLOB_DOTS
# unsetopt GLOB_START_SHORT
# unsetopt GLOB_SUBST
# unsetopt HIST_SUBST_PATTERN
# unsetopt IGNORE_BRACES
# unsetopt IGNORE_CLOSE_BRACES
# unsetopt KSH_GLOB
setopt MAGIC_EQUAL_SUBST
# unsetopt MARK_DIRS
# setopt MULTIBYTE # <D>
# setopt NOMATCH # <Z>
# unsetopt NULL_GLOB
setopt NUMERIC_GLOB_SORT
# unsetopt RC_EXPAND_PARAM
# unsetopt REMATCH_PCRE
# unsetopt SH_GLOB
# unsetopt UNSET
# unsetopt WARN_CREATE_GLOBAL
# unsetopt WARN_NESTED_VAR

## History
# setopt APPEND_HISTORY # <D>
# setopt BAND_HISTORY # <Z>
setopt EXTENDED_HISTORY
# unsetopt HIST_ALLOW_CLOBBER
unsetopt HIST_BEEP # <D>
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_LEX_WORDS
# unsetopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
# setopt HIST_SAVE_BY_COPY # <D>
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
# unsetopt INC_APPEND_HISTORY
# unsetopt INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY

## Input/Output
# setopt ALIASES # <D>
# setopt CLOBBER # <D>
# unsetopt CLOBBER_EMPTY
setopt CORRECT
# setopt CORRECT_ALL
# unsetopt DVORAK
unsetopt FLOW_CONTROL # <D>
# unsetopt IGNORE_EOF
# unsetopt INTERACTIVE_COMMENTS
# setopt HASH_CMDS # <D>
# setopt HASH_DIRS # <D>
# unsetopt HASH_EXECUTABLES_ONLY
# unsetopt MAIL_WARNING
# unsetopt PATH_DIRS
# unsetopt PATH_SCRIPT
# unsetopt PRINT_EIGHT_BIT
setopt PRINT_EXIT_VALUE
# unsetopt RC_QUOTES
# unsetopt RM_STAR_SILENT
# unsetopt RM_STAR_WAIT
# setopt SHORT_LOOPS # <Z>
# unsetopt SHORT_REPEAT
# unsetopt SUN_KEYBOARD_HACK

## Job Control
# unsetopt AUTO_CONTINUE
# unsetopt AUTO_RESUME
# setopt BG_NICE # <Z>
# setopt CHECK_JOBS # <Z>
# setopt CHECK_RUNNING_JOBS # <Z>
# setopt HUP # <Z>
setopt LONG_LIST_JOBS
# setopt MONITOR # enabled by default in interactive shells
# setopt NOTIFY # <Z>
# unsetopt POSIX_JOBS

## Prompting
# unsetopt PROMPT_BANG
# setopt PROMPT_CD # <D>
# setopt PROMPT_SP # <D>
# setopt PROMPT_PERCENT # <Z>
setopt PROMPT_SUBST

## Zle
unsetopt BEEP # <D>
setopt COMBINING_CHARS
# setopt EMACS # `bindkey -e` is reccomended
# unsetopt OVERSTRIKE
# unsetopt SINGLE_LINE_ZLE
# unsetopt VI
# setopt ZLE # enabled by defailt in interactive shells
