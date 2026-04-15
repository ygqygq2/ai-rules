# AI Agent Instructions — ai-rules

This repository is a **structured AI rules and asset library** organized by **asset type first**, then by numbered subcategories where applicable.  
When working in this repository, follow these guidelines.

## Repository Structure

| Top-level dir | Purpose | Numbering |
|---------------|---------|-----------|
| `rules/` | Domain rules and coding standards | Keep domain ranges such as 001–1299 |
| `skills/` | Workflow skills and reusable methods | Independent `0001+` sequence |
| `agents/` | Custom agent definitions (`*.agent.md`) | Independent `0001+` sequence |
| `prompts/` | Prompt templates (`*.prompt.md`) | Independent `0001+` sequence |
| `commands/` | Command templates and slash-command assets | Independent `0001+` sequence |
| `hooks/` | Hook fragments and supporting scripts | Independent `0001+` sequence |
| `mcp/` | MCP server fragments and related assets | Independent `0001+` sequence |

## Why the repository is organized this way

This repository is intentionally organized by **asset type first**, not by a single global numbering system.

That design solves three practical problems:

1. **Type must be obvious before topic**  
	Many assets may share the same file format but have different meanings. For example, JSON under `hooks/` and JSON under `mcp/` are not interchangeable assets.

2. **Humans and tools need the same signal**  
	Maintainers should be able to tell what an asset is from its location, and sync/generation tools should be able to classify assets without guessing from file extension alone.

3. **Numbering should be local to the asset type**  
	`rules/` keeps its historical domain numbering, while `skills/`, `agents/`, `prompts/`, `commands/`, `hooks/`, and `mcp/` each use their own independent numbering space. This avoids cross-type number collisions and keeps navigation simple.

In short: the structure is optimized for **clarity, synchronization safety, and long-term extensibility**, not just for visual tidiness.

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
- Keep numbers unique **within the current asset type**, not across the whole repository

## Working Guidelines

1. Read the relevant rule/skill file **before** generating code in that domain
2. When adding new assets, decide the **asset type first**, then place them under the correct top-level directory and update the nearest `README.md`
3. Prefer editing existing rules over creating duplicates
4. Always validate frontmatter when modifying `.mdc` files
