---
id: vscode-extension-rules-index
title: VSCode 扩展开发规则索引
priority: high
tags: [vscode, extension, rules, index]
version: 1.0.0
author: Turbo AI Rules
description: VSCode 扩展开发的全面规则集合索引
---

# VSCode 扩展开发规则索引

> 这是一套针对 VSCode 扩展开发的通用最佳实践规则集合，涵盖架构设计、编码规范、错误处理、安全、测试和文档编写等各个方面。

---

## 📚 规则概览

### [01. 架构设计规范](./01-architecture.md)

**核心内容：**

- 分层架构设计原则
- 设计模式应用（适配器、单例、策略、观察者）
- 依赖注入与控制反转
- 错误处理架构
- 性能优化架构
- 扩展点设计
- 测试架构
- 配置管理架构
- 安全架构

**适用场景：**

- 新项目架构设计
- 现有项目重构
- 技术选型决策
- 团队技术规范制定

**关键原则：**

- ✅ 每个模块单一职责
- ✅ 依赖关系清晰
- ✅ 接口抽象，面向接口编程
- ✅ 低耦合、高内聚

---

### [02. 编码规范](./02-coding-standards.md)

**核心内容：**

- TypeScript 严格模式配置
- 命名规范（文件、变量、函数、类）
- 代码组织规范（导入、导出、函数规模）
- 异步编程规范（async/await、并行处理）
- 错误处理规范
- 注释规范（JSDoc、行内注释）
- 代码风格规范
- VSCode API 使用规范
- ESLint 和 Prettier 配置

**适用场景：**

- 日常编码
- 代码审查
- 新人培训
- 团队规范统一

**关键原则：**

- ✅ 避免 any 类型
- ✅ 使用 async/await
- ✅ 函数不超过 50 行
- ✅ 优先使用命名导出

---

### [03. 错误处理规范](./03-error-handling.md)

**核心内容：**

- 统一日志系统（@ygqygq2/vscode-log）
- 日志级别规范（debug/info/warn/error）
- 结构化日志
- 敏感信息保护
- 错误码系统设计
- 自定义错误类
- 分层错误处理策略
- 用户提示规范
- 错误监控和分析

**适用场景：**

- 异常处理
- 日志记录
- 用户反馈
- 问题排查

**关键原则：**

- ✅ 所有 async 函数有 try-catch
- ✅ 错误包含错误码
- ✅ 用户提示友好且可操作
- ✅ 敏感信息不在日志中

---

### [04. 安全规范](./04-security.md)

**核心内容：**

- 输入验证（URL、路径、分支名、配置值）
- Secret Storage 使用
- 文件操作安全（原子写入、安全读取）
- 网络安全（HTTPS、超时、证书验证）
- 代码注入防护
- 输出编码
- 依赖安全
- 权限最小化
- 常见安全漏洞及修复

**适用场景：**

- 处理用户输入
- 文件和网络操作
- 敏感信息存储
- 安全审计

**关键原则：**

- ✅ 所有用户输入必须验证
- ✅ 敏感信息存储在 Secret Storage
- ✅ 文件操作使用原子写入
- ✅ 防止路径遍历和命令注入

---

### [05. 测试规范](./05-testing.md)

**核心内容：**

- 测试策略（测试金字塔、测试分层）
- 单元测试（Vitest 配置和示例）
- 集成测试（Mocha 配置和示例）
- Mock 技巧
- 测试覆盖率（80%+ 目标）
- 测试最佳实践（AAA 模式、独立性、边界情况）
- 持续集成（GitHub Actions）
- 测试维护

**适用场景：**

- 编写测试用例
- 提高代码质量
- 持续集成配置
- 重构验证

**关键原则：**

- ✅ 核心逻辑有测试覆盖
- ✅ 测试相互独立
- ✅ 覆盖率达到 80%+
- ✅ Mock 使用正确

---

### [06. 文档规范](./06-documentation.md)

**核心内容：**

- 文档分层（用户文档、开发者文档、内联文档）
- README 编写规范和模板
- JSDoc 注释规范
- 行内注释规范
- CHANGELOG 规范
- 贡献指南（CONTRIBUTING.md）
- 文档同步策略
- 文档编写原则

**适用场景：**

- 项目文档编写
- API 文档生成
- 代码注释
- 版本发布

**关键原则：**

- ✅ README 包含核心功能说明
- ✅ 所有公共 API 有 JSDoc
- ✅ CHANGELOG 记录所有变更
- ✅ 文档与代码同步

---

## 🎯 快速导航

### 按开发阶段

**项目初始化阶段：**

1. [架构设计规范](./01-architecture.md) - 设计系统架构
2. [编码规范](./02-coding-standards.md) - 配置 ESLint/Prettier
3. [测试规范](./05-testing.md) - 配置测试框架
4. [文档规范](./06-documentation.md) - 编写 README

**日常开发阶段：**

1. [编码规范](./02-coding-standards.md) - 遵循编码风格
2. [错误处理规范](./03-error-handling.md) - 正确处理错误
3. [安全规范](./04-security.md) - 验证用户输入
4. [测试规范](./05-testing.md) - 编写测试用例

