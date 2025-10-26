---
id: vscode-extension-testing
title: VSCode 扩展测试规范
priority: high
tags: [vscode, testing, vitest, mocha, coverage]
version: 1.0.0
author: Turbo AI Rules
description: VSCode 扩展开发的测试策略和最佳实践
---

# VSCode 扩展测试规范

## 测试策略

### 测试金字塔

```
        /\
       /E2E\       端到端测试（少量）
      /------\
     /Integration\ 集成测试（适量）
    /------------\
   /  Unit Tests  \ 单元测试（大量）
  /----------------\
```

**测试比例建议：**

- 单元测试：70%
- 集成测试：20%
- 端到端测试：10%

### 测试分层

**单元测试（Vitest）**

- 测试独立的函数和类
- Mock 外部依赖
- 快速执行（< 1 秒）
- 高覆盖率目标（80%+）

**集成测试（Mocha）**

- 测试模块间协作
- 使用真实 VSCode API
- 测试完整工作流
- 中等执行时间（< 30 秒）

**端到端测试**

- 测试用户场景
- 真实扩展环境
- 较慢执行（可接受）

## 单元测试（Vitest）

### 测试文件组织

**推荐目录结构：**

```
src/
├── services/
│   └── GitManager.ts
├── parsers/
│   └── MdcParser.ts
└── test/
    └── unit/
        ├── services/
        │   └── GitManager.spec.ts
        └── parsers/
            └── MdcParser.spec.ts
```

### Vitest 配置

**vite.config.ts 配置：**

```typescript
import { defineConfig } from 'vite';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html', 'lcov'],
      exclude: ['node_modules/', 'src/test/', '**/*.spec.ts', '**/*.d.ts'],
      thresholds: {
        lines: 80,
        functions: 80,
        branches: 80,
        statements: 80,
      },
    },
  },
});
```

### 基础测试示例

**测试纯函数：**

```typescript
import { describe, it, expect } from 'vitest';
import { validateGitUrl } from '../utils/validator';

describe('validateGitUrl', () => {
  it('should validate HTTPS Git URLs', () => {
    expect(validateGitUrl('https://github.com/user/repo.git')).toBe(true);
    expect(validateGitUrl('https://gitlab.com/user/repo.git')).toBe(true);
  });

  it('should validate SSH Git URLs', () => {
    expect(validateGitUrl('git@github.com:user/repo.git')).toBe(true);
  });

  it('should reject invalid URLs', () => {
    expect(validateGitUrl('not-a-url')).toBe(false);
    expect(validateGitUrl('http://example.com')).toBe(false);
    expect(validateGitUrl('')).toBe(false);
  });
});
```

**测试异步函数：**

```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { parseFile } from '../parsers/MdcParser';

describe('parseFile', () => {
  it('should parse valid MDC file', async () => {
    const result = await parseFile('test.md');

    expect(result).toHaveProperty('id');
    expect(result).toHaveProperty('title');
    expect(result.content).toBeDefined();
  });

  it('should throw error for invalid file', async () => {
    await expect(parseFile('invalid.md')).rejects.toThrow('Parse error');
  });
});
```

### Mock 技巧

**Mock 外部模块：**

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest';
import * as fs from 'fs-extra';

// Mock fs-extra 模块
vi.mock('fs-extra', () => ({
  readFile: vi.fn(),
  writeFile: vi.fn(),
  pathExists: vi.fn(),
}));

describe('ConfigManager', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should load config from file', async () => {
    // 设置 Mock 返回值
    vi.mocked(fs.pathExists).mockResolvedValue(true);
    vi.mocked(fs.readFile).mockResolvedValue('{"key": "value"}');

    const config = await loadConfig('config.json');

    expect(config).toEqual({ key: 'value' });
    expect(fs.readFile).toHaveBeenCalledWith('config.json', 'utf-8');
  });

  it('should handle file not found', async () => {
    vi.mocked(fs.pathExists).mockResolvedValue(false);

    await expect(loadConfig('missing.json')).rejects.toThrow('Config not found');
  });
});
```

**Mock VSCode API：**

```typescript
import { describe, it, expect, vi } from 'vitest';

// Mock vscode 模块
vi.mock('vscode', () => ({
  window: {
    showInformationMessage: vi.fn(),
    showErrorMessage: vi.fn(),
    showWarningMessage: vi.fn(),
  },
  workspace: {
    getConfiguration: vi.fn(() => ({
      get: vi.fn((key: string, defaultValue: unknown) => defaultValue),
    })),
  },
}));

