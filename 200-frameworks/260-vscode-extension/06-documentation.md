---
id: vscode-extension-documentation
title: VSCode 扩展文档规范
priority: high
tags: [vscode, documentation, comments, readme]
version: 1.0.0
author: Turbo AI Rules
description: VSCode 扩展开发的文档编写规范和最佳实践
---

# VSCode 扩展文档规范

## 文档分层

### 用户文档

**README.md - 项目入口文档**

- 项目简介和功能
- 快速开始指南
- 安装说明
- 基本使用方法
- 链接到详细文档

**用户指南（docs/user-guide/）**

- 详细功能说明
- 配置指南
- 常见问题（FAQ）
- 故障排除

### 开发者文档

**开发指南（docs/development/）**

- 架构设计
- 开发环境搭建
- 编码规范
- 测试指南
- 贡献指南

**API 文档**

- JSDoc 注释生成
- 类型定义说明
- 接口文档

### 内联文档

**代码注释**

- JSDoc 函数注释
- 复杂逻辑说明
- TODO 标记

## README 编写规范

### README 模板

```markdown
# 扩展名称

> 一句话描述扩展的核心功能

[![Version](badge-url)](link)
[![Downloads](badge-url)](link)
[![License](badge-url)](link)

[English](./README.md) | [中文文档](./README.zh.md)

---

## ✨ 功能特性

- 🎯 **核心功能 1** - 简短描述
- 🔄 **核心功能 2** - 简短描述
- 🚀 **核心功能 3** - 简短描述

---

## 🚀 快速开始

### 1. 安装扩展

在 VS Code 扩展市场搜索 "扩展名称" 并安装。

### 2. 基本使用

**方法一：通过命令面板**

1. 按 `Ctrl+Shift+P` (Mac: `Cmd+Shift+P`)
2. 输入 "扩展命令"
3. 选择要执行的操作

**方法二：通过快捷键**

- `Ctrl+Alt+S`: 执行操作 1
- `Ctrl+Alt+D`: 执行操作 2

### 3. 配置（可选）

打开设置，搜索 "extension"，配置以下选项：

\`\`\`json
{
"extension.setting1": true,
"extension.setting2": "value"
}
\`\`\`

---

## 📖 详细文档

- [完整用户指南](./docs/user-guide/README.md)
- [配置参考](./docs/user-guide/configuration.md)
- [常见问题](./docs/user-guide/faq.md)
- [开发指南](./docs/development/README.md)

---

## 🤝 贡献

欢迎贡献！请阅读 [贡献指南](./CONTRIBUTING.md)。

---

## 📄 许可证

本项目采用 [MIT](./LICENSE) 许可证。

---

## 💬 支持

- 📧 Email: your-email@example.com
- 🐙 GitHub: [@username](https://github.com/username)
- 💭 讨论: [GitHub Discussions](https://github.com/username/repo/discussions)

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给一个 Star！**

Made with ❤️ by [Author Name](https://github.com/username)

</div>
```

### README 最佳实践

**使用徽章（Badges）：**

```markdown
[![Visual Studio Marketplace Version](link)](link)
![Visual Studio Marketplace Installs](link)
[![License](link)](./LICENSE)
```

**添加截图和 GIF：**

```markdown
## 功能演示

![Feature Demo](./resources/demo.gif)

## 界面预览

<div align="center">
  <img src="./resources/screenshot.png" alt="Screenshot" width="800" />
</div>
```

**提供多语言版本：**

- README.md（英文）
- README.zh.md（中文）
- README.ja.md（日文）等

## JSDoc 注释规范

### 函数注释

**基础函数注释：**

```typescript
/**
 * 解析 MDC 格式的规则文件
 * @param filePath {string} 文件的绝对路径
 * @param sourceId {string} 规则源的唯一标识符
 * @return {Promise<ParsedRule>} 解析后的规则对象
 * @throws {ParseError} 当文件格式无效或读取失败时抛出
 */
async function parseMdcFile(filePath: string, sourceId: string): Promise<ParsedRule> {
  // 实现
}
```

**使用 turbo-file-header 扩展：**

- 快捷键：`Ctrl+Alt+/` (Windows/Linux) 或 `Cmd+Alt+/` (Mac)
- 自动生成标准格式的函数注释
- 然后补充具体的功能描述

**复杂函数添加示例：**

