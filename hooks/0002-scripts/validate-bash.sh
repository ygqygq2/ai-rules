#!/usr/bin/env bash
set -euo pipefail

command_text="${1:-}"

# 示例：拦截明显危险的 shell 命令，可按团队需要扩展
if [[ "$command_text" =~ (^|[[:space:]])(rm[[:space:]]+-rf[[:space:]]+/|sudo[[:space:]]+rm) ]]; then
  echo "[hook] blocked potentially dangerous bash command: $command_text" >&2
  exit 1
fi

exit 0
