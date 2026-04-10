# Hooks 资产

这里存放 **hook 源资产**，而不是最终生成出来的 `settings.json`。

## 约定

- `1701-settings-fragments/`：可被 `merge-json` 合并的设置片段
- `1702-scripts/`：hook 运行时使用的脚本文件

最终目标配置应由 `turbo-ai-rules` 根据选中的资产生成。
