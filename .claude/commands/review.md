# /review — Code Review

对指定文件或当前分支的变更执行自动化代码审查。

## 用法

```
/review [file_path | --staged | --branch <branch>]
```

- 不带参数：审查当前工作区所有已修改文件
- `--staged`：只审查已暂存的变更
- `--branch <branch>`：审查与目标分支的差异

## 审查步骤

1. 获取变更内容（diff 或文件）
2. 加载项目相关规则（`001-` 通用规则 + 语言/框架特定规则）
3. 执行审查（参考 `1501-code-review.prompt.md` 模板）
4. 输出结构化报告

## 输出格式

输出 Markdown 格式报告，包含：
- **Blockers**：必须修复
- **Suggestions**：建议改进
- **Highlights**：值得称赞的写法

## 严格性级别

在提示中可指定级别（默认 `normal`）：
- `strict` — 包含所有 suggestions
- `normal` — 只报告 blockers 和高优先级 suggestions
- `quick` — 只报告 blockers
