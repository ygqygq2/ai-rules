---
id: vscode-extension-error-handling
title: VSCode 扩展错误处理规范
priority: high
tags: [vscode, error-handling, logging, error-codes]
version: 1.0.0
author: Turbo AI Rules
description: VSCode 扩展开发的错误处理和日志记录规范
---

# VSCode 扩展错误处理规范

## 统一日志系统

### 使用专业日志库

**推荐使用 @ygqygq2/vscode-log：**

```typescript
import { Logger } from '@ygqygq2/vscode-log';

// 在 extension.ts 初始化单例
export function activate(context: vscode.ExtensionContext) {
  const logger = new Logger('YourExtensionName');
  // ...
}
```

**或使用其他专业日志库：**

- `vscode-extension-telemetry`
- `winston`
- 自定义日志封装

### 日志级别规范

**四个标准日志级别：**

**debug - 调试信息**

- 详细的程序执行流程
- 变量值和状态变化
- 仅在开发和调试时使用
- 生产环境应关闭

```typescript
Logger.debug('Parsing file', { filePath, lineCount });
Logger.debug('Cache hit', { key, ttl: cache.getTTL(key) });
```

**info - 重要信息**

- 重要的业务流程节点
- 用户操作的成功执行
- 系统状态变化
- 最小可用的日志级别

```typescript
Logger.info('Extension activated');
Logger.info('Command executed', { command: 'addSource', duration: 123 });
Logger.info('Sync completed', { sourceId, ruleCount: 42 });
```

**warn - 警告信息**

- 可恢复的错误或异常
- 不符合预期但不影响主流程
- 配置缺失但有默认值
- 性能问题或资源限制

```typescript
Logger.warn('Configuration missing, using default', { key: 'syncInterval' });
Logger.warn('API rate limit approaching', { remaining: 10, limit: 100 });
Logger.warn('Large file detected', { size: '10MB', path: filePath });
```

**error - 错误信息**

- 严重错误，影响功能
- 未捕获的异常
- 需要用户关注的问题
- 系统级错误

```typescript
Logger.error('Failed to clone repository', error, { url, branch });
Logger.error('File write failed', error, { path, permissions });
Logger.error('API request failed', error, { endpoint, statusCode: 500 });
```

### 结构化日志

**使用对象传递上下文信息：**

```typescript
// ✅ 推荐：结构化日志
Logger.info('Sync started', {
  sourceId: 'company-rules',
  gitUrl: 'https://github.com/company/rules.git',
  branch: 'main',
  timestamp: Date.now(),
});

// ❌ 避免：字符串拼接
Logger.info(`Syncing ${sourceId} from ${gitUrl} on branch ${branch}`);
```

**上下文信息包含关键数据：**

- 操作标识（ID、名称）
- 参数值
- 执行结果（数量、状态）
- 时间信息（耗时、时间戳）

### 敏感信息保护

**禁止输出敏感信息：**

```typescript
// ❌ 禁止
Logger.info('User authenticated', {
  username,
  password, // 禁止
  token, // 禁止
  apiKey, // 禁止
  email, // 禁止
});

// ✅ 推荐
Logger.info('User authenticated', {
  username,
  tokenHash: hashToken(token), // 使用哈希
  emailDomain: email.split('@')[1], // 只记录域名
});
```

**敏感信息清单：**

- 密码和令牌
- API 密钥
- 个人邮箱
- 电话号码
- IP 地址（视情况）
- 文件完整路径（可能包含用户名）

## 错误码系统

### 错误码设计原则

**命名空间前缀**

使用项目特定的前缀（2-4 个字母）：

```typescript
// 示例项目前缀
const PREFIX = 'TAI'; // Turbo AI Rules
const PREFIX = 'VSE'; // VS Code Extension
const PREFIX = 'APP'; // Application
```

**分类编号系统**

采用千位分类法：

- `XXX-100x`: 配置类错误
- `XXX-200x`: 网络/Git 类错误
- `XXX-300x`: 解析/验证类错误
- `XXX-400x`: 文件操作类错误
- `XXX-500x`: 系统类错误

### 错误码定义示例

**配置类错误 (100x)：**

