# 工作区上下文自动注入实现方案

**创建日期**: 2026-01-20
**状态**: 待实施
**优先级**: 高
**执行环境**: Docker 容器 (基于 docs/arch/data-storage-design.md)
**版本**: v3.0 (简化版)

---

## 1. 需求概述

### 1.1 核心需求

| ID | 需求 | 实现方式 |
|----|------|----------|
| 1 | 工作区上下文 | SessionStart Hook 加载 CLAUDE.md |
| 2 | 能力上下文 | CLAUDE.md 中描述 agents/skills |
| 3 | 意图检测 | 模型根据 CLAUDE.md 自动判断 |

### 1.2 设计原则

- **简化优先**：不使用复杂的 shell 脚本扫描
- **声明式配置**：CLAUDE.md 中声明所有信息
- **Session 级别**：在会话开始时加载一次，而非每次 prompt

---

## 2. Docker 容器环境说明

### 2.1 容器工作目录映射

| 宿主机路径 | 容器内路径 | 说明 |
|-----------|-----------|------|
| `workspace/users/user_{id}/data` | `/workspace` | 统一工作目录 |
| `workspace/users/user_{id}/data/.claude/` | `/workspace/.claude/` | 用户级配置 |
| `workspace/users/user_{id}/data/my-workspace/` | `/workspace/my-workspace/` | 默认项目目录 |

### 2.2 最终容器内目录结构

```
/workspace/                              # 容器内统一工作目录
├── .claude/                             # 用户级 Claude 配置
│   ├── CLAUDE.md                        # 扩展上下文（包含 agents/skills 说明）
│   ├── agents/                          # 专家代理
│   │   └── generate-docs-agent.md
│   ├── commands/                        # 用户命令
│   │   └── generate-docs.md
│   ├── skills/                          # 技能模块
│   │   ├── patent/
│   │   ├── paper/
│   │   └── technical/
│   └── hooks/                           # Hook 脚本
│       └── session-start-loader.sh      # 会话启动时加载 CLAUDE.md
└── my-workspace/                        # 默认项目目录
    ├── .claude/                         # 项目级配置
    └── generated_docs/                  # 文档输出目录
```

**重要说明**：
- 后台服务会自动同步 extensions 内容到 `.claude/` 下
- extensions 目录对 Claude Code 透明
- 最终路径直接在 `.claude/` 下，不需要 extensions/ 层级

---

## 3. 技术方案

### 3.1 使用 UserPromptSubmit Hook

**重要说明**: Claude Code SDK 不支持 SessionStart Hook，因此使用 UserPromptSubmit Hook 作为替代方案。

**触发时机**：每次用户提交提示词时执行

**优化机制**：检测用户输入是否已包含上下文标记，避免重复注入

```
用户输入提示词
    │
    ▼
UserPromptSubmit Hook 触发
    │
    ├── 检测是否已有上下文
    ├── 如果没有 → 读取 /workspace/.claude/CLAUDE.md
    ├── 追加到用户输入前
    └── 返回修改后的 prompt
    │
    ▼
Claude 处理增强后的 prompt
    │
    ├── 知道工作目录: /workspace
    ├── 知道可用 agents/skills
    ├── 知道文档生成路径规则
    └── 可以处理用户请求
```

### 3.2 Hook 配置

在 `/workspace/.claude/settings.json` 中配置：

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/workspace/.claude/hooks/user-prompt-injector.sh"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "/workspace/.claude/hooks/subagent-context-injector.sh"
          }
        ]
      }
    ]
  }
}
```

### 3.3 Hook 脚本

**user-prompt-injector.sh**:

```bash
#!/bin/bash
# /workspace/.claude/hooks/user-prompt-injector.sh
#
# 功能：在用户提交提示词时注入扩展上下文
# 触发时机：UserPromptSubmit 事件

set -euo pipefail

CLAUDE_MD_FILE="/workspace/.claude/CLAUDE.md"
CONTEXT_MARKER="## 工作区环境"

INPUT_JSON=$(cat)
USER_PROMPT=$(echo "$INPUT_JSON" | jq -r '.prompt // empty')

# 检测是否已包含上下文（避免重复注入）
if echo "$USER_PROMPT" | grep -q "$CONTEXT_MARKER"; then
    echo "$INPUT_JSON"
    exit 0
fi

# 读取 CLAUDE.md 并追加到用户输入前
if [[ -f "$CLAUDE_MD_FILE" ]]; then
    CLAUDE_MD=$(cat "$CLAUDE_MD_FILE")
    modified_prompt="${CLAUDE_MD}\n\n${USER_PROMPT}"
else
    modified_prompt="$USER_PROMPT"
fi

echo "$INPUT_JSON" | jq --arg new_prompt "$modified_prompt" '.prompt = $new_prompt'
```

---

## 4. CLAUDE.md 文件设计

### 4.1 文件位置

**宿主机路径**: `workspace/users/user_{id}/data/.claude/CLAUDE.md`
**容器内路径**: `/workspace/.claude/CLAUDE.md`

### 4.2 文件内容模板

```markdown
# Claude Code Extensions - 扩展上下文

