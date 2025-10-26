---
id: vscode-extension-coding-standards
title: VSCode 扩展编码规范
priority: high
tags: [vscode, coding-standards, typescript, style-guide]
version: 1.0.0
author: Turbo AI Rules
description: VSCode 扩展开发的全面编码规范和风格指南
---

# VSCode Extension Coding Standards

## 技术基线

- 语言：TypeScript 5.9+
- 运行时：Node.js 24.9+
- VSCode API：1.105+
- 构建：esbuild
- 包管理：pnpm（必须）
- 测试：Vitest（单元）+ Mocha（集成）
- 规范：ESLint 9 + Prettier
- Git：simple-git；文件系统：fs-extra

## TypeScript 基础规范

### 严格模式配置

**tsconfig.json 必须启用严格模式：**

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true
  }
}
```

### 类型使用规范

**避免 any 类型：**

```typescript
// ❌ 避免
function process(data: any) {
  return data.value;
}

// ✅ 推荐
function process(data: { value: string }): string {
  return data.value;
}

// ✅ 或使用泛型
function process<T extends { value: string }>(data: T): string {
  return data.value;
}
```

**必须使用 any 时添加注释说明原因或者添加下以注释**
`/* eslint-disable @typescript-eslint/no-explicit-any */`

```typescript
// 必须使用 any：VSCode API 返回类型未定义
const config: any = vscode.workspace.getConfiguration();
```

**使用 unknown 代替 any（安全的未知类型）：**

```typescript
// ✅ 推荐
function parseJson(json: string): unknown {
  return JSON.parse(json);
}

// 使用前需要类型检查
const data = parseJson('{"name":"test"}');
if (typeof data === 'object' && data !== null) {
  // 安全使用
}
```

## 命名规范

### 文件命名

**类/服务文件：PascalCase**

```
GitManager.ts
RulesParser.ts
ConfigManager.ts
```

**工具函数文件：camelCase**

```
logger.ts
fileSystem.ts
validator.ts
```

**类型定义文件：camelCase**

```
types/
  config.ts
  rules.ts
  errors.ts
```

### 变量和函数命名

**变量和函数：camelCase**

```typescript
const userName = 'John';
const isEnabled = true;
function getUserName(): string { ... }
async function syncRules(): Promise<void> { ... }
```

**类和接口：PascalCase**

```typescript
class GitManager { ... }
interface RuleSource { ... }
interface ParsedRule { ... }
```

**常量：UPPER_SNAKE_CASE**

```typescript
const MAX_RETRY_COUNT = 3;
const DEFAULT_CACHE_DIR = '~/.turbo-ai-rules';
const RULE_FILE_EXTENSIONS = ['.md', '.mdc'];
```

**私有成员：_prefix**

```typescript
class RulesManager {
  private _cache: Map<string, ParsedRule>;
  private _initialized = false;

  private _initializeCache(): void { ... }
}
```

**布尔变量：is/has/should/can 前缀**

```typescript
const isEnabled = true;
const hasError = false;
const shouldSync = true;
const canWrite = false;
```

### 类型命名

**接口：描述性名词**

```typescript
interface RuleSource { ... }
interface ParsedRule { ... }
interface GitStatus { ... }
```

**类型别名：Type 后缀（可选）**

```typescript
type UserIdType = string | number;
type CallbackType = (data: any) => void;
type ErrorHandlerType = (error: Error) => void;
```

**枚举：PascalCase**

```typescript
enum ErrorCodes {
  CONFIG_MISSING = 'TAI-1001',
  GIT_CLONE_FAILED = 'TAI-2002',
  PARSE_INVALID = 'TAI-3001',
}
```

## 代码组织规范

### 导入顺序

**标准导入顺序：**

```typescript
// 1. Node 内置模块
import * as fs from 'fs';
import * as path from 'path';

// 2. 第三方模块
import * as vscode from 'vscode';
import matter from 'gray-matter';

// 3. 内部别名导入 (@/)
import type { RuleSource } from '@/types';
import { Logger } from '@/utils/logger';

// 4. 相对路径导入
import { GitManager } from '../services/GitManager';
import type { ParseOptions } from './types';
```

### 导出规范

**优先使用命名导出：**

```typescript
// ✅ 推荐
export class GitManager { ... }
export interface RuleSource { ... }
export const DEFAULT_CONFIG = { ... };

// ❌ 避免默认导出（除非是 React 组件）
export default class GitManager { ... }
```

**统一导出点（index.ts）：**

```typescript
// services/index.ts
export { GitManager } from './GitManager';
export { RulesManager } from './RulesManager';
export { ConfigManager } from './ConfigManager';
```

### 函数规模

**单个函数不超过 50 行：**

- 如果超过，拆分成多个小函数
- 每个函数只做一件事
- 使用描述性的函数名

**复杂逻辑提取为独立函数：**

```typescript
// ❌ 避免
async function syncRules(sourceId: string): Promise<void> {
  // 100+ 行代码...
}

