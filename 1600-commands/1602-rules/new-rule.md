# /new-rule — Create New Rule

在正确的分类目录下创建一个新的规则文件（`.mdc`）。

## 用法

```
/new-rule <title> [--category <number>] [--tags <tag1,tag2>]
```

## 步骤

1. 询问规则的目标语言/框架/领域（如未指定 `--category`）
2. 根据 `AGENTS.md` 的编号体系确定分类目录
3. 自动生成下一个可用的编号
4. 使用标准 frontmatter 模板创建 `.mdc` 文件
5. 打开文件等待用户填写规则内容

## 模板

```markdown
---
id: <number>
title: <title>
description: <一句话描述>
globs: []
priority: medium
tags: [<tags>]
version: 1.0.0
author: <author>
lastUpdated: <YYYY-MM-DD>
---

# <title>

<规则内容>
```

## 注意事项

- 确认编号不与现有文件冲突
- 创建后提示用户更新对应目录的 `README.md`
