# Hooks 资产

这里存放 **hook 源资产**，而不是最终生成出来的 `settings.json`。

## 约定

- `0001-settings-fragments/`：可被 `merge-json` 合并的设置片段
- `0002-scripts/`：hook 运行时使用的脚本文件

## 编号约定

- `hooks/` 使用独立编号空间，不再与 `rules/` 共享序号
- 当前约定为：片段目录从 `0001` 开始，脚本目录从 `0002` 开始

最终目标配置应由 `turbo-ai-rules` 根据选中的资产生成。