// ✅ 推荐
async function syncRules(sourceId: string): Promise<void> {
  await validateSource(sourceId);
  const rules = await fetchRules(sourceId);
  await mergeRules(rules);
  await generateConfigs();
}
```

### 类设计

**单一职责原则：**

```typescript
// ✅ 每个类只负责一件事
class GitManager {
  // 只负责 Git 操作
}

class RulesParser {
  // 只负责规则解析
}

class FileGenerator {
  // 只负责文件生成
}
```

**组合优于继承：**

```typescript
// ✅ 推荐使用组合
class RulesOrchestrator {
  constructor(
    private gitManager: GitManager,
    private parser: RulesParser,
    private generator: FileGenerator
  ) {}
}

// ❌ 避免深层继承
class BaseManager { ... }
class GitManager extends BaseManager { ... }
class AdvancedGitManager extends GitManager { ... }
```

## 异步编程规范

### async/await 优先

**使用 async/await 而非 Promise 链：**

```typescript
// ✅ 推荐
async function processRules(): Promise<void> {
  try {
    const rules = await fetchRules();
    const validated = await validateRules(rules);
    await saveRules(validated);
  } catch (error) {
    Logger.error('Failed to process rules', error);
    throw error;
  }
}

// ❌ 避免
function processRules(): Promise<void> {
  return fetchRules()
    .then((rules) => validateRules(rules))
    .then((validated) => saveRules(validated))
    .catch((error) => {
      Logger.error('Failed to process rules', error);
      throw error;
    });
}
```

### 并行处理

**独立任务使用 Promise.all：**

```typescript
// ✅ 并行处理
async function syncMultipleSources(sourceIds: string[]): Promise<void> {
  await Promise.all(sourceIds.map((id) => syncSingleSource(id)));
}

// ❌ 串行处理（如果不需要）
async function syncMultipleSources(sourceIds: string[]): Promise<void> {
  for (const id of sourceIds) {
    await syncSingleSource(id); // 不必要的等待
  }
}
```

**限制并发数：**

```typescript
async function syncWithConcurrencyLimit(sourceIds: string[], concurrency = 3): Promise<void> {
  const queue = [...sourceIds];
  const active: Promise<void>[] = [];

  while (queue.length > 0 || active.length > 0) {
    while (active.length < concurrency && queue.length > 0) {
      const id = queue.shift()!;
      const promise = syncSingleSource(id).finally(() => {
        active.splice(active.indexOf(promise), 1);
      });
      active.push(promise);
    }

    await Promise.race(active);
  }
}
```

## 错误处理规范

### try-catch 使用

**所有异步函数必须有错误处理：**

```typescript
// ✅ 正确
async function loadConfig(): Promise<Config> {
  try {
    const content = await fs.readFile(configPath, 'utf-8');
    return JSON.parse(content);
  } catch (error) {
    Logger.error('Failed to load config', error, { configPath });
    throw new ConfigError('Config load failed', ErrorCodes.CONFIG_MISSING, error);
  }
}

// ❌ 错误：没有错误处理
async function loadConfig(): Promise<Config> {
  const content = await fs.readFile(configPath, 'utf-8');
  return JSON.parse(content);
}
```

### 错误类型

**使用具体的错误类型：**

```typescript
export class ParseError extends Error {
  constructor(
    message: string,
    public code: string,
    public filePath?: string,
    public cause?: Error,
  ) {
    super(message);
    this.name = 'ParseError';
  }
}

// 使用
throw new ParseError(
  'Invalid frontmatter',
  ErrorCodes.PARSE_INVALID_FORMAT,
  filePath,
  originalError,
);
```

## 注释规范

> **⚠️ 重要：必须使用注释生成工具**
>
> 为保证注释质量和一致性，**强制要求**使用以下工具：
>
> 1. **turbo-file-header** - 函数注释自动生成
>
>    - 快捷键：`Ctrl+Alt+/` (Windows/Linux) 或 `Cmd+Alt+/` (Mac)
>    - 用途：在函数上方按快捷键自动生成标准 JSDoc 注释框架
>    - 生成后需补充具体的参数说明、返回值说明和异常说明
>
> 2. **turbo-console-log** - 调试日志自动插入
>    - 快捷键：`Ctrl+Alt+L` (Windows/Linux) 或 `Cmd+Alt+L` (Mac)
>    - 用途：选中变量后按快捷键自动插入格式化的 console.log
>    - 在开发调试时使用，提交前需替换为 Logger 调用
>
> **代码审查时必须检查：**
>
> - ✅ 所有公共 API 函数都有完整的 JSDoc 注释（使用 turbo-file-header 生成）
> - ✅ 调试日志已从 console.log 迁移到 Logger（turbo-console-log 仅用于开发）
> - ✅ 注释格式统一，符合生成工具的标准格式

### 扩展的 JSDoc 注释

**公共 API 必须有 JSDoc：**

函数注释示例：
返回值、参数都用 {type} 格式，如果类型未知，可用 {auto}

```typescript
/**
 * @description 解析 MDC 文件
 * @return {Promise<ParsedRule>} 解析后的规则
 * @param filePath {string} 文件路径
 * @param sourceId {string} 规则源 ID
 * @throws {ParseError} 当文件格式无效时 // 可选
 */
