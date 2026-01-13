# Claude Copilot Instructions for claude-agent-orchestrator

This project is an **AI-native agent orchestration framework** that enables Claude to coordinate multi-agent workflows for documentation generation, code tasks, and specialized expertise. AI agents working here should understand the unique architecture and conventions.

## Project Architecture

**claude-agent-orchestrator** is a **template-driven system** where:
- **Commands** (`.claude/commands/`) orchestrate multi-agent workflows with specific responsibilities
- **Expert Agents** (`.claude/agents/`) provide specialized consultation (config, MCP, shell scripting, etc.)
- **Skills** (`.claude/skills/`) are modular capability extensions (news tracking, patent writing, git reporting)
- **Hooks** (`.claude/hooks/`) provide context injection and task lifecycle management

### Critical Context Files (read first)
1. [CLAUDE.md](CLAUDE.md) - Master AI context with universal coding standards and security principles
2. [docs/ai-context/project-structure.md](docs/ai-context/project-structure.md) - Template architecture for project documentation
3. [docs/ai-context/system-integration.md](docs/ai-context/system-integration.md) - Integration patterns and data flows

### Key Directories
- `.claude/agents/` - Specialized expert agents (config, MCP, shell, Chinese localization, templates, etc.)
- `.claude/commands/` - Command templates (full-context, code-review, gemini-consult, create-docs, handoff, etc.)
- `.claude/skills/` - Reusable capabilities (patent-writing, git-report, news tracking)
- `.claude/hooks/` - Context injection and lifecycle hooks
- `docs/ai-context/` - AI-specific documentation (project structure, system integration, deployment)
- `docs/tutorials/` - Multi-language guides including Chinese course materials

## Auto-Context Injection Pattern

**This is the most important workflow difference from typical projects:**

Commands and spawned sub-agents automatically receive core context through `subagent-context-injector.sh` hooks:
- `@/CLAUDE.md` - Universal standards and AI directives
- `@/docs/ai-context/project-structure.md` - Technical stack and file organization
- `@/docs/ai-context/docs-overview.md` - Documentation architecture

**You don't need to manually include these in Task prompts** - the hooks inject them automatically. Only add file attachments for specific analysis context beyond these core files.

## Essential Workflows & Conventions

### 1. Command Invocation Pattern (Claude Code Integration)
Commands are defined in `.claude/commands/` as markdown files with:
- Auto-loaded context section referencing core documents
- Step-by-step workflow (Analysis → Information Gathering → Generation → Validation)
- Sub-agent spawning via Task tool when complexity is high
- Integration with MCP servers (Gemini, Context7) for external expertise

**Example**: `/full-context` command performs adaptive complexity analysis before deciding between direct analysis or multi-agent orchestration.

### 2. Expert Agent Architecture
Expert agents (`.claude/agents/`) are specialized markdown files with YAML frontmatter defining:
- **name**: agent identifier
- **description**: when and why to use this agent
- **tools**: available tools for the agent

**Key agents to know:**
- `claude-config-expert` - Claude Code configuration, settings, hooks
- `mcp-integration-expert` - MCP servers, external tool integration
- `shell-scripting-expert` - Bash/shell automation and hook development
- `template-management-expert` - Template system and document generation
- `chinese-localization-expert` - Chinese language documentation and tutorials

When you encounter specialized problems in these domains, **acknowledge the expert agent** rather than solving directly.

### 3. Skill Module Pattern
Skills extend Claude Code with modular capabilities:
- Each skill is a folder with `SKILL.md` (YAML frontmatter + instructions) and optional supporting files
- Skills auto-load based on request context (no explicit user activation needed)
- Current skills: patent-writing, git-report, news tracking (Anthropic news specifically)

### 4. Document Generation Strategy
When creating documentation (CONTEXT.md, CLAUDE.md, etc.), follow the three-tier system:
- **Tier 1 (Root)**: Universal project context, CLAUDE.md for AI standards
- **Tier 2 (Component)**: Component-level CONTEXT.md files for major services/modules
- **Tier 3 (Feature)**: Feature-specific documentation for complex subsystems

Reference the `/create-docs` command template for implementation details on complexity assessment and sub-agent orchestration.

### 5. MCP Server Integration
Two MCP servers are configured for enhanced capabilities:

**Gemini MCP Server:**
- Use for deep analysis, code review, architecture discussion, performance optimization
- Auto-context includes project structure and standards
- Supports session persistence and multi-file analysis
- Example: `mcp__gemini__consult_gemini()` for complex cross-file problems

