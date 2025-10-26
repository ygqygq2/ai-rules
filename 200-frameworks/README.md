# 前端框架规范

本目录包含主流前端框架和 UI 库的最佳实践和开发规范。

## 📋 规则列表

### [201. React 最佳实践](./201-react.mdc)

**适用场景：**

- React 18+ 应用开发
- 函数式组件和 Hooks
- 现代 Web 应用
- 组件化开发

**核心内容：**

- 组件结构（函数式组件、组合优于继承）
- Hooks 使用（useState, useEffect, 自定义 Hooks）
- 状态管理（Context API、本地状态）
- 性能优化（memoization, React.memo, lazy loading）
- 表单处理（受控组件、验证）
- 错误处理（Error Boundaries）
- 测试（React Testing Library）
- 无障碍访问（ARIA、语义化 HTML）

---

### [202. Next.js 最佳实践](./202-nextjs.mdc)

**适用场景：**

- Next.js 14+ App Router 应用
- 服务端渲染（SSR）
- React 全栈应用
- TypeScript + Tailwind CSS 项目

**核心内容：**

- 项目结构（App Router、文件组织）
- 组件设计（Server Components、Client Components）
- 性能优化（图片优化、动态加载、缓存策略）
- 数据获取（Server Components、错误处理）
- 路由（App Router 约定、动态路由）
- 表单验证（Zod、服务端验证）
- 状态管理（最小化客户端状态）

---

### [203. Vue 最佳实践](./203-vue.mdc)

**适用场景：**

- Vue 3 应用开发
- Composition API
- Nuxt 3 项目
- TypeScript + Vue 项目

**核心内容：**

- 组件结构（单文件组件、Composition API）
- 响应式系统（ref, reactive, computed）
- 组件通信（props, emits, provide/inject）
- 状态管理（Pinia）
- 生命周期钩子
- 性能优化（虚拟滚动、懒加载）
- TypeScript 集成
- 路由管理（Vue Router）

---

### [204. Tailwind CSS 最佳实践](./204-tailwind.mdc)

**适用场景：**

- Tailwind CSS 3+ 项目
- 实用优先的 CSS 开发
- 组件库开发
- 响应式设计

**核心内容：**

- 配置和自定义（tailwind.config.js）
- 实用类使用（语义化、可读性）
- 组件抽取（@apply、组件类）
- 响应式设计（移动优先）
- 深色模式（dark: 变体）
- 性能优化（PurgeCSS、JIT 模式）
- 可访问性（颜色对比度、焦点状态）
- 与框架集成（React、Vue、Next.js）

---

## 🎯 使用指南

### 按技术栈选择

**React + Next.js + Tailwind：**

1. [201-react.mdc](./201-react.mdc) - 基础组件开发
2. [202-nextjs.mdc](./202-nextjs.mdc) - 应用架构和路由
3. [204-tailwind.mdc](./204-tailwind.mdc) - 样式设计

**Vue + Nuxt + Tailwind：**

1. [203-vue.mdc](./203-vue.mdc) - 组件和状态管理
2. [204-tailwind.mdc](./204-tailwind.mdc) - UI 设计

### 按开发阶段

**项目初始化：**

1. 选择框架并配置开发环境
2. 设置 ESLint 和 Prettier
3. 配置 Tailwind CSS
4. 建立项目结构

**组件开发：**

1. 遵循框架特定的组件模式
2. 实施适当的状态管理
3. 使用 Tailwind 实用类
4. 编写可测试的代码

**性能优化：**

1. 实施代码分割和懒加载
2. 优化图片和资源
3. 使用适当的缓存策略
4. 监控和分析性能

**部署前：**

1. 运行生产构建
2. 检查 bundle 大小
3. 验证 SEO 优化
4. 测试响应式设计

---

## 📚 扩展阅读

- [React 官方文档](https://react.dev/)
- [Next.js 官方文档](https://nextjs.org/docs)
- [Vue 3 官方文档](https://vuejs.org/)
- [Tailwind CSS 官方文档](https://tailwindcss.com/docs)
- [Nuxt 3 官方文档](https://nuxt.com/)

---

## 🔄 维护说明

**添加新框架规范：**

1. 使用三位数编号（20x 系列）
2. 创建 `.mdc` 文件，包含完整的 frontmatter
3. 包含：项目结构、核心概念、最佳实践、性能优化
4. 更新本 index.md 文件

**编号规则：**

- 201-210: React 生态（React, Next.js, Remix）
- 211-220: Vue 生态（Vue, Nuxt, Vite）
- 221-230: Angular 生态
- 231-240: 其他框架（Svelte, Solid.js 等）
- 241-250: UI/CSS 框架（Tailwind, Bootstrap, Material-UI）
- 251-260: 状态管理（Redux, Zustand, Pinia）
