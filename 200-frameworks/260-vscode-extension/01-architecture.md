---
id: vscode-extension-architecture
title: VSCode 扩展架构最佳实践
priority: high
tags: [vscode, extension, architecture, design-patterns]
version: 1.0.0
author: Turbo AI Rules
description: VSCode 扩展的架构设计原则和模式
---

# VSCode Extension Architecture Best Practices

## 核心架构原则

### 分层架构设计

采用清晰的分层架构，每一层有明确的职责：

**UI & Command Layer（UI 与命令层）**

- 处理用户交互
- 注册 VSCode 命令
- 管理视图和 UI 组件
- 不包含业务逻辑

**Service Orchestrator Layer（服务编排层）**

- 协调多个服务完成复杂流程
- 处理跨服务的业务逻辑
- 管理服务间的依赖关系

**Service Layer（服务层）**

- 封装核心业务逻辑
- 每个服务单一职责
- 服务之间松耦合

**Provider Layer（提供者层）**

- 实现 VSCode 的 Provider 接口
- TreeViewProvider、StatusBarProvider 等
- 仅负责数据展示和 UI 更新

**Adapter Layer（适配器层）**

- 适配外部工具和格式
- 转换数据结构
- 隔离第三方依赖

**Utils Layer（工具层）**

- 提供通用工具函数
- 无状态、可复用
- 独立测试

### 模块组织最佳实践

**按功能分组而非按类型**

✅ 推荐结构：

```
src/
├── commands/        # 命令处理
├── services/        # 核心服务
├── providers/       # VSCode Providers
├── adapters/        # 适配器
├── parsers/         # 解析器
├── utils/           # 工具函数
└── types/           # 类型定义
```

❌ 避免：

```
src/
├── interfaces/      # 避免单独的接口目录
├── implementations/ # 避免实现与接口分离
├── helpers/         # 避免模糊的 helpers 目录
```

## 设计模式应用

### 适配器模式 (Adapter Pattern)

用于适配不同的 AI 工具配置格式：

**何时使用：**

- 需要支持多种外部工具
- 工具的配置格式不同
- 需要隔离外部依赖

**实现要点：**

- 定义统一的适配器接口
- 每个工具一个适配器实现
- 适配器之间相互独立

### 单例模式 (Singleton Pattern)

用于全局唯一的服务和管理器：

**何时使用：**

- Logger、ConfigManager 等全局服务
- 需要统一的状态管理
- 避免重复初始化

**注意事项：**

- 单例应该是无状态的或状态可控的
- 提供清理方法用于测试
- 避免隐藏的依赖关系

### 策略模式 (Strategy Pattern)

用于规则冲突解决和同步策略：

**何时使用：**

- 多种算法可以互换
- 需要在运行时选择算法
- 避免大量 if-else 条件

**实现要点：**

- 定义策略接口
- 实现具体策略类
- 通过配置选择策略

### 观察者模式 (Observer Pattern)

用于状态变化通知和 UI 更新：

**何时使用：**

- 配置变更需要通知多个组件
- 文件变化需要触发更新
- UI 需要响应数据变化

**实现要点：**

- 使用 VSCode 的 EventEmitter
- 定义清晰的事件类型
- 及时取消订阅避免内存泄漏

## 依赖注入与控制反转

### 依赖注入原则

**构造函数注入（推荐）：**

```typescript
class RulesManager {
  constructor(
    private gitManager: GitManager,
    private parser: MdcParser,
    private validator: RulesValidator,
  ) {}
}
```

**避免直接 new 依赖：**
❌ 避免：

```typescript
class Service {
  private gitManager = new GitManager(); // 紧耦合
}
```

### 接口抽象

**定义清晰的接口：**

- 面向接口编程而非实现
- 接口应该精简且专注
- 使用 TypeScript 接口或抽象类

## 错误处理架构

### 统一错误码系统

**错误码命名规范：**

- 命名空间前缀：`TAI`
- 分类编号：1000 为一个大类
- 具体错误：具体的三位数

**错误分类：**

- `TAI-100x`: 配置类错误
- `TAI-200x`: Git 操作错误
- `TAI-300x`: 解析类错误
- `TAI-400x`: 生成类错误
- `TAI-500x`: 系统类错误

### 错误传播策略

**分层错误处理：**

1. **底层**：抛出带错误码的异常
2. **中层**：捕获、转换、记录日志
3. **顶层**：友好的用户提示

## 性能优化架构

### 缓存策略

**多级缓存架构：**