## 工作区环境

- **当前工作目录**: `/workspace`
- **默认项目目录**: `/workspace/my-workspace`
- **文档输出目录**: `/workspace/my-workspace/generated_docs/`

## 可用 Agents

| Agent | 说明 | 适用场景 |
|-------|------|----------|
| generate-docs-agent | 智能文档生成编排器 | 生成技术方案、专利、论文等文档 |

使用方式：
\`\`\`
Task subagent_type="generate-docs-agent" prompt="生成文档：[创意描述]"
\`\`\`

## 可用 Skills

### 技术文档
- **tech-solution**: 技术方案生成
- **value-proposition**: 价值主张文档
- **thesis-doc**: 立论白皮书
- **project-feasibility-assessment-report**: 项目可行性评估
- **ethics-report**: 伦理风险评估
- **standard-doc**: 合规标准策略

### 专利文档
- **tech-disclosure**: 技术交底书
- **patent-writing**: 权利要求书
- **patent-innovation-assessment-report**: 专利创新评估
- **business-analysis**: 商业价值分析
- **ip-strategy**: IP 保护策略

### 学术论文
- **engineering-paper**: 工程论文
- **science-paper**: 科学论文
- **economy-paper**: 经济论文

使用方式：
\`\`\`
Skill skill="tech-solution" args='{"idea": "..."}'
\`\`\`

## 文档生成路径规则

- 所有文档生成操作在 `/workspace` 目录下执行
- 相对路径基于 `/workspace` 计算
- 文档默认输出到 `/workspace/my-workspace/generated_docs/` 目录
- 输出文件命名格式：`[文档类型]_[创意简述]_[时间戳].md`

## 意图检测

当用户输入包含以下关键词时，请使用 `generate-docs-agent`
- 技术交底书、专利、论文
- 技术方案、商业计划、可行性评估
- 伦理评估、合规标准、价值主张
- 生成文档、写论文、撰写专利
```

---

## 6. 工作流程示例

### 6.1 用户发送消息

```
用户输入: "帮我生成一个智能图像识别的专利"
    │
    ▼
UserPromptSubmit Hook 触发
    │
    ├── 检测用户输入中没有上下文标记
    ├── 读取 /workspace/.claude/CLAUDE.md
    ├── 追加到用户输入前
    └── 返回增强后的 prompt
    │
    ▼
模型处理 (已加载 CLAUDE.md 上下文):
    │
    ├── 知道当前在 /workspace 目录
    ├── 知道可用 generate-docs-agent
    ├── 知道文档输出路径规则
    └── 知道"专利"是文档生成意图
    │
    ▼
模型自动决策: 调用 generate-docs-agent
    │
    ▼
生成专利文档到 /workspace/my-workspace/generated_docs/
```

---

## 8. 配置文件示例

### 8.1 settings.json (完整版)

```json
{
  "editor": "vim",
  "autoConfirm": "dangerouslyAllowSearch",
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/workspace/.claude/hooks/user-prompt-injector.sh"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "/workspace/.claude/hooks/subagent-context-injector.sh"
          }
        ]
      }
    ]
  }
}
```

### 8.2 user-prompt-injector.sh (完整版)

```bash
#!/bin/bash
# /workspace/.claude/hooks/user-prompt-injector.sh
#
# 功能：在用户提交提示词时注入扩展上下文
# 触发时机：UserPromptSubmit 事件 (每次用户输入时触发)
# 优化：检测上下文标记，避免重复注入

set -euo pipefail

CLAUDE_MD_FILE="/workspace/.claude/CLAUDE.md"
CONTEXT_MARKER="## 工作区环境"

INPUT_JSON=$(cat)
USER_PROMPT=$(echo "$INPUT_JSON" | jq -r '.prompt // empty')

# 检测是否已包含上下文（避免重复注入）
if echo "$USER_PROMPT" | grep -q "$CONTEXT_MARKER"; then
    echo "$INPUT_JSON"
    exit 0
fi

# 读取 CLAUDE.md 并追加到用户输入前
if [[ -f "$CLAUDE_MD_FILE" ]]; then
    CLAUDE_MD=$(cat "$CLAUDE_MD_FILE")
    modified_prompt="${CLAUDE_MD}\n\n${USER_PROMPT}"
else
    modified_prompt="$USER_PROMPT"
fi

echo "$INPUT_JSON" | jq --arg new_prompt "$modified_prompt" '.prompt = $new_prompt'
```

---

**版本**: v3.1 (UserPromptSubmit Hook 版本)
**最后更新**: 2026-01-20
**参考文档**: docs/arch/data-storage-design.md
**重要**: Claude Code SDK 不支持 SessionStart Hook，使用 UserPromptSubmit Hook 作为替代
