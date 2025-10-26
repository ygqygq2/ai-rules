---
id: vscode-extension-security
title: VSCode 扩展安全规范
priority: high
tags: [vscode, security, validation, secrets]
version: 1.0.0
author: Turbo AI Rules
description: VSCode 扩展开发的安全规范和最佳实践
---

# VSCode 扩展安全规范

## 输入验证

### URL 验证

**Git URL 格式验证：**

```typescript
function validateGitUrl(url: string): boolean {
  const patterns = [
    /^https:\/\/[\w.-]+\.[\w.-]+(\/[\w.-]+)*\.git$/, // HTTPS
    /^git@[\w.-]+:[\w.-]+(\/[\w.-]+)*\.git$/, // SSH
  ];

  return patterns.some((pattern) => pattern.test(url));
}

// 使用示例
if (!validateGitUrl(userInput)) {
  throw new ValidationError('Invalid Git URL format', ErrorCodes.VALIDATION_INVALID_URL);
}
```

**HTTP/HTTPS URL 验证：**

```typescript
function validateHttpUrl(url: string): boolean {
  try {
    const parsed = new URL(url);
    return ['http:', 'https:'].includes(parsed.protocol);
  } catch {
    return false;
  }
}
```

### 路径验证

**防止目录遍历攻击：**

```typescript
import * as path from 'path';

function validatePath(inputPath: string, baseDir: string): { valid: boolean; normalized: string } {
  // 规范化路径
  const normalized = path.normalize(inputPath);
  const resolved = path.resolve(baseDir, normalized);

  // 检查是否在允许的目录内
  const valid = resolved.startsWith(path.resolve(baseDir));

  return { valid, normalized: resolved };
}

// 使用示例
const { valid, normalized } = validatePath(userPath, workspaceRoot);
if (!valid) {
  throw new SecurityError('Path traversal detected', ErrorCodes.SECURITY_PATH_TRAVERSAL);
}
```

**白名单验证：**

```typescript
function validateWorkspacePath(filePath: string): boolean {
  const allowedDirs = [
    workspaceRoot,
    path.join(workspaceRoot, '.vscode'),
    path.join(workspaceRoot, '.github'),
    globalStoragePath,
  ];

  const resolved = path.resolve(filePath);
  return allowedDirs.some((dir) => resolved.startsWith(path.resolve(dir)));
}
```

### 分支名验证

**防止命令注入：**

```typescript
function validateBranchName(branch: string): boolean {
  // 只允许字母、数字、下划线、连字符和斜杠
  const pattern = /^[a-zA-Z0-9_\/-]+$/;

  // 检查长度
  if (branch.length === 0 || branch.length > 255) {
    return false;
  }

  // 检查格式
  return pattern.test(branch);
}

// 使用示例
if (!validateBranchName(userBranch)) {
  throw new ValidationError('Invalid branch name format', ErrorCodes.VALIDATION_INVALID_BRANCH);
}
```

### 配置值验证

**数值范围验证：**

```typescript
function validateConfigValue<T>(
  value: T,
  validator: {
    min?: number;
    max?: number;
    allowed?: T[];
    pattern?: RegExp;
  },
): boolean {
  if (typeof value === 'number') {
    if (validator.min !== undefined && value < validator.min) return false;
    if (validator.max !== undefined && value > validator.max) return false;
  }

  if (validator.allowed && !validator.allowed.includes(value)) {
    return false;
  }

  if (validator.pattern && typeof value === 'string') {
    return validator.pattern.test(value);
  }

  return true;
}

// 使用示例
const syncInterval = config.get<number>('sync.interval');
if (!validateConfigValue(syncInterval, { min: 0, max: 86400 })) {
  throw new ConfigError('Invalid sync interval', ErrorCodes.CONFIG_INVALID_VALUE);
}
```

## Secret Storage 使用

### 存储敏感信息

**使用 VSCode Secret Storage API：**

