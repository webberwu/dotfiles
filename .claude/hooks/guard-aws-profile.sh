#!/bin/bash
# PreToolUse(Bash)：擋下具寫入權限的 AWS profile（it-shared / stag），只放行 -ro 版本
cmd=$(jq -r '.tool_input.command // empty')
if grep -Eq -- '(--profile[=[:space:]]+|AWS_(DEFAULT_)?PROFILE[[:space:]]*=[[:space:]]*)["'\'']?(it-shared|stag)([^-[:alnum:]_]|$)' <<<"$cmd"; then
  echo '只能使用 -ro profile（it-shared-ro / stag-ro）' >&2
  exit 2
fi
exit 0
