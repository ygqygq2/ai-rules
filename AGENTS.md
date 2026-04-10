# AI Agent Instructions — ai-rules

This repository is a **structured AI rules and asset library** organized by numbered categories.  
When working in this repository, follow these guidelines.

## Repository Structure

| Range | Category |
|-------|----------|
| 001–099 | General standards |
| 100–199 | Programming languages |
| 200–299 | Frameworks & libraries |
| 300–399 | Databases |
| 500–599 | API design |
| 600–699 | Testing |
| 700–799 | Security |
| 800–899 | DevOps / CI·CD |
| 900–999 | Architecture |
| 1000–1099 | UI/UX design |
| 1100–1199 | Project management |
| 1200–1299 | Documentation |
| 1300–1399 | Skills (SKILL.md directories) |
| 1400–1499 | Agents (*.agent.md) |
| 1500–1599 | Prompts (*.prompt.md) |
| 1600–1699 | Commands (.claude/commands/) |

## Asset Types

- **rule** — `.mdc` files with frontmatter; applied by AI tools as coding rules
- **instruction** — `AGENTS.md`, `CLAUDE.md`, `*.instructions.md`; AI agent system instructions
- **skill** — directories containing `SKILL.md`; reusable multi-step workflows
- **agent** — `*.agent.md` files; specialized agent configurations
- **prompt** — `*.prompt.md` files; reusable prompt templates
- **command** — files under `commands/`; slash commands for Claude Code
- **hook** — files under `hooks/`; lifecycle event handlers
- **mcp** — `mcp.json`; Model Context Protocol server configurations

## Conventions

- Rule files (`.mdc`) must include YAML frontmatter with `id`, `title`, `tags`
- Skill directories must contain a `SKILL.md` as the entry point
- Agent files should describe purpose, capabilities, and constraints
- Prompt files should include a brief description and the prompt template
- Keep numbered IDs unique; use the next available number in the range

## Working Guidelines

1. Read the relevant rule/skill file **before** generating code in that domain
2. When adding new rules, place them in the correct category range and update the category `README.md`
3. Prefer editing existing rules over creating duplicates
4. Always validate frontmatter when modifying `.mdc` files
