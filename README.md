# AI Rules 规则库

> 全面的 IT 开发规则和最佳实践集合，涵盖从底层编程语言到上层项目管理的各个方面。

---

## 📚 目录结构

本规则库采用**从底层到上层**的编号体系，确保规则的逻辑性和可扩展性。

### 🎯 核心分类

```
rules/
├── 001-general-standards/        # 通用标准和规范
├── 100-programming-languages/    # 编程语言
├── 200-frameworks/               # 框架和库
│   ├── 201-219: 前端框架 (React, Next.js, Vue, Astro)
│   ├── 220-239: UI/CSS 框架 (Tailwind, Chakra UI)
│   ├── 240-249: 状态管理 (Redux, Zustand, Pinia)
│   ├── 250-259: 构建工具 (Vite, Webpack)
│   ├── 260-269: IDE/编辑器扩展
│   └── 270-289: 组合规则 (多技术栈)
├── 300-databases/                # 数据库
├── 500-api-design/               # API 设计
├── 600-testing/                  # 测试
├── 700-security/                 # 安全
├── 800-devops-cicd/              # DevOps & CI/CD
├── 900-architecture-design/      # 架构设计
├── 1000-ui-ux-design/            # UI/UX 设计
├── 1100-project-management/      # 项目管理
└── 1200-documentation/           # 文档编写
```

---

## 📖 详细说明

### [001. 通用标准和规范](./001-general-standards/)

**包含内容：**

- 代码风格指南
- 命名规范
- Git 提交规范
- 代码审查标准
- 通用最佳实践

**适用场景：**

- 所有项目的基础规范
- 团队协作标准
- 代码质量基准

**编号范围：** 001-099

---

### [100. 编程语言](./100-programming-languages/)

**包含内容：**

- [101. Python 最佳实践](./100-programming-languages/101-python.mdc)
- [102. TypeScript 最佳实践](./100-programming-languages/102-typescript.mdc)
- 更多语言规范待添加...

**适用场景：**

- 特定语言项目开发
- 语言特性学习
- 代码规范制定

**编号规则：**

- 101-109: 解释型语言（Python, Ruby, PHP 等）
- 110-119: 编译型语言（Java, C++, Go 等）
- 120-129: 脚本语言（JavaScript, Shell 等）
- 130-139: 函数式语言（Haskell, Elixir 等）

---

### [200. 开发框架](./200-frameworks/)

**包含内容：**

- [201. React 最佳实践](./200-frameworks/201-react.mdc)
- [202. Next.js 最佳实践](./200-frameworks/202-nextjs.mdc)
- [203. Vue 最佳实践](./200-frameworks/203-vue.mdc)
- [204. Tailwind CSS 最佳实践](./200-frameworks/204-tailwind.mdc)
- [VSCode 扩展开发](./200-frameworks/vscode-extension/) - 完整规范集

**适用场景：**

- Web 应用开发
- 移动应用开发
- 桌面应用开发
- 特定框架项目

**编号规则：**

- 201-210: React 生态（React, Next.js, Remix）
- 211-220: Vue 生态（Vue, Nuxt, Vite）
- 221-230: Angular 生态
- 231-240: 后端框架（Django, Flask, Spring, Express）
- 241-250: UI/CSS 框架（Tailwind, Bootstrap, Material-UI）
- 251-260: 状态管理（Redux, Zustand, Pinia）
- 261-270: 移动开发（React Native, Flutter）
- 271-280: 桌面开发（Electron, Tauri）
- 特定框架子目录（如 vscode-extension）

---

### [300. 数据库](./300-databases/)

**包含内容：**（待添加）

- 关系型数据库（PostgreSQL, MySQL）
- NoSQL 数据库（MongoDB, Redis）
- ORM 使用规范（Prisma, SQLAlchemy）
- 数据库设计模式
- 查询优化

**适用场景：**

- 数据库设计
- 性能优化
- 数据迁移
- 备份恢复

**编号范围：** 300-399

---

### [500. API 设计](./500-api-design/)

**包含内容：**（待添加）

- RESTful API 设计
- GraphQL 设计
- API 版本控制
- API 文档规范
- API 安全

**适用场景：**

- API 接口设计
- 微服务通信
- 第三方集成

**编号范围：** 500-599

---

### [600. 测试](./600-testing/)

**包含内容：**（待添加）

- 单元测试
- 集成测试
- E2E 测试
- 性能测试
- 测试覆盖率

**适用场景：**

- 测试策略制定
- 质量保证
- CI/CD 集成

**编号范围：** 600-699

---

### [700. 安全](./700-security/)

**包含内容：**（待添加）

- 身份认证
- 授权机制
- 数据加密
- 安全漏洞防护
- OWASP Top 10

