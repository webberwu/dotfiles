#!/bin/bash
set -euo pipefail

payload=$(cat)

parsed=$(python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
print(d.get('hook_event_name', ''))
print(d.get('cwd', ''))
print(d.get('tool_name', d.get('tool', '')))
" <<< "$payload")

hook_event=$(sed -n '1p' <<< "$parsed")
cwd=$(sed -n '2p' <<< "$parsed")
tool=$(sed -n '3p' <<< "$parsed")

project=$(basename "${cwd:-}")
[ -z "$project" ] || [ "$project" = "." ] && project="unknown"
timestamp=$(date +"%H:%M:%S")

if [ "$hook_event" = "Stop" ]; then
    osascript -e "display notification \"任務完成 | 專案: $project | $timestamp\" with title \"✅ Claude Code\" sound name \"Funk\"" || true

elif [ "$hook_event" = "Notification" ]; then
    if [ -n "$tool" ]; then
        osascript -e "display notification \"需要授權 | 工具: $tool | 專案: $project | $timestamp\" with title \"🔐 Claude Code\" sound name \"Ping\"" || true
    else
        osascript -e "display notification \"需要授權 | 專案: $project | $timestamp\" with title \"🔐 Claude Code\" sound name \"Ping\"" || true
    fi
fi
