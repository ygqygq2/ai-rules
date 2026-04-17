#!/usr/bin/env bash
set -euo pipefail

input_json="$(cat)"
command_text="$(printf '%s' "$input_json" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"

# Claude PreToolUse 示例：拦截明显危险的 Bash 命令。
# 注意：Claude hook 里要用 exit 2 才会真正阻止工具执行。
if [[ "$command_text" =~ (^|[[:space:]])(rm[[:space:]]+-rf[[:space:]]+/|sudo[[:space:]]+rm) ]]; then
  echo "[hook] blocked potentially dangerous bash command: $command_text" >&2
  exit 2
fi

exit 0