```typescript
export enum ConfigErrorCodes {
  CONFIG_MISSING = 'VSE-1001', // 配置文件缺失
  CONFIG_INVALID_FORMAT = 'VSE-1002', // 配置格式错误（JSON 语法）
  CONFIG_MISSING_FIELD = 'VSE-1003', // 必填字段缺失
  CONFIG_INVALID_VALUE = 'VSE-1004', // 字段值超出范围
  CONFIG_SCHEMA_ERROR = 'VSE-1005', // Schema 验证失败
}
```

**网络/Git 类错误 (200x)：**

```typescript
export enum GitErrorCodes {
  GIT_INVALID_URL = 'VSE-2001', // Git URL 格式无效
  GIT_CLONE_FAILED = 'VSE-2002', // 克隆失败
  GIT_PULL_FAILED = 'VSE-2003', // 拉取失败
  GIT_AUTH_FAILED = 'VSE-2004', // 认证失败
  GIT_BRANCH_NOT_FOUND = 'VSE-2005', // 分支不存在
  GIT_NETWORK_ERROR = 'VSE-2006', // 网络错误
}
```

**解析/验证类错误 (300x)：**

```typescript
export enum ParseErrorCodes {
  PARSE_INVALID_FORMAT = 'VSE-3001', // 文件格式错误
  PARSE_MISSING_METADATA = 'VSE-3002', // 元数据缺失
  PARSE_VALIDATION_FAILED = 'VSE-3003', // 验证失败
  PARSE_ENCODING_ERROR = 'VSE-3004', // 编码错误
}
```

**文件操作类错误 (400x)：**

```typescript
export enum FileErrorCodes {
  FILE_WRITE_FAILED = 'VSE-4001', // 写入失败
  FILE_READ_FAILED = 'VSE-4002', // 读取失败
  FILE_NOT_FOUND = 'VSE-4003', // 文件不存在
  FILE_PERMISSION_DENIED = 'VSE-4004', // 权限不足
  FILE_ALREADY_EXISTS = 'VSE-4005', // 文件已存在
}
```

**系统类错误 (500x)：**

```typescript
export enum SystemErrorCodes {
  SYSTEM_IO_ERROR = 'VSE-5001', // IO 错误
  SYSTEM_PERMISSION_DENIED = 'VSE-5002', // 系统权限不足
  SYSTEM_PATH_TRAVERSAL = 'VSE-5003', // 路径越界
  SYSTEM_DISK_FULL = 'VSE-5004', // 磁盘空间不足
  SYSTEM_UNKNOWN_ERROR = 'VSE-5999', // 未知错误
}
```

### 自定义错误类

**基础错误类：**

```typescript
export class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public cause?: Error,
    public context?: Record<string, unknown>,
  ) {
    super(message);
    this.name = 'AppError';

    // 保持错误堆栈
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, this.constructor);
    }
  }
}
```

**特定错误类：**

```typescript
export class ConfigError extends AppError {
  constructor(message: string, code: string, cause?: Error) {
    super(message, code, cause);
    this.name = 'ConfigError';
  }
}

export class ParseError extends AppError {
  constructor(message: string, code: string, public filePath?: string, cause?: Error) {
    super(message, code, cause, { filePath });
    this.name = 'ParseError';
  }
}

export class GitError extends AppError {
  constructor(message: string, code: string, public gitUrl?: string, cause?: Error) {
    super(message, code, cause, { gitUrl });
    this.name = 'GitError';
  }
}
```

## 错误处理策略

### 分层错误处理

**底层 - 抛出带错误码的异常：**

```typescript
async function readConfig(path: string): Promise<Config> {
  try {
    const content = await fs.readFile(path, 'utf-8');
    return JSON.parse(content);
  } catch (error) {
    throw new ConfigError(
      `Failed to read config: ${path}`,
      ConfigErrorCodes.CONFIG_MISSING,
      error as Error,
    );
  }
}
```

**中层 - 捕获、转换、记录：**

```typescript
async function loadConfig(configPath: string): Promise<Config> {
  try {
    const config = await readConfig(configPath);
    return validateConfig(config);
  } catch (error) {
    if (error instanceof ConfigError) {
      Logger.error('Config load failed', error, {
        configPath,
        code: error.code,
      });
      throw error;
    }

    // 转换未知错误
    Logger.error('Unexpected error loading config', error as Error, { configPath });
    throw new ConfigError(
      'Failed to load configuration',
      ConfigErrorCodes.CONFIG_INVALID_FORMAT,
      error as Error,
    );
  }
}
```