```typescript
/**
 * 合并多个规则源的规则，处理冲突
 * @description
 * 按照优先级和配置的冲突策略合并规则：
 * - priority: 高优先级规则覆盖低优先级
 * - merge: 合并规则内容
 * - skip-duplicates: 保留第一个，跳过重复
 *
 * @param rules {ParsedRule[]} 待合并的规则数组
 * @param strategy {ConflictStrategy} 冲突解决策略
 * @return {ParsedRule[]} 合并后的规则数组
 *
 * @example
 * const merged = mergeRules(
 *   [rule1, rule2, rule3],
 *   'priority'
 * );
 */
function mergeRules(rules: ParsedRule[], strategy: ConflictStrategy): ParsedRule[] {
  // 实现
}
```

### 类注释

**类级别注释：**

```typescript
/**
 * Git 仓库管理器
 * @description
 * 负责处理 Git 仓库的克隆、拉取、状态检查等操作。
 * 使用 simple-git 库封装 Git 命令，提供类型安全的接口。
 *
 * @example
 * const gitManager = new GitManager();
 * await gitManager.clone('https://github.com/user/repo.git', '/path/to/dir');
 * await gitManager.pull('/path/to/dir');
 */
export class GitManager {
  /**
   * Git 仓库缓存映射
   * @private
   */
  private repoCache: Map<string, GitStatus>;

  /**
   * 创建 Git 管理器实例
   */
  constructor() {
    this.repoCache = new Map();
  }

  /**
   * 克隆 Git 仓库
   * @param url {string} 仓库 URL（HTTPS 或 SSH）
   * @param targetDir {string} 目标目录的绝对路径
   * @param options {CloneOptions} 克隆选项（分支、深度等）
   * @return {Promise<void>}
   * @throws {GitError} 克隆失败时抛出
   */
  async clone(url: string, targetDir: string, options?: CloneOptions): Promise<void> {
    // 实现
  }
}
```

### 类型注释

**接口注释：**

```typescript
/**
 * 规则源配置
 * @description
 * 定义一个规则源的完整配置信息，包括 Git 仓库地址、
 * 认证方式、同步策略等。
 */
export interface RuleSource {
  /**
   * 规则源唯一标识符（kebab-case 格式）
   * @example "company-frontend-rules"
   */
  id: string;

  /**
   * 规则源显示名称
   * @example "公司前端规范"
   */
  name: string;

  /**
   * Git 仓库 URL
   * @example "https://github.com/company/rules.git"
   */
  gitUrl: string;

  /**
   * Git 分支名称
   * @default "main"
   */
  branch?: string;

  /**
   * 仓库子目录路径（相对路径）
   * @example "/frontend/rules"
   */
  subPath?: string;

  /**
   * 是否启用该规则源
   * @default true
   */
  enabled?: boolean;
}
```

### 注释标签

**常用 JSDoc 标签：**

```typescript
/**
 * @param {Type} name - 参数描述
 * @return {Type} 返回值描述
 * @returns {Type} 返回值描述（同 @return）
 * @throws {ErrorType} 抛出异常说明
 * @example 使用示例代码
 * @description 详细描述
 * @deprecated 标记为废弃
 * @since 版本 说明添加的版本
 * @see 参考链接或相关函数
 * @default 默认值
 * @private 私有成员
 * @public 公共成员
 * @readonly 只读属性
 */
```

**示例：**

```typescript
/**
 * 配置管理器
 * @deprecated 使用 ConfigService 替代
 * @see ConfigService
 * @since 1.0.0
 */
export class ConfigManager {
  /**
   * 配置文件路径
   * @readonly
   * @default "config.json"
   */
  readonly configPath: string = 'config.json';
}
```

## 行内注释规范

### 何时添加注释

**需要注释的情况：**

```typescript
// ✅ 解释"为什么"
// 使用 LRU 缓存避免重复解析大文件（最大 100 个）
const cache = new LRUCache<string, ParsedRule>(100);

// ✅ 解释复杂的算法或逻辑
// 优先级权重计算：critical=4, high=3, medium=2, low=1
const weight =
  priority === 'critical' ? 4 : priority === 'high' ? 3 : priority === 'medium' ? 2 : 1;

// ✅ 说明特殊处理
// 同一仓库的源必须串行处理，避免 Git 锁冲突
for (const source of repositoryGroup.sources) {
  await syncSingleSource(source);
}

// ✅ 标记待办事项
// TODO: 添加重试机制
// FIXME: 处理并发写入冲突
// HACK: 临时方案，等待上游库修复
```

**不需要注释的情况：**

```typescript
// ❌ 避免：重复代码内容
// 创建数组
const arr = [];

// ❌ 避免：显而易见的操作
// 循环遍历规则
for (const rule of rules) { ... }

// ❌ 避免：过时的注释
// 旧代码的注释但代码已更改
```

