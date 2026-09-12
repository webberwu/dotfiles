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
SCM_THEME_PROMPT_DIRTY="${GIT_THEME_PROMPT_DIRTY}"
SCM_THEME_PROMPT_CLEAN="${GIT_THEME_PROMPT_CLEAN}"
SCM_THEME_PROMPT_PREFIX="${GIT_THEME_PROMPT_PREFIX}"
SCM_THEME_PROMPT_SUFFIX="${GIT_THEME_PROMPT_SUFFIX}"

# PS1 除了 scm_prompt_info 以外都是固定的。
# \u \t \w \j 是 bash 的 prompt escape，顯示時才展開，直接留在字串裡。
_C_VC_ON_PATH="$(color ${PATH_BG} ${VERSION_CONTROL_BG})"
_C_PATH_ON_VC="$(color ${VERSION_CONTROL_BG} ${PATH_BG})"
_WT_PS1_PRE="${NORMAL}$(color ${ACCOUNT_FG} ${ACCOUNT_BG}) \u $(color ${ACCOUNT_ARROW_FG} ${ACCOUNT_ARROW_BG})"
_WT_PS1_PRE+="${NORMAL}$(color ${INFO_FG} ${INFO_BG}) \t [$(color ${INFO_HIGHTLIGHT_FG} ${INFO_BG})\j$(color ${INFO_FG} ${INFO_BG})] $(color ${INFO_BG} ${PATH_BG})"
_WT_PS1_PRE+="${NORMAL}$(color ${PATH_FG} ${PATH_BG}) \w "
_WT_PS1_POST="$(color ${PATH_BG} ${TERMINAL_BG})${NORMAL} "

function git_prompt_info() {
    git_prompt_vars
    echo "${_C_VC_ON_PATH}  ${SCM_PREFIX}${SCM_BRANCH}${SCM_STATE}${SCM_SUFFIX} ${_C_PATH_ON_VC}"
}

function prompt_command() {
    # scm_prompt_info 跑在 $( ) 的 subshell 裡，它設的變數回不到這裡，
    # 所以 per-repo cache 必須先在父 shell 建好。
    _wt_git_dir && _wt_git_repo_cache
    PS1="${_WT_PS1_PRE}$(scm_prompt_info)${_WT_PS1_POST}"
}

safe_append_prompt_command prompt_command

# ---------------------------------------------------------------------------
# 覆寫 bash-it 的 git_prompt_vars，改用單一
# `git status --porcelain=v2 --branch` 取得分支、upstream、ahead/behind
# 與檔案狀態。
# base.theme.bash 與 githelpers.theme.bash 已裁切成只服務這份 override 的
# 最小子集，原始完整版見 https://github.com/Bash-it/bash-it。
# ---------------------------------------------------------------------------