```typescript
class SecretManager {
  constructor(private context: vscode.ExtensionContext) {}

  async storeToken(sourceId: string, token: string): Promise<void> {
    const key = `extension.token.${sourceId}`;
    await this.context.secrets.store(key, token);
    Logger.info('Token stored', { sourceId }); // 不记录 token
  }

  async getToken(sourceId: string): Promise<string | undefined> {
    const key = `extension.token.${sourceId}`;
    return await this.context.secrets.get(key);
  }

  async deleteToken(sourceId: string): Promise<void> {
    const key = `extension.token.${sourceId}`;
    await this.context.secrets.delete(key);
    Logger.info('Token deleted', { sourceId });
  }
}
```

**使用示例：**

```typescript
// 存储
const token = await vscode.window.showInputBox({
  prompt: 'Enter your GitHub token',
  password: true, // 隐藏输入
  ignoreFocusOut: true,
});

if (token) {
  await secretManager.storeToken(sourceId, token);
}

// 读取
const token = await secretManager.getToken(sourceId);
if (!token) {
  vscode.window.showErrorMessage('Token not found');
  return;
}

// 使用 token（不记录到日志）
await gitManager.authenticate(token);
```

### 禁止的敏感信息存储方式

**❌ 禁止存储在配置文件：**

```typescript
// ❌ 禁止
{
  "extension.token": "ghp_xxxxxxxxxxxx"  // 明文存储
}
```

**❌ 禁止存储在代码中：**

```typescript
// ❌ 禁止
const API_KEY = 'sk-xxxxxxxxxxxx'; // 硬编码
```

**❌ 禁止存储在日志中：**

```typescript
// ❌ 禁止
Logger.info('Authenticating', { token }); // 泄露敏感信息
```

## 文件操作安全

### 原子文件写入

**防止部分写入和数据损坏：**

```typescript
async function atomicWriteFile(filePath: string, content: string): Promise<void> {
  const tempPath = `${filePath}.tmp.${Date.now()}`;

  try {
    // 1. 写入临时文件
    await fs.writeFile(tempPath, content, 'utf-8');

    // 2. 验证写入成功
    const written = await fs.readFile(tempPath, 'utf-8');
    if (written !== content) {
      throw new Error('File verification failed');
    }

    // 3. 原子重命名
    await fs.rename(tempPath, filePath);

    Logger.info('File written successfully', { filePath });
  } catch (error) {
    // 清理临时文件
    await fs.remove(tempPath).catch(() => {});

    Logger.error('Atomic write failed', error as Error, { filePath });
    throw new FileError('Failed to write file', ErrorCodes.FILE_WRITE_FAILED, error as Error);
  }
}
```

### 安全文件读取

**防止路径注入：**

```typescript
async function safeReadFile(filePath: string): Promise<string> {
  // 1. 验证路径
  const { valid, normalized } = validatePath(filePath, workspaceRoot);
  if (!valid) {
    throw new SecurityError('Invalid file path', ErrorCodes.SECURITY_PATH_TRAVERSAL);
  }

  // 2. 检查文件存在
  if (!(await fs.pathExists(normalized))) {
    throw new FileError('File not found', ErrorCodes.FILE_NOT_FOUND);
  }

  // 3. 检查文件大小（防止读取超大文件）
  const stats = await fs.stat(normalized);
  const maxSize = 10 * 1024 * 1024; // 10MB
  if (stats.size > maxSize) {
    throw new FileError(`File too large: ${stats.size} bytes`, ErrorCodes.FILE_TOO_LARGE);
  }

  // 4. 读取文件
  return await fs.readFile(normalized, 'utf-8');
}
```

### 文件权限检查

**在写入前检查权限：**

```typescript
async function checkWritePermission(dirPath: string): Promise<boolean> {
  try {
    const testFile = path.join(dirPath, `.write-test-${Date.now()}`);
    await fs.writeFile(testFile, 'test');
    await fs.remove(testFile);
    return true;
  } catch {
    return false;
  }
}

// 使用示例
if (!(await checkWritePermission(outputDir))) {
  throw new FileError('No write permission', ErrorCodes.FILE_PERMISSION_DENIED);
}
```