**顶层 - 用户友好提示：**

```typescript
async function loadConfigCommand(): Promise<void> {
  try {
    const config = await loadConfig(configPath);
    vscode.window.showInformationMessage('Configuration loaded successfully');
  } catch (error) {
    if (error instanceof ConfigError) {
      // 根据错误码提供具体建议
      const suggestion = getErrorSuggestion(error.code);
      vscode.window.showErrorMessage(`${error.message}\n\n💡 建议: ${suggestion}`);
    } else {
      vscode.window.showErrorMessage('An unexpected error occurred');
    }
  }
}

function getErrorSuggestion(code: string): string {
  switch (code) {
    case ConfigErrorCodes.CONFIG_MISSING:
      return '请检查配置文件是否存在，或使用默认配置';
    case ConfigErrorCodes.CONFIG_INVALID_FORMAT:
      return '请检查 JSON 格式是否正确，注意逗号和引号';
    case GitErrorCodes.GIT_AUTH_FAILED:
      return '请检查访问令牌是否有效，或配置 SSH 密钥';
    case GitErrorCodes.GIT_NETWORK_ERROR:
      return '请检查网络连接，或配置代理设置';
    default:
      return '请查看日志获取详细信息';
  }
}
```

### try-catch 覆盖原则

**所有异步操作必须有错误处理：**

```typescript
// ✅ 正确
async function syncRules(): Promise<void> {
  try {
    await gitManager.pull();
    await parseRules();
    await generateConfigs();
  } catch (error) {
    Logger.error('Sync failed', error as Error);
    throw error;
  }
}

// ❌ 错误：缺少错误处理
async function syncRules(): Promise<void> {
  await gitManager.pull();
  await parseRules();
  await generateConfigs();
}
```

**外部 API 调用必须有超时和重试：**

```typescript
async function fetchWithRetry<T>(fn: () => Promise<T>, maxRetries = 3, timeout = 5000): Promise<T> {
  let lastError: Error;

  for (let i = 0; i < maxRetries; i++) {
    try {
      const result = await Promise.race([
        fn(),
        new Promise<never>((_, reject) => setTimeout(() => reject(new Error('Timeout')), timeout)),
      ]);
      return result;
    } catch (error) {
      lastError = error as Error;
      Logger.warn(`Retry ${i + 1}/${maxRetries}`, { error: lastError.message });
      await sleep(1000 * (i + 1)); // 指数退避
    }
  }

  throw lastError!;
}
```

### 错误恢复策略

**优雅降级：**

```typescript
async function loadRulesWithFallback(sourceId: string): Promise<ParsedRule[]> {
  try {
    // 尝试从远程加载
    return await loadRemoteRules(sourceId);
  } catch (error) {
    Logger.warn('Failed to load remote rules, using cache', error as Error);

    try {
      // 降级到本地缓存
      return await loadCachedRules(sourceId);
    } catch (cacheError) {
      Logger.error('Failed to load cached rules', cacheError as Error);

      // 最后降级到空数组
      return [];
    }
  }
}
```

**部分失败处理：**

```typescript
async function syncMultipleSources(
  sourceIds: string[],
): Promise<{ succeeded: string[]; failed: string[] }> {
  const results = await Promise.allSettled(sourceIds.map((id) => syncSource(id)));

  const succeeded: string[] = [];
  const failed: string[] = [];

  results.forEach((result, index) => {
    const sourceId = sourceIds[index];
    if (result.status === 'fulfilled') {
      succeeded.push(sourceId);
    } else {
      failed.push(sourceId);
      Logger.error('Source sync failed', result.reason, { sourceId });
    }
  });

  return { succeeded, failed };
}
```

## 用户提示规范

### 错误提示格式

**问题 + 建议的格式：**

```typescript
vscode.window.showErrorMessage(
  `❌ 无法克隆仓库: ${repoUrl}\n\n💡 建议: 请检查仓库 URL 是否正确，或配置网络代理`,
);
```

