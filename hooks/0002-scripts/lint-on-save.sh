#!/usr/bin/env bash
set -euo pipefail

input_json="$(cat)"
changed_file="$(printf '%s' "$input_json" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"

# Claude PostToolUse 示例：文件写入/编辑后进行快速校验。
# 如需真正执行 eslint / prettier / pytest，可在这里替换命令。
if [[ -n "$changed_file" ]]; then
  echo "[hook] post-write check placeholder for: $changed_file" >&2
else
  echo "[hook] post-write check placeholder" >&2
fi

exit 0
