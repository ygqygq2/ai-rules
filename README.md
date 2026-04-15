# AI Rules 规则库

> 全面的 IT 开发规则和最佳实践集合，涵盖从底层编程语言到上层项目管理的各个方面。

---

## 📚 目录结构

本规则库采用**顶层按资产类型划分、类型内部独立编号**的结构：

- 顶层目录用于明确资产语义：`rules/`、`skills/`、`agents/`、`prompts/`、`commands/`、`hooks/`、`mcp/`
- `rules/` 内继续保留按领域组织的编号目录
- 其他类型目录各自维护独立编号空间，不再与 `rules/` 混用序号

### 为什么要这样设计？

随着仓库里的 AI 资产越来越多，单纯按编号范围或按技术主题平铺，已经不足以回答一个最基础的问题：**“这到底是什么资产，它会被谁消费？”**

之所以改成“顶层按资产类型划分”，核心是为了解决下面几个实际问题：

1. **先区分语义，再区分主题**  
	`rule`、`skill`、`agent`、`prompt`、`command`、`hook`、`mcp` 虽然很多都长得像 Markdown 或 JSON，但它们的用途完全不同。比如：
	- `rules/*.mdc` 是给 AI 工具当编码规则用的
	- `skills/` 是带流程入口的工作流能力
	- `prompts/*.prompt.md` 是提示模板
	- `hooks/*.json` 和 `mcp/*.json` 虽然同为 JSON，但一个是 hook 片段，一个是 MCP 配置

	如果顶层不先按类型分开，读者和工具都会先陷入“文件格式相同，但资产含义不同”的歧义里。

2. **让人一眼能看懂，也让同步工具一眼能判定**  
	这个仓库不是纯文档仓库，而是一个会被 `turbo-ai-rules` 等工具消费、解析、同步、生成的源仓库。  
	顶层目录直接表达资产类型后：
	- 人类维护者进入仓库时，能立刻知道应该去哪里找对应资产
	- 同步工具可以优先依据目录语义判断类型，降低误分类、写错目标目录、漏同步的风险

3. **避免所有资产被迫共享一套编号体系**  
	`rules/` 本来就有清晰的领域编号历史（如 100 语言、200 框架、600 测试），继续保留最有利于导航。  
	但 `skills`、`agents`、`prompts` 这些资产如果也硬塞进同一套大编号，会出现两个问题：
	- 序号本身不再表达类型
	- 新增资产时需要跨类型抢号，维护成本高

	所以现在的策略是：**顶层目录负责区分资产类型，类型内部的编号只负责该类型内的排序和导航。**

4. **支持同格式、多消费端的扩展场景**  
	后续仓库还会继续扩展新的资产类型或新的目标适配器。按类型分层后，即使未来再加入新的 JSON / YAML / Markdown 资产，也可以通过“所在目录 + 命名约定”稳定识别，而不是继续把判断逻辑堆在文件扩展名上。

5. **降低迁移和重构成本**  
	顶层类型边界稳定后：
	- 规则域可以继续按技术领域扩展，不影响 `skills/agents/prompts`
	- 某一类资产要整体迁移、重命名、批量生成时，范围边界天然清晰
	- 文档、脚本、同步工具都更容易做类型级别的过滤和校验

一句话总结：**这个目录设计不是为了把目录“分得更碎”，而是为了在资产类型变多之后，仍然保持可识别、可同步、可维护。**

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

skills/
├── 0001-python-development.mdc
├── 0002-typescript-development.mdc
├── ...
└── 0012-incident-response/

agents/
├── 0001-easydesign.agent.md
├── 0002-universal-plan.agent.md
└── 0003-universal-implementer.agent.md

prompts/
├── 0001-code-review.prompt.md
├── 0002-debug-assistant.prompt.md
└── 0003-refactor-advisor.prompt.md

commands/
├── 0001-git/
└── 0002-rules/

hooks/
├── 0001-settings-fragments/
└── 0002-scripts/