**代码审查阶段：**

1. [编码规范](./02-coding-standards.md) - 检查代码风格
2. [架构设计规范](./01-architecture.md) - 检查架构合理性
3. [安全规范](./04-security.md) - 检查安全问题
4. [测试规范](./05-testing.md) - 检查测试覆盖

**发布前阶段：**

1. [测试规范](./05-testing.md) - 运行完整测试
2. [安全规范](./04-security.md) - 安全审计
3. [文档规范](./06-documentation.md) - 更新 CHANGELOG
4. [文档规范](./06-documentation.md) - 更新文档

### 按问题类型

**架构问题：**

- 模块职责不清 → [架构设计规范](./01-architecture.md#核心架构原则)
- 循环依赖 → [架构设计规范](./01-architecture.md#依赖注入与控制反转)
- 扩展性差 → [架构设计规范](./01-architecture.md#扩展点设计)

**代码质量问题：**

- 代码难读 → [编码规范](./02-coding-standards.md#命名规范)
- 函数太长 → [编码规范](./02-coding-standards.md#函数规模)
- 类型不安全 → [编码规范](./02-coding-standards.md#类型使用规范)

**错误处理问题：**

- 错误信息不清 → [错误处理规范](./03-error-handling.md#错误码系统)
- 日志混乱 → [错误处理规范](./03-error-handling.md#统一日志系统)
- 用户体验差 → [错误处理规范](./03-error-handling.md#用户提示规范)

**安全问题：**

- 路径遍历 → [安全规范](./04-security.md#路径验证)
- 命令注入 → [安全规范](./04-security.md#命令执行安全)
- 敏感信息泄露 → [安全规范](./04-security.md#secret-storage-使用)

**测试问题：**

- 覆盖率低 → [测试规范](./05-testing.md#测试覆盖率)
- 测试不稳定 → [测试规范](./05-testing.md#测试独立性)
- Mock 使用错误 → [测试规范](./05-testing.md#mock-技巧)

**文档问题：**

- 缺少文档 → [文档规范](./06-documentation.md#文档分层)
- 文档过时 → [文档规范](./06-documentation.md#文档同步策略)
- 注释不清 → [文档规范](./06-documentation.md#jsdoc-注释规范)

---

## 🔧 工具和扩展推荐

### VSCode 扩展

**编码辅助：**

- **turbo-file-header** - 自动生成函数注释（快捷键：`Ctrl+Alt+/`）
- **turbo-console-log** - 自动插入调试日志（快捷键：`Ctrl+Alt+L`）
- **ESLint** - 代码质量检查
- **Prettier** - 代码格式化

**测试工具：**

- **Vitest** - 单元测试框架
- **Coverage Gutters** - 显示测试覆盖率

**Git 工具：**

- **GitLens** - 增强的 Git 功能
- **Git Graph** - 可视化 Git 历史

### NPM 包

**开发工具：**
以下只是推荐的包，版本不定是最新的，请根据实际情况选择合适的版本。

```json
{
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/vscode": "^1.85.0",
    "typescript": "^5.9.0",
    "eslint": "^9.0.0",
    "prettier": "^3.0.0",
    "vitest": "^1.0.0",
    "@vscode/test-electron": "^2.3.0"
  }
}
```

**运行时依赖：**

```json
{
  "dependencies": {
    "simple-git": "^3.0.0",
    "fs-extra": "^11.0.0",
    "gray-matter": "^4.0.3",
    "@ygqygq2/vscode-log": "^1.0.0"
  }
}
```

---

## 📖 使用建议

### 新手入门路径

1. **第一周**：熟悉 [编码规范](./coding-standards.md)
2. **第二周**：学习 [错误处理规范](./error-handling.md) 和 [安全规范](./security.md)
3. **第三周**：掌握 [测试规范](./testing.md)
4. **第四周**：理解 [架构设计规范](./architecture.md)
5. **持续**：遵循 [文档规范](./documentation.md) 编写文档

### 老手进阶路径

1. 深入 [架构设计规范](./architecture.md) 的设计模式应用
2. 完善 [错误处理规范](./error-handling.md) 的错误监控
3. 强化 [安全规范](./security.md) 的安全审计
4. 提升 [测试规范](./testing.md) 的覆盖率和质量
5. 优化 [文档规范](./documentation.md) 的文档体系

### 团队协作建议

1. **统一规范**：团队共同学习这些规则
2. **代码审查**：在 PR 中检查规则遵循情况
3. **定期培训**：组织规范培训和分享
4. **工具辅助**：配置 ESLint 等工具自动检查
5. **持续改进**：根据实践反馈优化规则

---

## 🤝 贡献和反馈

如果你发现规则中的问题或有改进建议：

1. 提交 Issue 描述问题
2. 提交 PR 改进规则
3. 参与讨论分享经验

---

## 📄 许可证

本规则集合采用 MIT 许可证。

---

<div align="center">

**⭐ 遵循这些规则，构建高质量的 VSCode 扩展！**

Made with ❤️ by Turbo AI Rules

</div>
