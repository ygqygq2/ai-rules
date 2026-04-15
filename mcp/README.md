# MCP 资产

这里存放 **MCP 源资产片段**，不是最终的 `mcp.json`。

## 约定

- `0001-servers/`：单个 MCP server 的 JSON 片段

## 编号约定

- `mcp/` 使用独立编号空间，不再与 `rules/` 共享序号
- 当前 `0001-servers/` 用于存放 server 级别 JSON 片段

这些片段应由 `turbo-ai-rules` 通过 `merge-json` 安装模式合并为目标工具需要的最终配置文件。