## 网络安全

### HTTPS 优先

**强制使用 HTTPS：**

```typescript
function ensureHttps(url: string): string {
  if (url.startsWith('http://')) {
    Logger.warn('Converting HTTP to HTTPS', { url });
    return url.replace('http://', 'https://');
  }
  return url;
}
```

### 请求超时

**防止长时间等待：**

```typescript
async function fetchWithTimeout(url: string, timeout = 30000): Promise<Response> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeout);

  try {
    const response = await fetch(url, {
      signal: controller.signal,
      headers: {
        'User-Agent': 'VSCode-Extension/1.0.0',
      },
    });
    return response;
  } finally {
    clearTimeout(timeoutId);
  }
}
```

### 证书验证

**不要禁用证书验证：**

```typescript
// ❌ 禁止
const response = await fetch(url, {
  agent: new https.Agent({
    rejectUnauthorized: false, // 危险！
  }),
});

// ✅ 使用系统证书
const response = await fetch(url); // 默认验证证书
```

## 代码注入防护

### 命令执行安全

**使用参数化命令：**

```typescript
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

// ❌ 禁止：字符串拼接
async function dangerousGitClone(url: string): Promise<void> {
  await execAsync(`git clone ${url}`); // 注入风险！
}

// ✅ 推荐：使用库（如 simple-git）
import simpleGit from 'simple-git';

async function safeGitClone(url: string, dir: string): Promise<void> {
  const git = simpleGit();
  await git.clone(url, dir); // 安全
}
```

**如果必须使用 exec，验证输入：**

```typescript
async function safeExec(command: string, args: string[]): Promise<void> {
  // 白名单验证命令
  const allowedCommands = ['git', 'npm', 'node'];
  if (!allowedCommands.includes(command)) {
    throw new SecurityError('Command not allowed', ErrorCodes.SECURITY_FORBIDDEN);
  }

  // 验证参数（移除特殊字符）
  const safeArgs = args.map(
    (arg) => arg.replace(/[;&|`$()]/g, ''), // 移除危险字符
  );

  const cmd = [command, ...safeArgs].join(' ');
  await execAsync(cmd);
}
```

### SQL 注入防护

**如果使用数据库，使用参数化查询：**

```typescript
// ❌ 禁止：字符串拼接
const query = `SELECT * FROM rules WHERE id = '${userId}'`; // SQL 注入！

