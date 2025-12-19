# 编程语言规范

本目录包含主流编程语言的最佳实践和编码规范。

## 📋 规则列表

### [101. Python 最佳实践](./101-python.mdc)

**适用场景：**

- Python 3.12+ 项目开发
- Flask Web 应用
- SQLAlchemy 数据库操作
- Google OAuth 身份验证

**核心内容：**

- 项目结构（src-layout）
- 代码风格（Black, isort, PEP 8）
- 类型提示（Type Hints）
- Flask 应用模式（工厂模式、蓝图）
- 数据库操作（SQLAlchemy, Alembic）
- 认证与安全（Flask-Login, OAuth）
- API 设计（Flask-RESTful）
- 测试（pytest）
- 性能优化（缓存、连接池）

---

### [102. TypeScript 最佳实践](./102-typescript.mdc)

**适用场景：**

- TypeScript 项目开发
- 现代 Web 应用
- 类型安全的代码库
- React/Vue/Angular 应用

**核心内容：**

- 类型系统（interfaces, types, generics）
- 命名规范（PascalCase, camelCase）
- 代码组织（barrel exports, type files）
- 函数设计（显式返回类型、async/await）
- 最佳实践（strict mode, readonly, type guards）
- 错误处理（自定义错误类型、Result types）
- 设计模式（Builder, Repository, Factory, DI）

---

### [105. Shell 脚本最佳实践](./105-shell.mdc)

**适用场景：**

- Bash/Shell 脚本开发
- 自动化运维脚本
- CI/CD 流程脚本
- 系统初始化和配置脚本

**核心内容：**

- 命名规范（全局变量大写、局部变量小写、函数首字母大写）
- 模块化设计（函数优先、多文件组织）
- 脚本结构（Main 函数入口、严格模式）
- 错误处理（trap、退出清理）
- 最佳实践（参数解析、路径处理、并行处理）
- 工具配置（ShellCheck, shfmt）

---

## 🎯 使用指南

### 按开发阶段选择

**项目初始化：**

1. 选择主要编程语言规范（Python 或 TypeScript）
2. 配置开发环境和工具链
3. 设置代码格式化和 linting 规则

**日常开发：**

1. 遵循语言特定的命名规范
2. 使用推荐的项目结构
3. 编写类型安全的代码
4. 实施适当的错误处理

**代码审查：**

1. 检查代码风格一致性
2. 验证类型定义正确性
3. 审查错误处理逻辑
4. 确保遵循最佳实践

---

## 📚 扩展阅读

- [Python 官方文档](https://docs.python.org/)
- [TypeScript 官方文档](https://www.typescriptlang.org/docs/)
- [PEP 8 - Python 代码风格指南](https://peps.python.org/pep-0008/)
- [Google Python 风格指南](https://google.github.io/styleguide/pyguide.html)

---

## 🔄 维护说明

**添加新语言规范：**

1. 使用三位数编号（10x 系列）
2. 创建 `.mdc` 文件，包含完整的 frontmatter
3. 包含：项目结构、代码风格、最佳实践、常见模式
4. 更新本 index.md 文件

**编号规则：**

- 101-109: 解释型语言（Python, Ruby, PHP 等）
- 110-119: 编译型语言（Java, C++, Go 等）
- 120-129: 脚本语言（JavaScript, Shell 等）
- 130-139: 函数式语言（Haskell, Elixir 等）