async function parseMdcFile(filePath: string, sourceId: string): Promise<ParsedRule> {
  // ...
}
```

**工作流程：**

1. 在函数上方按 `Ctrl+Alt+/` 使用 turbo-file-header 生成注释框架
2. 补充具体的参数说明、功能描述、返回值说明
3. 添加 @throws 说明可能抛出的异常
4. 添加使用示例（复杂 API 需要）

### 行内注释

* 复杂逻辑添加注释，一行写不上使块注释
* 最好把原因或者原理或者设计写上，以便后续看到还能看懂

```typescript
// 计算优先级权重（高=3，中=2，低=1）
const weight = priority === 'high' ? 3 : priority === 'medium' ? 2 : 1;

// 同一仓库的源必须串行处理，避免 Git 冲突
for (const source of repositoryGroup.sources) {
  await syncSingleSource(source);
}
```

**开发调试注释（临时使用）：**

```typescript
// 使用 turbo-console-log（Ctrl+Alt+L）快速插入调试日志
// 如果后续有行号变化，使用 turbo-console-log (Ctrl+Alt+U) 重新生成
// 选中变量 userData，按快捷键自动生成：
console.log('🚀 ~ file: UserManager.ts:42 ~ loadUser ~ userData:', userData);

// 提交前最好确认是否仍需要，并且是否添加/替换 Logger 调用
Logger.debug('User data loaded', { userData });
```

**避免无意义的注释：**

```typescript
// ❌ 避免
// 创建变量
const count = 0;

// 循环遍历数组
for (const item of items) { ... }

// ✅ 只注释"为什么"，不注释"是什么"
// 使用 LRU 缓存避免重复解析（最大 100 条）
const cache = new LRUCache<string, ParsedRule>(100);
```

### 调试日志

**优先使用 turbo-console-log 扩展：**

- 快捷键：`Ctrl+Alt+L` (Windows/Linux) 或 `Cmd+Alt+L` (Mac)
- 自动插入结构化日志语句
- 包含变量名和值

**日志语句规范：**

```typescript
Logger.debug('rules', { rules });

// ✅ 手动添加时保持结构化
Logger.debug('Processing rules', { count: rules.length, sourceId });
```

## 代码风格规范

### 缩进和空格

- 使用 **2 空格** 缩进
- 文件末尾保留一个空行
- 行尾不留空格
- 空行不留空格，除非需要

### 引号

- 优先使用 **单引号** `'`
- 模板字符串使用反引号 `` ` ``
- JSX 属性使用双引号 `"`

### 分号

- **使用分号** 结束语句
- ESLint 会自动检查

### 行长度

- 建议不超过 **100 字符**
- 必要时可以换行

### 空行

**适当使用空行提高可读性：**

```typescript
// ✅ 推荐
export class GitManager {
  private cache: Map<string, GitStatus>;

  constructor() {
    this.cache = new Map();
  }

  async cloneRepository(url: string): Promise<void> {
    // 实现
  }

  async pullChanges(path: string): Promise<void> {
    // 实现
  }
}
```

## 性能优化规范

### 避免重复计算

**缓存计算结果：**

```typescript
// ❌ 避免
function getFilteredRules(rules: ParsedRule[]): ParsedRule[] {
  return rules.filter((r) => r.metadata.priority === 'high'); // 每次调用都重新过滤
}

// ✅ 推荐
class RulesManager {
  private _highPriorityCache?: ParsedRule[];

  getHighPriorityRules(rules: ParsedRule[]): ParsedRule[] {
    if (!this._highPriorityCache) {
      this._highPriorityCache = rules.filter((r) => r.metadata.priority === 'high');
    }
    return this._highPriorityCache;
  }

  invalidateCache(): void {
    this._highPriorityCache = undefined;
  }
}
```

### 懒加载

**延迟初始化重资源：**

```typescript
class ExtensionManager {
  private _gitManager?: GitManager;

  get gitManager(): GitManager {
    if (!this._gitManager) {
      this._gitManager = new GitManager();
    }
    return this._gitManager;
  }
}
```