**提供操作按钮：**

```typescript
const action = await vscode.window.showErrorMessage(
  '配置文件缺失',
  '创建默认配置',
  '打开设置',
  '查看文档',
);

switch (action) {
  case '创建默认配置':
    await createDefaultConfig();
    break;
  case '打开设置':
    await vscode.commands.executeCommand('workbench.action.openSettings');
    break;
  case '查看文档':
    await vscode.env.openExternal(vscode.Uri.parse(DOCS_URL));
    break;
}
```

### 进度提示

**长时间操作显示进度：**

```typescript
await vscode.window.withProgress(
  {
    location: vscode.ProgressLocation.Notification,
    title: '正在同步规则',
    cancellable: true,
  },
  async (progress, token) => {
    // 监听取消
    token.onCancellationRequested(() => {
      Logger.info('User cancelled sync');
    });

    try {
      progress.report({ increment: 0, message: '克隆仓库...' });
      await gitManager.clone(url);

      progress.report({ increment: 50, message: '解析规则...' });
      await parseRules();

      progress.report({ increment: 100, message: '完成!' });
    } catch (error) {
      Logger.error('Sync failed', error as Error);
      throw error; // 让 VSCode 显示错误提示
    }
  },
);
```

## 错误监控和分析

### 错误统计

**收集错误指标：**

```typescript
class ErrorMetrics {
  private errorCounts = new Map<string, number>();

  recordError(code: string): void {
    const count = this.errorCounts.get(code) || 0;
    this.errorCounts.set(code, count + 1);
  }

  getTopErrors(limit = 10): Array<{ code: string; count: number }> {
    return Array.from(this.errorCounts.entries())
      .map(([code, count]) => ({ code, count }))
      .sort((a, b) => b.count - a.count)
      .slice(0, limit);
  }

  reset(): void {
    this.errorCounts.clear();
  }
}
```

### 错误日志聚合

**定期输出错误摘要：**

```typescript
setInterval(() => {
  const topErrors = errorMetrics.getTopErrors(5);
  if (topErrors.length > 0) {
    Logger.info('Error summary', { topErrors });
  }
}, 60 * 60 * 1000); // 每小时一次
```

## 最佳实践检查清单

### 错误处理检查

- [ ] 所有 async 函数有 try-catch
- [ ] 错误包含错误码
- [ ] 错误有上下文信息（参数、路径等）
- [ ] 用户提示友好且可操作
- [ ] 敏感信息不在日志中
- [ ] 错误有恢复或降级策略

### 日志记录检查

- [ ] 使用专业日志库
- [ ] 日志级别使用正确
- [ ] 日志信息结构化
- [ ] 关键操作有日志记录
- [ ] 日志包含足够上下文
- [ ] 生产环境关闭 debug 日志

### 用户体验检查

- [ ] 错误提示清晰易懂
- [ ] 提供具体的解决建议
- [ ] 长操作有进度提示
- [ ] 支持取消长操作
- [ ] 错误不阻塞主流程（如果可以降级）

## 常见错误处理模式

### 配置加载模式

```typescript
async function loadConfigWithDefaults(): Promise<Config> {
  try {
    const config = await loadConfig();
    return validateAndMergeDefaults(config);
  } catch (error) {
    if (error instanceof ConfigError && error.code === ConfigErrorCodes.CONFIG_MISSING) {
      Logger.warn('Config not found, using defaults');
      return getDefaultConfig();
    }
    throw error;
  }
}
```

### 资源清理模式

```typescript
async function processWithCleanup(): Promise<void> {
  const tempFile = await createTempFile();
  try {
    await processFile(tempFile);
  } finally {
    // 确保资源清理
    await fs.remove(tempFile);
  }
}
```

### 批处理错误模式

```typescript
async function processBatch<T>(
  items: T[],
  processor: (item: T) => Promise<void>,
): Promise<{ success: number; failed: number }> {
  let success = 0;
  let failed = 0;

  for (const item of items) {
    try {
      await processor(item);
      success++;
    } catch (error) {
      failed++;
      Logger.error('Item processing failed', error as Error, { item });
      // 继续处理下一个
    }
  }

  return { success, failed };
}
```
