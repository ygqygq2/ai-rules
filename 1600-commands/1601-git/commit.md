# /commit — Smart Commit

根据当前 `git diff --staged` 自动生成符合 Conventional Commits 规范的提交信息，并执行提交。

## 步骤

1. 运行 `git diff --staged` 获取已暂存的变更
2. 分析变更类型和范围
3. 生成提交信息（格式：`<type>(<scope>): <subject>`）
4. 展示给用户确认
5. 用户确认后执行 `git commit -m "<message>"`

## 提交类型参考

| 类型 | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `docs` | 文档变更 |
| `style` | 代码格式（不影响逻辑）|
| `refactor` | 重构（既非功能也非修复）|
| `perf` | 性能优化 |
| `test` | 测试相关 |
| `chore` | 构建/工具/依赖更新 |
| `ci` | CI/CD 配置 |

## 规则

- subject 使用英文，首字母小写，不加句号
- 总长不超过 72 字符
- 若变更涉及多个模块，优先取最核心的 scope
- 重大变更（breaking change）在 body 中注明 `BREAKING CHANGE:`