**Context7 Documentation Server:**
- Use for external library documentation (React, FastAPI, Next.js, etc.)
- Provides current documentation beyond training data cutoff
- Example: `mcp__context7__get_library_docs()` for third-party framework questions

## Coding Standards (from CLAUDE.md)

### Universal Principles
- **Manage context ruthlessly** - read related files before planning changes
- **Prioritize standards** - use industry frameworks over custom implementations
- **Never mock or omit code** - always use real implementations
- **Type everything** - type hints on all function parameters and returns
- **Design for evolution** - database schemas must avoid breaking changes

### File Organization
- Prefer **multiple small focused files** over large single files (keep under 350 lines)
- **Single responsibility per file** with clear, explicit purpose
- **Separate concerns**: tools, constants, types, components, business logic to different files
- **Composition over inheritance** - use composition for 'has-a' relationships

### Naming Conventions
- **Classes**: PascalCase (`VoicePipeline`, `ChatRequestSchema`)
- **Functions/methods**: snake_case (`process_audio`, `validate_input`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_AUDIO_SIZE`)
- **Pydantic models**: PascalCase with `Schema` suffix (`ChatRequestSchema`)

### Documentation Requirements
- Every module needs a docstring
- Every public function needs a docstring (Google style)
- Include types in docstrings
- Include Raises section for exceptions

### Security-First (Critical)
- Validate all external input at system boundaries
- Store secrets in environment variables only
- Log security events, but **never log audio, conversations, tokens, or PII**
- Implement row-level security (RLS) for user data isolation
- Verify auth tokens server-side before session creation

## Patterns from Existing Code

### Multi-Agent Orchestration (from `/create-docs` pattern)
When tasks require coordination:
1. Perform **complexity assessment** (file count, technology diversity, architecture depth)
2. Choose strategy: direct analysis → focused analysis → comprehensive multi-agent
3. Spawn parallel sub-agents for specialized analysis only if complexity exceeds threshold
4. Synthesize findings from multiple agents into cohesive output

**This prevents unnecessary agent spawning while enabling it for genuinely complex problems.**

### Context Layering
Commands define three levels of context:
1. **Automatic** - Core project files via hooks
2. **Request-specific** - Target paths and analysis scope
3. **Expert** - MCP servers for external knowledge

Always check what's already auto-injected before duplicating context.

### Hook System for Lifecycle Management
Hooks enable:
- `PreToolUse` - Validate and prepare before tool execution
- `Notification` - Provide user feedback on task progress
- `Stop` - Cleanup and context validation after task completion

When writing automation scripts (`.claude/hooks/`), follow shell best practices from `shell-scripting-expert` agent.

## Common Tasks & How to Approach Them

| Task | Approach | Key File |
|------|----------|----------|
| Create component docs | Use `/create-docs` command, assess complexity tier | `docs/ai-context/project-structure.md` |
| Fix config/hooks issue | Consult `claude-config-expert` agent | `.claude/agents/claude-config-expert.md` |
| Complex architecture decision | Use `/gemini-consult` command with MCP integration | `CLAUDE.md` (MCP section) |
| Add new skill | Follow skill module pattern in `.claude/skills/README.md` | `.claude/skills/news/SKILL.md` |
| Debug multi-agent flow | Check hook execution and context injection | `.claude/hooks/` |
| External library usage | Use Context7 MCP via `/gemini-consult` | CLAUDE.md (MCP Context7 section) |

## What Makes This Project Unique

1. **Template-driven documentation** - This project is itself a template framework that shows how to organize AI-native systems
2. **Automatic context injection** - Sub-agents don't need manual context loading
3. **Expert specialization** - Different agents focus on different domains rather than generalist approach
4. **Multi-language support** - Chinese localization is first-class, not an afterthought
5. **MCP-aware design** - Built to integrate external expertise through MCP servers
6. **Tier-based documentation** - Scales from root context to feature-specific docs

## AI Agent Productivity Tips

- **Read CLAUDE.md first** for universal standards before writing any code
- **Check `.claude/commands/` for similar patterns** before inventing new orchestration approaches
- **Use expert agents** - Don't try to be a generalist when specialists are available
- **Trust auto-context** - Don't duplicate context that hooks already inject
- **Validate through MCP** - For uncertain external knowledge, use Gemini MCP instead of guessing
- **Respect the tiers** - Keep tier 1, 2, 3 documentation properly separated and linked