- **全局缓存**：跨项目共享（`~/.turbo-ai-rules/`）
- **内存缓存**：LRU 缓存解析结果
- **项目缓存**：项目特定的元数据

**缓存失效策略：**

- Git 仓库更新时清除相关缓存
- 配置变更时刷新缓存
- 定期清理过期缓存

### 异步与并发控制

**并行处理原则：**

- 独立任务使用 `Promise.all` 并行
- 同一资源的操作必须串行
- 限制并发数量避免资源耗尽

**示例：Git 同步策略**

- 同一仓库的源串行处理
- 不同仓库的源并行处理
- 使用队列控制并发数

## 扩展点设计

### 适配器扩展点

**新 AI 工具适配：**

1. 实现 `AIToolAdapter` 接口
2. 在 `adapters/index.ts` 注册
3. 在配置中添加适配器选项
4. 无需修改核心代码

### 解析器扩展点

**支持新的规则格式：**

1. 实现解析器接口
2. 注册文件扩展名映射
3. 在 RulesManager 中集成
4. 向后兼容现有格式

### 存储策略扩展点

**自定义存储位置：**

- 支持配置自定义缓存目录
- 支持项目级存储策略
- 支持云存储集成（未来）

## 测试架构

### 测试分层

**单元测试（Vitest）：**

- 测试单个模块的功能
- Mock 外部依赖
- 快速执行

**集成测试（Mocha）：**

- 测试模块间协作
- 使用真实的 VSCode API
- 端到端流程验证

### 可测试性设计

**依赖注入便于测试：**

- 通过构造函数注入依赖
- 使用接口而非具体实现
- 提供 Mock 工厂函数

**避免全局状态：**

- 状态封装在类实例中
- 提供 reset 方法用于测试
- 使用纯函数

## 配置管理架构

### 配置层级

**配置优先级（从高到低）：**

1. 项目级配置（`.vscode/settings.json`）
2. 用户级配置（User Settings）
3. 默认配置（扩展内置）

### 配置验证

**配置加载流程：**

1. 读取配置
2. Schema 验证
3. 业务规则校验
4. 提供默认值
5. 返回有效配置

## 安全架构

### 输入验证

**所有外部输入必须验证：**

- Git URL 格式验证
- 路径安全性检查
- 配置值范围验证
- 防止注入攻击

### 敏感信息处理

**Secret Storage 使用规范：**

- Token 等敏感信息存储在 VSCode Secret Storage
- 日志中不输出敏感信息
- 使用安全的传输方式

### 文件系统安全

**路径安全：**

- 规范化路径
- 限制在工作区内
- 防止目录遍历攻击
- 原子文件操作

## 日志与监控架构

### 日志级别策略

**日志级别使用场景：**

- **debug**: 详细的调试信息，生产环境关闭
- **info**: 重要的业务流程节点
- **warn**: 可恢复的错误或异常情况
- **error**: 严重错误，需要用户关注

### 结构化日志

**日志格式要求：**

```typescript
Logger.info('Operation completed', {
  operation: 'syncRules',
  sourceId: 'company-rules',
  duration: 1234,
  count: 42,
});
```

**避免：**

```typescript
Logger.info(`Synced ${count} rules from ${sourceId}`); // 难以解析
```

## 文档即代码

### JSDoc 注释规范

**公共 API 必须有 JSDoc：**

- 类和方法的用途说明
- 参数和返回值说明
- 使用示例（如果复杂）
- 异常说明

### 类型定义即文档

**使用 TypeScript 类型系统：**

- 精确的类型定义
- 使用联合类型表达可能的值
- 接口继承表达关系
- 泛型提供灵活性

## 部署与发布架构

### 构建优化

**打包策略：**

- 使用 esbuild 快速构建
- Tree-shaking 移除无用代码
- 压缩输出文件
- Source map 用于调试

### 版本管理

**语义化版本：**

- Major: 破坏性变更
- Minor: 新功能（向后兼容）
- Patch: Bug 修复

### 向后兼容

**兼容性保证：**

- 配置格式向后兼容
- 提供迁移脚本
- 废弃功能有过渡期
- 文档说明变更

## 最佳实践总结

### 架构原则检查清单

- [ ] 每个模块单一职责
- [ ] 依赖关系清晰，避免循环依赖
- [ ] 接口抽象，面向接口编程
- [ ] 错误处理统一且完整
- [ ] 日志记录结构化且有用
- [ ] 性能考虑（缓存、并发）
- [ ] 安全验证（输入、路径）
- [ ] 测试覆盖核心逻辑
- [ ] 文档与代码同步
- [ ] 扩展点设计合理