mcp/
└── 0001-servers/
```

---

## 📖 详细说明

### [001. 通用标准和规范](./rules/001-general-standards/)

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

### [100. 编程语言](./rules/100-programming-languages/)

**包含内容：**

- [101. Python 最佳实践](./rules/100-programming-languages/101-python.mdc)
- [102. TypeScript 最佳实践](./rules/100-programming-languages/102-typescript.mdc)
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

### [200. 开发框架](./rules/200-frameworks/)

**包含内容：**

- [201. React 最佳实践](./rules/200-frameworks/201-react.mdc)
- [202. Next.js 最佳实践](./rules/200-frameworks/202-nextjs.mdc)
- [203. Vue 最佳实践](./rules/200-frameworks/203-vue.mdc)
- [220. Tailwind CSS 最佳实践](./rules/200-frameworks/220-tailwind.mdc)
- [260. VSCode 扩展开发](./rules/200-frameworks/260-vscode-extension.mdc) - 完整规范集

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

### [300. 数据库](./rules/300-databases/)

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

### [500. API 设计](./rules/500-api-design/)

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

### [600. 测试](./rules/600-testing/)

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

### [700. 安全](./rules/700-security/)

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

### [800. DevOps & CI/CD](./rules/800-devops-cicd/)

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

### [900. 架构设计](./rules/900-architecture-design/)

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

### [1000. UI/UX 设计](./rules/1000-ui-ux-design/)

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

### [1100. 项目管理](./rules/1100-project-management/)

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

### [1200. 文档编写](./rules/1200-documentation/)

---

### [Skills 工作流资产](./skills/)

用于沉淀“如何做事”的流程化能力，如排障、代码审查、重构、任务规划、应急响应等。

- 文件与目录编号从 `0001` 开始，独立于 `rules/`
- 目录型 skill 使用 `SKILL.md` 作为入口

### [Agents 代理资产](./agents/)

存放 `*.agent.md` 文件，描述专业代理的职责、能力边界与 handoff 关系。

### [Prompts 提示模板](./prompts/)

存放 `*.prompt.md` 文件，供 AI 在特定任务中复用。

### [Commands 命令模板](./commands/)

存放面向命令式工作流的操作模板，如 `/commit`、`/review`、`/new-rule`。

### [Hooks 生命周期资产](./hooks/)

存放 hook 片段与脚本源文件，供工具按需合并到目标配置。

### [MCP 资产](./mcp/)

存放 MCP server JSON 片段，供工具合并生成最终的 MCP 配置。

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
rules/100-programming-languages/102-typescript.mdc
rules/200-frameworks/202-nextjs.mdc
rules/200-frameworks/201-react.mdc
rules/200-frameworks/220-tailwind.mdc
rules/300-databases/（选择数据库规范）
rules/600-testing/（测试规范）
rules/700-security/（安全规范）
```

**Python Web 应用（Flask）：**

```
rules/100-programming-languages/101-python.mdc
rules/200-frameworks/（Flask 规范）
rules/300-databases/（数据库规范）
rules/500-api-design/（API 设计）
rules/600-testing/（测试规范）
```

**VSCode 扩展开发：**

```
rules/100-programming-languages/102-typescript.mdc
rules/200-frameworks/260-vscode-extension.mdc
rules/600-testing/（测试规范）
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

### 新增资产时的判断顺序

新增内容时，先不要急着想编号，优先按下面顺序判断：

1. **它是什么资产类型？**
	- 编码规范、技术规范 → `rules/`
	- 多步骤工作流能力 → `skills/`
	- 专用代理定义 → `agents/`
	- 可复用提示模板 → `prompts/`
	- 命令模板 → `commands/`
	- hook 配置/脚本 → `hooks/`
	- MCP 配置片段 → `mcp/`
2. **它在该类型里属于哪个主题或子目录？**
3. **最后再决定该类型内部的编号。**

这个顺序非常重要：**先分类型，后分主题，最后编号**。这样才能保证仓库结构和工具识别逻辑始终一致。

### 添加新规则

1. **确定分类**：根据规则性质选择合适的目录
2. **选择编号**：在对应目录的编号范围内选择下一个可用编号
3. **创建文件**：使用 `.mdc` 格式，包含完整的 frontmatter
4. **更新索引**：在对应目录的 `README.md` 中添加链接
5. **更新主 README**：如果是新分类，更新本文件

### 编号规则

- **`rules/`**：继续使用领域编号（如 `101-python.mdc`、`220-tailwind.mdc`）
- **其他类型目录**：从 `0001` 开始各自独立编号（如 `skills/0001-*`、`agents/0001-*`）
- **目录型资产**：目录名也遵循类型内独立编号（如 `skills/0010-git-workflow-expert/`）
- **编号用于导航，不承担全仓库唯一性**

### 目录命名规范

- **顶层目录**：使用资产类型名（如 `rules`、`skills`、`agents`）
- **类型内部目录/文件**：使用 `编号-名称`（如 `001-general-standards`、`0010-git-workflow-expert`）
- **编号位数**：`rules/` 保持原有领域编号；其他类型建议 4 位独立编号
- **名称**：小写字母，单词间用连字符 `-` 连接

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
