#!/usr/bin/env bash
set -euo pipefail

changed_file="${1:-}"

# 示例：文件写入后输出提示，真实项目可替换为 eslint / markdownlint / shellcheck 等
if [[ -n "$changed_file" ]]; then
  echo "[hook] post-write check placeholder for: $changed_file"
else
  echo "[hook] post-write check placeholder"
fi

exit 0
