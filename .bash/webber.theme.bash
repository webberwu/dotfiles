#!/bin/bash
# shellcheck disable=SC2034

NORMAL="\[\e[0m\]"
TERMINAL_BG=16
ACCOUNT_FG=225
ACCOUNT_BG=162
INFO_FG=247
INFO_BG=238
INFO_HIGHTLIGHT_FG=208
ACCOUNT_ARROW_FG="${ACCOUNT_BG}"
ACCOUNT_ARROW_BG="${INFO_BG}"
PATH_FG=208
PATH_BG=236
VERSION_CONTROL_FG=15
VERSION_CONTROL_BG=106

function color() {
    # foreground: \[\e[38;5;$1m\]
    # background: \[\e[48;5;$2m\]
    echo "\[\e[38;5;$1m\]\[\e[48;5;$2m\]"
}

GIT_THEME_PROMPT_DIRTY="$(color 125 ${VERSION_CONTROL_BG}) ✗${NORMAL}"
GIT_THEME_PROMPT_CLEAN="$(color 22 ${VERSION_CONTROL_BG}) ✓${NORMAL}"
GIT_THEME_PROMPT_PREFIX="$(color ${VERSION_CONTROL_FG} ${VERSION_CONTROL_BG})"
GIT_THEME_PROMPT_SUFFIX="$(color ${VERSION_CONTROL_FG} ${VERSION_CONTROL_BG})"
SCM_GIT_SHOW_MINIMAL_INFO=false
SCM_THEME_PROMPT_DIRTY="${GIT_THEME_PROMPT_DIRTY}"
SCM_THEME_PROMPT_CLEAN="${GIT_THEME_PROMPT_CLEAN}"
SCM_THEME_PROMPT_PREFIX="${GIT_THEME_PROMPT_PREFIX}"
SCM_THEME_PROMPT_SUFFIX="${GIT_THEME_PROMPT_SUFFIX}"

function git_prompt_info() {
    git_prompt_vars
    echo "$(color ${PATH_BG} ${VERSION_CONTROL_BG})  ${SCM_PREFIX}${SCM_BRANCH}${SCM_STATE}${SCM_SUFFIX} $(color ${VERSION_CONTROL_BG} ${PATH_BG})"
}

function prompt_command() {
    PS1="${NORMAL}$(color ${ACCOUNT_FG} ${ACCOUNT_BG}) \u $(color ${ACCOUNT_ARROW_FG} ${ACCOUNT_ARROW_BG})"
    PS1+="${NORMAL}$(color ${INFO_FG} ${INFO_BG}) \t [$(color ${INFO_HIGHTLIGHT_FG} ${INFO_BG})\j$(color ${INFO_FG} ${INFO_BG})] $(color ${INFO_BG} ${PATH_BG})"
    PS1+="${NORMAL}$(color ${PATH_FG} ${PATH_BG}) \w $(scm_prompt_info)$(color ${PATH_BG} ${TERMINAL_BG})"
    PS1+="${NORMAL} "
}

safe_append_prompt_command prompt_command