describe('showMessage', () => {
  it('should show success message', () => {
    const vscode = await import('vscode');

    showSuccessMessage('Operation completed');

    expect(vscode.window.showInformationMessage).toHaveBeenCalledWith('Operation completed');
  });
});
```

**Spy 监听函数调用：**

```typescript
import { describe, it, expect, vi } from 'vitest';

describe('EventEmitter', () => {
  it('should notify listeners', () => {
    const listener = vi.fn();
    const emitter = new EventEmitter();

    emitter.on('change', listener);
    emitter.emit('change', { data: 'test' });

    expect(listener).toHaveBeenCalledTimes(1);
    expect(listener).toHaveBeenCalledWith({ data: 'test' });
  });
});
```

### 测试覆盖率

**必须测试的模块：**

- 核心业务逻辑（Service 层）
- 数据解析和验证
- 工具函数
- 错误处理逻辑

**可以跳过的测试：**

- 简单的 getter/setter
- 纯粹的类型定义
- 第三方库的封装（如果很薄）

**运行测试覆盖率：**

```bash
# 生成覆盖率报告
npm run test:coverage

# 查看 HTML 报告
open coverage/index.html
```

## 集成测试（Mocha）

### 测试环境设置

**测试文件组织：**

```
src/test/
├── suite/
│   ├── extension.test.ts      # 扩展激活测试
│   ├── commands.test.ts       # 命令测试
│   └── integration.test.ts    # 端到端测试
└── runTests.ts                # 测试运行器
```

### Mocha 配置

**.mocharc.json 配置：**

```json
{
  "require": ["ts-node/register"],
  "extensions": ["ts"],
  "spec": "src/test/suite/**/*.test.ts",
  "timeout": 20000,
  "color": true,
  "reporter": "spec"
}
```

### VSCode 测试环境

**测试运行器（runTests.ts）：**

```typescript
import * as path from 'path';
import { runTests } from '@vscode/test-electron';

async function main() {
  try {
    const extensionDevelopmentPath = path.resolve(__dirname, '../../');
    const extensionTestsPath = path.resolve(__dirname, './suite/index');

    await runTests({
      extensionDevelopmentPath,
      extensionTestsPath,
      launchArgs: ['--disable-extensions'], // 禁用其他扩展
    });
  } catch (err) {
    console.error('Failed to run tests');
    process.exit(1);
  }
}

main();
```

### 扩展激活测试

**测试扩展激活：**

```typescript
import * as assert from 'assert';
import * as vscode from 'vscode';

suite('Extension Activation', () => {
  test('should activate successfully', async () => {
    const ext = vscode.extensions.getExtension('publisher.extension-name');
    assert.ok(ext);

    await ext.activate();
    assert.strictEqual(ext.isActive, true);
  });

  test('should register commands', async () => {
    const commands = await vscode.commands.getCommands(true);

    assert.ok(commands.includes('extension.command1'));
    assert.ok(commands.includes('extension.command2'));
  });
});
```

### 命令测试

**测试命令执行：**

```typescript
suite('Commands', () => {
  test('should execute addSource command', async () => {
    const result = await vscode.commands.executeCommand('extension.addSource', {
      url: 'https://github.com/user/repo.git',
      branch: 'main',
    });

    assert.ok(result);
  });

  test('should show error for invalid input', async () => {
    await assert.rejects(
      vscode.commands.executeCommand('extension.addSource', {}),
      /Invalid input/,
    );
  });
});
```

### 工作区测试

**测试文件操作：**

```typescript
import * as path from 'path';
import * as fs from 'fs-extra';