# 往上找 .git。worktree / submodule 的 .git 是檔案而非目錄。
function _wt_git_dir {
    local d=$PWD line
    while [[ -n $d ]]; do
        if [[ -d $d/.git ]]; then
            _WT_GIT_DIR=$d/.git
            return 0
        elif [[ -f $d/.git ]]; then
            read -r line < "$d/.git"        # "gitdir: <path>"
            line=${line#gitdir: }
            [[ $line == /* ]] || line=$d/$line
            _WT_GIT_DIR=$line
            return 0
        fi
        d=${d%/*}
    done
    _WT_GIT_DIR=
    return 1
}

# 每個 repo 只需算一次的東西
function _wt_git_repo_cache {
    [[ $_WT_GIT_CACHE_KEY == "$_WT_GIT_DIR" ]] && return 0
    _WT_GIT_CACHE_KEY=$_WT_GIT_DIR
    mapfile -t _WT_GIT_REMOTES < <(git remote 2> /dev/null)
    _WT_GIT_NREMOTES=${#_WT_GIT_REMOTES[@]}
    [[ "$(git config --get bash-it.hide-status 2> /dev/null)" == "1" ]] \
        && _WT_GIT_HIDE=1 || _WT_GIT_HIDE=
}

# upstream "origin/feature/x" → remote=origin, branch=feature/x
# 比對最長的 remote 前綴，remote 名稱含斜線也不會拆錯
function _wt_git_split_upstream {
    local up=$1 r
    _WT_UP_REMOTE= _WT_UP_BRANCH=$up
    for r in "${_WT_GIT_REMOTES[@]}"; do
        if [[ $up == "$r/"* && ${#r} -gt ${#_WT_UP_REMOTE} ]]; then
            _WT_UP_REMOTE=$r
            _WT_UP_BRANCH=${up#"$r/"}
        fi
    done
}

# 只偵測 git；p4/hg/svn 用不到。
function scm {
    if _wt_git_dir; then SCM=$SCM_GIT; else SCM=$SCM_NONE; fi
}

function git_prompt_vars {
    local line oid= head= upstream= ab= xy
    local staged=0 unstaged=0 untracked=0 have_ab=
    local flags=
    [[ ${SCM_GIT_IGNORE_UNTRACKED} == "true" ]] && flags=-uno

    while IFS= read -r line; do
        case $line in
            '# branch.oid '*)      oid=${line#\# branch.oid } ;;
            '# branch.head '*)     head=${line#\# branch.head } ;;
            '# branch.upstream '*) upstream=${line#\# branch.upstream } ;;
            '# branch.ab '*)       ab=${line#\# branch.ab }; have_ab=1 ;;
            '?'*)                  untracked=$((untracked + 1)) ;;
            '1 '*|'2 '*)
                xy=${line:2:2}
                [[ ${xy:0:1} != . ]] && staged=$((staged + 1))
                [[ ${xy:1:1} != . ]] && unstaged=$((unstaged + 1))
                ;;
            'u '*)  # unmerged：staged 與 unstaged 各算一筆
                staged=$((staged + 1)); unstaged=$((unstaged + 1)) ;;
        esac
    done < <(git status --porcelain=v2 --branch ${flags} 2> /dev/null)

    _wt_git_dir
    _wt_git_repo_cache

    # ---- 分支名稱 ----
    local remote_info=
    if [[ -n $head && $head != "(detached)" ]]; then
        SCM_GIT_DETACHED="false"
        if [[ -n $upstream ]]; then
            _wt_git_split_upstream "$upstream"
            local same_branch_name=
            [[ $head == "$_WT_UP_BRANCH" ]] && same_branch_name=true
            if { [[ ${SCM_GIT_SHOW_REMOTE_INFO} == "auto" ]] && [[ ${_WT_GIT_NREMOTES} -ge 2 ]]; } ||
                [[ ${SCM_GIT_SHOW_REMOTE_INFO} == "true" ]]; then
                if [[ $same_branch_name != "true" ]]; then
                    remote_info=$upstream
                else
                    remote_info=$_WT_UP_REMOTE
                fi
            elif [[ $same_branch_name != "true" ]]; then
                remote_info=$_WT_UP_BRANCH
            fi
            if [[ -n $remote_info ]]; then
                # 要顯示 remote 時才需要知道 upstream 是否已消失
                local branch_prefix
                if _git-upstream-branch-gone; then
                    branch_prefix=${SCM_THEME_BRANCH_GONE_PREFIX}
                else
                    branch_prefix=${SCM_THEME_BRANCH_TRACK_PREFIX}
                fi
                remote_info="${branch_prefix}${remote_info}"
            fi
        fi
        SCM_BRANCH="${SCM_THEME_BRANCH_PREFIX}${head}${remote_info}"
    else
        SCM_GIT_DETACHED="true"
        local detached_prefix ref
        if ref=$(_git-tag) && [[ -n $ref ]]; then
            detached_prefix=${SCM_THEME_TAG_PREFIX}
        else
            detached_prefix=${SCM_THEME_DETACHED_PREFIX}
            ref=$(_git-commit-description 2> /dev/null) || ref=
            [[ -z $ref ]] && ref=${oid:0:7}
        fi
        SCM_BRANCH="${detached_prefix}${ref}"
    fi

    # ---- ahead / behind ----
    local commits_ahead=0 commits_behind=0
    if [[ -n $have_ab ]]; then
        commits_ahead=${ab%% *};  commits_ahead=${commits_ahead#+}
        commits_behind=${ab##* }; commits_behind=${commits_behind#-}
    fi
    if [[ ${commits_ahead} -gt 0 ]]; then
        SCM_BRANCH+="${SCM_GIT_AHEAD_BEHIND_PREFIX_CHAR}${SCM_GIT_AHEAD_CHAR}"
        [[ ${SCM_GIT_SHOW_COMMIT_COUNT} == "true" ]] && SCM_BRANCH+="${commits_ahead}"
    fi
    if [[ ${commits_behind} -gt 0 ]]; then
        SCM_BRANCH+="${SCM_GIT_AHEAD_BEHIND_PREFIX_CHAR}${SCM_GIT_BEHIND_CHAR}"
        [[ ${SCM_GIT_SHOW_COMMIT_COUNT} == "true" ]] && SCM_BRANCH+="${commits_behind}"
    fi

    # ---- stash ----
    if [[ ${SCM_GIT_SHOW_STASH_INFO} == "true" ]]; then
        local stash_count=0 stash_log=$_WT_GIT_DIR/logs/refs/stash
        if [[ -f $stash_log ]]; then
            local _stash_lines
            mapfile -t _stash_lines < "$stash_log"
            stash_count=${#_stash_lines[@]}
        fi
        [[ ${stash_count} -gt 0 ]] \
            && SCM_BRANCH+=" ${SCM_GIT_STASH_CHAR_PREFIX}${stash_count}${SCM_GIT_STASH_CHAR_SUFFIX}"
    fi

    # ---- 乾淨 / 髒 ----
    SCM_STATE=${GIT_THEME_PROMPT_CLEAN:-$SCM_THEME_PROMPT_CLEAN}
    if [[ -z $_WT_GIT_HIDE ]]; then
        if [[ ${untracked} -gt 0 || ${unstaged} -gt 0 || ${staged} -gt 0 ]]; then
            SCM_DIRTY=1
            if [[ ${SCM_GIT_SHOW_DETAILS} == "true" ]]; then
                [[ ${staged} -gt 0 ]]    && SCM_BRANCH+=" ${SCM_GIT_STAGED_CHAR}${staged}"       && SCM_DIRTY=3
                [[ ${unstaged} -gt 0 ]]  && SCM_BRANCH+=" ${SCM_GIT_UNSTAGED_CHAR}${unstaged}"   && SCM_DIRTY=2
                [[ ${untracked} -gt 0 ]] && SCM_BRANCH+=" ${SCM_GIT_UNTRACKED_CHAR}${untracked}" && SCM_DIRTY=1
            fi
            SCM_STATE=${GIT_THEME_PROMPT_DIRTY:-$SCM_THEME_PROMPT_DIRTY}
        fi
    fi

    SCM_PREFIX=${GIT_THEME_PROMPT_PREFIX:-$SCM_THEME_PROMPT_PREFIX}
    SCM_SUFFIX=${GIT_THEME_PROMPT_SUFFIX:-$SCM_THEME_PROMPT_SUFFIX}
    SCM_CHANGE=${oid:0:7}
    [[ $oid == \(* ]] && SCM_CHANGE=
}