### 防抖和节流

**使用防抖避免频繁触发：**

```typescript
import { debounce } from '../utils/debounce';

// 文件监听使用防抖（300ms）
const debouncedRefresh = debounce(() => {
  this.refreshTreeView();
}, 300);

watcher.onDidChange(debouncedRefresh);
```

## VSCode API 使用规范

### 命令注册

**命令 ID 命名规范：**

```typescript
// 格式: 扩展名.动作
context.subscriptions.push(
  vscode.commands.registerCommand('turboAiRules.addSource', addSourceCommand),
  vscode.commands.registerCommand('turboAiRules.syncRules', syncRulesCommand),
  vscode.commands.registerCommand('turboAiRules.searchRules', searchRulesCommand),
);
```

### 配置读取

**使用类型安全的配置读取：**

```typescript
const config = vscode.workspace.getConfiguration('turboAiRules');
const sources = config.get<RuleSource[]>('sources', []);
const autoSync = config.get<boolean>('sync.auto', true);
```

### 用户交互

**QuickPick 使用：**

```typescript
const selected = await vscode.window.showQuickPick(items, {
  placeHolder: 'Select a rule source',
  ignoreFocusOut: true,
  matchOnDescription: true,
  matchOnDetail: true,
});

if (!selected) {
  return; // 用户取消
}
```

**InputBox 使用：**

```typescript
const input = await vscode.window.showInputBox({
  prompt: 'Enter Git repository URL',
  placeHolder: 'https://github.com/username/repo.git',
  validateInput: (value) => {
    if (!isValidGitUrl(value)) {
      return 'Invalid Git URL format';
    }
    return undefined; // 验证通过
  },
});
```

### 进度提示

**长时间操作使用进度提示：**

```typescript
await vscode.window.withProgress(
  {
    location: vscode.ProgressLocation.Notification,
    title: 'Syncing rules',
    cancellable: true,
  },
  async (progress, token) => {
    token.onCancellationRequested(() => {
      Logger.info('User cancelled sync');
    });

    progress.report({ increment: 0, message: 'Cloning repository...' });
    await gitManager.clone(url);

    progress.report({ increment: 50, message: 'Parsing rules...' });
    await parseRules();

    progress.report({ increment: 100, message: 'Done!' });
  },
);
```

## 代码审查检查清单

### 提交前自检

- [ ] 代码通过 `pnpm run lint`
- [ ] 代码通过 `pnpm test`
- [ ] 所有 `any` 类型都有注释说明
- [ ] 公共 API 有 JSDoc 注释（使用 turbo-file-header 生成）
- [ ] 调试日志已从 console.log 迁移到 Logger（turbo-console-log 仅用于开发）
- [ ] 异步函数有错误处理
- [ ] 没有 console.log（使用 Logger）
- [ ] 没有硬编码的路径或 URL
- [ ] 敏感信息不在代码中
- [ ] 变量命名清晰准确
- [ ] 函数长度合理（<50 行）
- [ ] 导入顺序正确
- [ ] 没有未使用的导入
- [ ] 添加了必要的单元测试

### 代码审查关注点

- [ ] 架构设计是否合理
- [ ] 是否遵循单一职责原则
- [ ] 错误处理是否完整
- [ ] 性能是否有问题
- [ ] 安全性是否有漏洞
- [ ] 测试覆盖是否充分
- [ ] 文档是否需要更新
- [ ] 是否有更好的实现方式

## ESLint 和 Prettier 配置

### ESLint 规则

**关键规则说明：**

```javascript
{
  "@typescript-eslint/no-explicit-any": "warn", // any 警告
  "@typescript-eslint/explicit-function-return-type": "off", // 允许类型推断
  "@typescript-eslint/no-unused-vars": "error", // 未使用变量报错
  "prefer-const": "error", // 优先使用 const
  "no-console": "warn" // 禁止 console.log
}
```

### Prettier 配置

**项目统一格式化：**

```json
{
  "singleQuote": true,
  "semi": true,
  "trailingComma": "es5",
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false
}
```

## 最佳实践总结

### 代码质量金字塔

1. **可读性**：清晰的命名和结构
2. **可维护性**：模块化和文档
3. **可测试性**：依赖注入和隔离
4. **性能**：合理的优化
5. **安全性**：输入验证和错误处理

### 持续改进

- 定期 Code Review
- 及时重构技术债
- 学习最佳实践
- 更新文档和注释
- 提高测试覆盖率

### 学习资源

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [VSCode Extension API](https://code.visualstudio.com/api)
- [Clean Code JavaScript](https://github.com/ryanmcdermott/clean-code-javascript)
- [Effective TypeScript](https://effectivetypescript.com/)
