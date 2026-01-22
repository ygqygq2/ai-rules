---
id: 1310
title: Git 工作流专家
description: Git 工作流规范、提交约定、分支管理和协作开发指南
globs: ['**/*']
priority: high
tags: [git, workflow, version-control, collaboration]
version: 1.0.0
author: ygqygq2
lastUpdated: 2026-01-22
---

# Git 工作流专家

## 何时使用此技能

- 开始新功能开发
- 提交代码前需要规范检查
- 处理分支冲突
- Code Review 流程
- 版本发布管理

## 核心规范

### 1. 提交信息格式

**约定式提交**:

```
<类型>(<范围>): <简短描述>

[可选的详细说明]

[可选的脚注]
```

**类型**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`

**示例**:

```bash
feat(auth): 添加 JWT 刷新机制
fix(api): 修复用户登录超时问题
docs(readme): 更新部署文档
```

---

### 2. 分支策略

| 分支类型      | 用途     | 命名规则           |
| ------------- | -------- | ------------------ |
| `main/master` | 生产代码 | 固定分支           |
| `develop`     | 集成分支 | 固定分支           |
| `feature/*`   | 新功能   | `feature/用户认证` |
| `bugfix/*`    | Bug 修复 | `bugfix/登录错误`  |
| `hotfix/*`    | 紧急修复 | `hotfix/安全补丁`  |

**规则**:

- 从 `develop` 创建功能分支
- 分支生命周期 < 3 天
- 合并后删除分支
- 定期 rebase 保持同步

---

### 3. 日常工作流

```bash
# 1. 创建功能分支
git checkout develop
git pull origin develop
git checkout -b feature/new-feature

# 2. 提交更改
git add .
git commit -m "feat(module): 添加新功能"

# 3. 保持更新
git fetch origin
git rebase origin/develop

# 4. 推送并创建 PR
git push origin feature/new-feature

# 5. 合并后清理
git checkout develop
git pull origin develop
git branch -d feature/new-feature
```

---

### 4. 常用命令速查

**撤销操作**:

```bash
git reset --soft HEAD~1   # 撤销提交，保留更改
git reset --hard HEAD~1   # 撤销提交，丢弃更改
git commit --amend        # 修改最后一次提交
```

**临时保存**:

```bash
git stash save "WIP: 功能描述"
git stash pop
```

**合并提交**:

```bash
git rebase -i HEAD~3  # 交互式合并最近 3 次提交
```

**查找问题**:

```bash
git log --graph --oneline --all
git bisect start  # 二分查找引入 bug 的提交
```

---

### 5. 冲突解决

**步骤**:

1. 拉取最新代码: `git pull --rebase origin develop`
2. 手动解决冲突标记 (`<<<<<<<`, `=======`, `>>>>>>>`)
3. 测试验证修复
4. 添加并继续: `git add .` → `git rebase --continue`

**预防**:

- 经常同步上游分支
- 保持小而频繁的提交
- 启用 `git rerere` 记住冲突解决方案

---

## Code Review 清单

**提交 PR 前**:

- [ ] 代码符合项目规范
- [ ] 单元测试通过
- [ ] 提交信息规范
- [ ] 无无关文件更改
- [ ] 已自我 Review

**Review 关注点**:

- 逻辑正确性
- 边界条件处理
- 错误处理
- 性能影响
- 安全风险

---

## 配置建议

**.gitignore**:

```
node_modules/
.env
*.log
.DS_Store
```

**Git Hooks** (`.githooks/pre-commit`):

```bash
#!/bin/sh
npm run lint
npm test
```

**配置启用**:

```bash
git config core.hooksPath .githooks
```

---

## 最佳实践

1. **原子提交**: 一次提交只做一件事
2. **描述性分支名**: `feature/用户认证` 而非 `dev`
3. **及时推送**: 避免长时间本地积累
4. **标签管理**: 发布时打标签 `git tag -a v1.0.0`
5. **定期清理**: 删除已合并的本地分支