// ✅ 推荐：参数化查询
const query = 'SELECT * FROM rules WHERE id = ?';
const result = await db.query(query, [userId]);
```

## 输出编码

### HTML 输出编码

**防止 XSS 攻击：**

```typescript
function escapeHtml(text: string): string {
  const map: Record<string, string> = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;',
  };
  return text.replace(/[&<>"']/g, (char) => map[char]);
}

// 使用示例
const html = `<div>${escapeHtml(userInput)}</div>`;
```

### Markdown 输出安全

**清理用户生成的 Markdown：**

```typescript
import sanitizeHtml from 'sanitize-html';

function sanitizeMarkdown(markdown: string): string {
  return sanitizeHtml(markdown, {
    allowedTags: ['b', 'i', 'em', 'strong', 'a', 'code', 'pre'],
    allowedAttributes: {
      a: ['href'],
    },
    allowedSchemes: ['http', 'https', 'mailto'],
  });
}
```

## 依赖安全

### 定期更新依赖

**使用 npm audit：**

```bash
# 检查漏洞
npm audit

# 自动修复
npm audit fix

# 查看详情
npm audit --json
```

**在 CI/CD 中集成：**

```yaml
# .github/workflows/security.yml
name: Security Check
on: [push, pull_request]
jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm audit --audit-level=moderate
```

### 最小依赖原则

**只安装必要的依赖：**

```json
{
  "dependencies": {
    // 只包含运行时必需的依赖
    "simple-git": "^3.0.0"
  },
  "devDependencies": {
    // 开发时依赖
    "@types/node": "^18.0.0",
    "typescript": "^5.0.0"
  }
}
```

**审查第三方依赖：**

- 检查下载量和维护状态
- 阅读源代码（如果可能）
- 查看 GitHub Issues 和安全公告
- 使用知名库优于小众库

## 权限最小化

### 请求必要的权限

**package.json 中声明最小权限：**

```json
{
  "contributes": {
    "configuration": {
      "properties": {
        "extension.enableTelemetry": {
          "type": "boolean",
          "default": false,
          "description": "Enable telemetry collection"
        }
      }
    }
  }
}
```

### 文件访问限制

**只访问必要的文件：**

```typescript
// ✅ 限制在工作区内
const configPath = path.join(workspaceRoot, '.vscode', 'settings.json');

// ❌ 避免访问系统文件
const systemPath = '/etc/passwd'; // 危险！
```

## 安全检查清单

### 开发阶段

- [ ] 所有用户输入已验证
- [ ] URL 格式正确且安全
- [ ] 路径已规范化并限制在允许范围
- [ ] 分支名和配置值已验证
- [ ] 敏感信息存储在 Secret Storage
- [ ] 文件操作使用原子写入
- [ ] 网络请求使用 HTTPS
- [ ] 命令执行使用安全的库
- [ ] 输出已正确编码

### 测试阶段

- [ ] 尝试目录遍历攻击
- [ ] 测试特殊字符和边界值
- [ ] 验证错误处理不泄露信息
- [ ] 检查日志不包含敏感数据
- [ ] 测试并发和竞态条件

### 发布前

- [ ] 运行 `npm audit`
- [ ] 审查所有依赖
- [ ] 代码中无硬编码密钥
- [ ] 文档说明安全最佳实践
- [ ] 更新 CHANGELOG 中的安全修复

## 常见安全漏洞

### 1. 路径遍历

**漏洞示例：**

```typescript
// ❌ 危险
const filePath = path.join(baseDir, userInput); // userInput = '../../../etc/passwd'
const content = await fs.readFile(filePath);
```

**修复：**

```typescript
// ✅ 安全
const { valid, normalized } = validatePath(userInput, baseDir);
if (!valid) throw new SecurityError('Invalid path');
const content = await fs.readFile(normalized);
```

### 2. 命令注入

**漏洞示例：**

```typescript
// ❌ 危险
await exec(`git clone ${url}`); // url = 'repo.git; rm -rf /'
```

**修复：**

```typescript
// ✅ 安全
const git = simpleGit();
await git.clone(url, dir);
```

### 3. 敏感信息泄露

**漏洞示例：**

```typescript
// ❌ 危险
Logger.info('Auth token', { token });
console.log('Password:', password);
```

**修复：**

```typescript
// ✅ 安全
Logger.info('Authenticated', { userId }); // 不记录 token
// 移除所有 console.log
```

### 4. 未验证的重定向

**漏洞示例：**

```typescript
// ❌ 危险
const redirectUrl = query.get('redirect');
vscode.env.openExternal(vscode.Uri.parse(redirectUrl)); // 任意 URL
```

**修复：**

```typescript
// ✅ 安全
const redirectUrl = query.get('redirect');
if (redirectUrl && validateHttpUrl(redirectUrl)) {
  const parsed = new URL(redirectUrl);
  if (allowedDomains.includes(parsed.hostname)) {
    vscode.env.openExternal(vscode.Uri.parse(redirectUrl));
  }
}
```

## 安全资源

### 学习资源

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [VSCode Extension Security](https://code.visualstudio.com/api/references/extension-guidelines#security)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)

### 工具

- `npm audit` - 依赖漏洞扫描
- `eslint-plugin-security` - ESLint 安全插件
- `snyk` - 第三方安全扫描
- `retire.js` - 检测过时的库

### 报告安全问题

如果发现安全漏洞：

1. **不要公开披露**
2. 通过私密渠道联系维护者
3. 提供详细的复现步骤
4. 等待修复后再公开
