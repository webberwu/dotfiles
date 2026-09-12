#!/usr/bin/env bash
# bash-it git helper 的最小子集：只留 webber.theme.bash 用到的三支。

function _git-tag {
  git describe --tags --exact-match 2> /dev/null
}

function _git-commit-description {
  git describe --contains --all 2> /dev/null
}

function _git-upstream-branch-gone {
  [[ "$(git status -s -b | sed -e 's/.* //')" == "[gone]" ]]
}