suite('File Operations', () => {
  const testWorkspace = path.join(__dirname, '../../../test-workspace');

  suiteSetup(async () => {
    // 创建测试工作区
    await fs.ensureDir(testWorkspace);

    // 打开工作区
    const uri = vscode.Uri.file(testWorkspace);
    await vscode.commands.executeCommand('vscode.openFolder', uri);
  });

  suiteTeardown(async () => {
    // 清理测试工作区
    await fs.remove(testWorkspace);
  });

  test('should create config file', async () => {
    await vscode.commands.executeCommand('extension.createConfig');

    const configPath = path.join(testWorkspace, '.vscode', 'settings.json');
    const exists = await fs.pathExists(configPath);

    assert.strictEqual(exists, true);
  });
});
```

## 测试最佳实践

### AAA 模式

**Arrange-Act-Assert（准备-执行-断言）：**

```typescript
test('should parse rule with frontmatter', async () => {
  // Arrange: 准备测试数据
  const filePath = 'test-rule.md';
  const expectedId = 'test-rule';
  const expectedTitle = 'Test Rule';

  // Act: 执行被测试的代码
  const result = await parseFile(filePath);

  // Assert: 验证结果
  expect(result.id).toBe(expectedId);
  expect(result.title).toBe(expectedTitle);
});
```

### 测试独立性

**每个测试相互独立：**

```typescript
describe('RulesManager', () => {
  let manager: RulesManager;

  beforeEach(() => {
    // 每个测试前重新创建
    manager = new RulesManager();
  });

  afterEach(() => {
    // 每个测试后清理
    manager.clear();
  });

  test('test 1', () => {
    manager.addRule(rule1);
    expect(manager.count()).toBe(1);
  });

  test('test 2', () => {
    // 独立的状态，不受 test 1 影响
    expect(manager.count()).toBe(0);
  });
});
```

### 测试边界情况

**测试各种边界条件：**

```typescript
describe('validateConfig', () => {
  test('should accept valid config', () => {
    expect(validateConfig({ interval: 60 })).toBe(true);
  });

  test('should reject negative interval', () => {
    expect(validateConfig({ interval: -1 })).toBe(false);
  });

  test('should reject interval = 0', () => {
    expect(validateConfig({ interval: 0 })).toBe(false);
  });

  test('should reject too large interval', () => {
    expect(validateConfig({ interval: 999999 })).toBe(false);
  });

  test('should handle null', () => {
    expect(validateConfig(null)).toBe(false);
  });

  test('should handle undefined', () => {
    expect(validateConfig(undefined)).toBe(false);
  });

  test('should handle empty object', () => {
    expect(validateConfig({})).toBe(false);
  });
});
```

### 描述性测试名称

**使用清晰的测试名称：**

```typescript
// ✅ 好的测试名称
test('should throw ParseError when frontmatter is missing');
test('should return empty array when no rules found');
test('should merge rules from multiple sources by priority');

// ❌ 不好的测试名称
test('test 1');
test('parse');
test('it works');
```

### 参数化测试

**测试多组输入：**

```typescript
describe('validateGitUrl', () => {
  const validUrls = [
    'https://github.com/user/repo.git',
    'https://gitlab.com/user/repo.git',
    'git@github.com:user/repo.git',
  ];

  validUrls.forEach((url) => {
    test(`should validate ${url}`, () => {
      expect(validateGitUrl(url)).toBe(true);
    });
  });

  const invalidUrls = ['', 'not-a-url', 'http://example.com', 'ftp://server.com/repo.git'];

  invalidUrls.forEach((url) => {
    test(`should reject ${url}`, () => {
      expect(validateGitUrl(url)).toBe(false);
    });
  });
});
```

## 持续集成

### GitHub Actions 配置

**.github/workflows/test.yml：**

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [18.x, 20.x]

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}

      - name: Install dependencies
        run: npm ci

      - name: Run lint
        run: npm run lint

      - name: Run unit tests
        run: npm run test

      - name: Run integration tests
        run: npm run test:integration

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
```

### 测试脚本

**package.json 脚本：**

```json
{
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "test:integration": "node ./out/test/runTests.js",
    "test:all": "npm run test && npm run test:integration"
  }
}
```

## 测试检查清单

### 单元测试检查

- [ ] 核心逻辑有测试覆盖
- [ ] 边界情况已测试
- [ ] 错误情况已测试
- [ ] Mock 使用正确
- [ ] 测试相互独立
- [ ] 测试名称清晰
- [ ] 覆盖率达到 80%+

### 集成测试检查

- [ ] 命令可以执行
- [ ] 配置可以读取和更新
- [ ] 文件操作正常
- [ ] UI 交互正常
- [ ] 端到端流程通畅

### CI/CD 检查

- [ ] 多平台测试（Linux/Windows/macOS）
- [ ] 多 Node 版本测试
- [ ] 自动运行测试
- [ ] 覆盖率报告上传
- [ ] 测试失败阻止合并

## 测试维护

### 定期审查测试

- 移除过时的测试
- 更新失效的 Mock
- 重构重复的测试代码
- 提高测试覆盖率

### 测试文档

- 说明复杂测试的目的
- 记录测试环境要求
- 提供测试运行指南

### 性能考虑

- 避免慢测试（设置超时）
- 使用并行测试
- Mock 慢速操作（网络、文件）
- 定期清理测试数据