### 注释格式

**单行注释：**

```typescript
// 这是单行注释，注意 // 后有一个空格
const value = 42;
```

**多行注释：**

```typescript
/*
 * 这是多行注释
 * 用于较长的说明
 * 每行开头对齐
 */
```

**区块分隔：**

```typescript
// ============================================================
// Git 操作相关方法
// ============================================================

async clone() { ... }
async pull() { ... }

// ============================================================
// 缓存管理相关方法
// ============================================================

getCache() { ... }
clearCache() { ... }
```

## CHANGELOG 规范

### CHANGELOG 格式

**基于 Keep a Changelog：**

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- 新增功能描述

### Changed

- 改动说明

### Fixed

- 修复的 Bug

## [1.2.0] - 2024-01-15

### Added

- 支持自定义适配器配置
- 新增规则预览功能
- 添加多语言支持（英文/中文）

### Changed

- 优化同步性能，减少 50% 网络请求
- 更新依赖库到最新版本

### Fixed

- 修复 Windows 平台路径问题 (#123)
- 修复并发同步导致的冲突 (#124)

### Security

- 修复路径遍历漏洞 (CVE-2024-xxxx)

## [1.1.0] - 2023-12-01

### Added

- 支持 SSH 认证

### Deprecated

- `oldMethod()` 将在 2.0.0 版本移除

### Removed

- 移除已废弃的 `legacyConfig` 选项

## [1.0.0] - 2023-10-01

### Added

- 初始版本发布
- 基础 Git 同步功能
- 规则解析和生成

[Unreleased]: https://github.com/user/repo/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/user/repo/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/user/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/user/repo/releases/tag/v1.0.0
```

### 变更类型

**标准变更类型：**

- **Added**: 新功能
- **Changed**: 功能改动
- **Deprecated**: 即将废弃
- **Removed**: 已删除
- **Fixed**: Bug 修复
- **Security**: 安全修复

## 贡献指南

### CONTRIBUTING.md 模板

```markdown
# 贡献指南

感谢您对项目的关注！

## 📝 贡献方式

- 🐛 报告 Bug
- ✨ 提议新功能
- 📖 改进文档
- 💻 提交代码
- 🧪 编写测试

## 🚀 快速开始

### 1. Fork 和克隆

\`\`\`bash
git clone https://github.com/YOUR_USERNAME/repo.git
cd repo
npm install
\`\`\`

### 2. 创建分支

\`\`\`bash
git checkout -b feature/my-feature

# 或

git checkout -b fix/issue-123
\`\`\`

### 3. 开发和测试

\`\`\`bash
npm run watch # 监听模式
npm test # 运行测试
npm run lint # 代码检查
\`\`\`

### 4. 提交更改

\`\`\`bash
git commit -m "feat: add new feature"
git push origin feature/my-feature
\`\`\`

## 📋 提交规范

使用 Conventional Commits:

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具配置

## ✅ 检查清单

提交前确保:

- [ ] 代码通过 `npm test`
- [ ] 代码通过 `npm run lint`
- [ ] 添加了必要的测试
- [ ] 更新了相关文档
- [ ] 遵循了提交规范
```

## 文档同步策略

### 设计-代码-文档同步

**强制同步原则：**

1. 新功能 → 先更新设计文档 → 实现代码 → 同步用户文档
2. Bug 修复 → 编写失败测试 → 修复代码 → 更新文档（如需）
3. 重构 → 评估影响 → 更新设计 → 重构实现 → 同步文档

**文档检查：**

- 代码审查时检查文档是否更新
- CI 检查文档链接有效性
- 定期审查文档准确性

## 最佳实践

### 文档编写原则

**清晰简洁：**

- 一句话说清楚核心内容
- 使用简单直白的语言
- 避免行业黑话（除非必要）

**结构化：**

- 使用标题层级
- 列表和表格
- 代码示例
- 截图和图表

**可搜索：**

- 关键词明确
- 添加目录
- 交叉链接
- 标签分类

**保持最新：**

- 代码变更同步更新文档
- 标记过时内容
- 定期审查和更新

### 文档检查清单

- [ ] README 包含核心功能说明
- [ ] 安装和快速开始指南清晰
- [ ] 所有公共 API 有 JSDoc
- [ ] 复杂逻辑有行内注释
- [ ] CHANGELOG 记录所有版本变更
- [ ] 贡献指南完整
- [ ] 文档与代码同步
- [ ] 链接有效
- [ ] 示例代码可运行
- [ ] 有中英文版本（如需）