**适用场景：**

- 安全审计
- 漏洞修复
- 安全合规

**编号范围：** 700-799

---

### [800. DevOps & CI/CD](./800-devops-cicd/)

**包含内容：**（待添加）

- Docker 容器化
- Kubernetes 编排
- CI/CD 流程
- 监控告警
- 日志管理

**适用场景：**

- 自动化部署
- 环境管理
- 运维优化

**编号范围：** 800-899

---

### [900. 架构设计](./900-architecture-design/)

**包含内容：**（待添加）

- 微服务架构
- 事件驱动架构
- 领域驱动设计（DDD）
- 设计模式
- 系统设计

**适用场景：**

- 系统架构设计
- 技术选型
- 架构重构

**编号范围：** 900-999

---

### [1000. UI/UX 设计](./1000-ui-ux-design/)

**包含内容：**（待添加）

- 用户界面设计规范
- 用户体验原则
- 无障碍访问
- 响应式设计
- 设计系统

**适用场景：**

- 界面设计
- 交互设计
- 用户研究

**编号范围：** 1000-1099

---

### [1100. 项目管理](./1100-project-management/)

**包含内容：**（待添加）

- 敏捷开发
- Scrum/Kanban
- 需求管理
- 风险管理
- 团队协作

**适用场景：**

- 项目规划
- 团队管理
- 进度跟踪

**编号范围：** 1100-1199

---

### [1200. 文档编写](./1200-documentation/)

**包含内容：**（待添加）

- 技术文档规范
- API 文档
- 用户手册
- 架构文档
- README 模板

**适用场景：**

- 文档编写
- 知识管理
- 团队沟通

**编号范围：** 1200-1299

---

## 🎯 使用指南

### 快速开始

1. **选择项目类型**：确定您的项目主要技术栈
2. **从底层开始**：先查看编程语言和框架规范
3. **补充专项规范**：根据需要查看测试、安全等专项规范
4. **整合应用**：将多个规范整合到项目中

### 按项目类型选择

**Web 全栈项目（Next.js + TypeScript）：**

```
100-programming-languages/102-typescript.mdc
200-frameworks/202-nextjs.mdc
200-frameworks/201-react.mdc
200-frameworks/204-tailwind.mdc
300-databases/（选择数据库规范）
600-testing/（测试规范）
700-security/（安全规范）
```

**Python Web 应用（Flask）：**

```
100-programming-languages/101-python.mdc
200-frameworks/（Flask 规范）
300-databases/（数据库规范）
500-api-design/（API 设计）
600-testing/（测试规范）
```

**VSCode 扩展开发：**

```
100-programming-languages/102-typescript.mdc
200-frameworks/vscode-extension/（完整规范集）
600-testing/（测试规范）
```

---

## 📝 规则文件格式

所有规则文件采用 **MDC（Markdown with Frontmatter）** 格式：

```markdown
---
description: 规则描述
globs: 适用的文件模式
priority: high/medium/low（可选）
tags: [标签1, 标签2]（可选）
---

# 规则标题

## 核心内容

规则的详细说明...
```

---

## 🔄 维护指南

### 添加新规则

1. **确定分类**：根据规则性质选择合适的目录
2. **选择编号**：在对应目录的编号范围内选择下一个可用编号
3. **创建文件**：使用 `.mdc` 格式，包含完整的 frontmatter
4. **更新索引**：在对应目录的 `index.md` 中添加链接
5. **更新主 README**：如果是新分类，更新本文件

### 编号规则

- **固定位数**：使用三位数编号（如 101, 201）
- **预留空间**：每个大类预留 100 个编号
- **子分类**：在大类内使用连续编号进行子分类
- **特殊项目**：特定技术栈可使用子目录（如 vscode-extension）

### 目录命名规范

- **格式**：`编号-名称`（如 `100-programming-languages`）
- **编号**：三位或四位数字
- **名称**：小写字母，单词间用连字符 `-` 连接
- **语言**：使用英文名称，便于国际化

---

## 🌟 最佳实践

1. **从通用到特定**：先应用通用规范，再应用特定技术规范
2. **规则组合**：根据项目需要组合多个规则
3. **持续更新**：规则应随技术发展持续更新
4. **团队共识**：团队应就规则应用达成共识
5. **工具集成**：将规则集成到 IDE、CI/CD 等工具中

---

## 📚 参考资源

- [MDC 格式规范](../docs/user-guide/03-rule-format.zh.md)
- [贡献指南](../CONTRIBUTING.md)
- [项目文档](../docs/)

---

## 📄 许可证

本规则库遵循项目主许可证。详见 [LICENSE](../LICENSE) 文件。

---

**最后更新：** 2025-10-26  
**维护者：** Turbo AI Rules
