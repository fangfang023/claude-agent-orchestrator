# Claude Code Extensions

智能文档生成和工作流编排扩展系统，为 Claude Code 提供专业级的文档生成能力。

---

## 项目概述

### 愿景

本扩展系统旨在将 Claude Code 从一个代码辅助工具升级为**全能型智能文档工作流平台**。通过 Agents、Commands、Skills 三层架构，实现：

- **复杂工作流编排**: 支持串行、并行、迭代等多种执行模式
- **专业文档生成**: 覆盖专利、论文、技术方案等多种文档类型
- **质量自动控制**: 内置循环评审机制，确保输出质量
- **上下文自动注入**: 通过 Hooks 系统实现多 Agent 间上下文共享

### 核心能力

| 能力 | 说明 |
|------|------|
| **工作流编排** | 自动识别用户意图，规划最优执行路径 |
| **依赖管理** | 智能处理文档间的依赖关系 |
| **并行执行** | 同时发起多个独立任务，提升效率 |
| **批量处理** | 支持多创意、多文档的批量生成 |
| **质量评审** | 自动评分和改进，确保文档质量 |

---

## 功能特性

### 1. 智能文档生成

#### 支持的文档类型

**技术文档** (6 种)
- 技术方案 (`tech-solution`)
- 价值主张 (`value-proposition`)
- 立论白皮书 (`thesis-doc`)
- 项目可行性评估 (`project-feasibility-assessment-report`)
- 伦理风险评估 (`ethics-report`)
- 合规标准策略 (`standard-doc`)

**专利文档** (5 种)
- 技术交底书 (`tech-disclosure`)
- 权利要求书 (`patent-writing`)
- 专利创新评估 (`patent-innovation-assessment-report`)
- 商业价值分析 (`business-analysis`)
- IP 保护策略 (`ip-strategy`)

**学术论文** (3 种)
- 工程论文 (`engineering-paper`)
- 经济论文 (`economy-paper`)
- 科学论文 (`science-paper`)

**工具技能** (2 种)
- 文档审核 (`document-reviewer`)
- Git 报告 (`git-report`)

### 2. 工作流执行模式

#### 串行执行
适用于有依赖关系的任务：
```
技术方案 → 技术交底书 → 权利要求书 → IP策略
```

#### 并行执行
适用于无依赖的独立任务：
```
同时发起：工程论文 + 经济论文 + 科学论文
```

#### 迭代执行
适用于批量处理：
```
对每篇论文 → 提取创意 → 生成交底书
```

### 3. 质量保证机制

#### 循环评审流程

```
┌─────────────────────────────────────────────────────┐
│              循环评审控制流程                        │
├─────────────────────────────────────────────────────┤
│                                                     │
│  初始化: attempt=1, max_attempts=3, passing_score=80 │
│                          │                          │
│                          ▼                          │
│  ┌─────────────────────────────────────────────┐   │
│  │  1. 生成文档                                 │   │
│  │  2. 执行质量审核                             │   │
│  │     ├── 结构完整性 (20%)                     │   │
│  │     ├── 内容质量 (40%)                       │   │
│  │     ├── 专业性 (20%)                         │   │
│  │     └── 可实施性 (20%)                       │   │
│  │  3. 计算综合评分                             │   │
│  │  4. IF 评分≥80 → 通过                       │   │
│  │     ELSE → 生成改进意见 → 重新生成           │   │
│  └─────────────────────────────────────────────┘   │
│                          │                          │
│                          ▼                          │
│              输出审核报告                            │
└─────────────────────────────────────────────────────┘
```

### 4. 上下文自动注入

通过 `subagent-context-injector` Hook，所有子 Agent 自动获得：

```bash
@PROJECT_ROOT/CLAUDE.md                    # 项目主上下文
@PROJECT_ROOT/docs/ai-context/project-structure.md  # 项目结构
@PROJECT_ROOT/docs/ai-context/docs-overview.md      # 文档架构
```

---

## 项目结构

```
extensions/
├── .claude/                    # Claude Code 扩展配置
│   ├── CLAUDE.md              # 扩展项目上下文
│   ├── agents/                # 专家代理
│   │   ├── generate-docs-agent.md    # 文档生成编排器 ⭐
│   │   └── OVERVIEW.md
│   ├── commands/              # 用户命令
│   │   ├── code-review.md
│   │   ├── full-context.md
│   │   ├── update-docs.md
│   │   ├── create-docs.md
│   │   ├── refactor.md
│   │   ├── generate-docs.md          # 文档生成命令 ⭐
│   │   └── README.md
│   ├── skills/                # 技能模块
│   │   ├── paper/             # 论文生成
│   │   ├── patent/            # 专利文档
│   │   ├── technical/         # 技术文档
│   │   └── utils/             # 工具技能
│   ├── hooks/                 # 生命周期钩子
│   │   ├── subagent-context-injector.sh
│   │   └── README.md
│   └── knowledge/             # 知识库
│       ├── guidelines/        # 指南文档
│       └── review-standards/  # 审核标准
├── docs/                      # 扩展文档
│   ├── extensions-overview.md        # 总览
│   ├── extensions-logic-detail.md    # 逻辑详解
│   ├── extensions-file-reference.md  # 文件参考
│   ├── generate-docs-agent-logic.md  # Agent 逻辑分析
│   └── review-report-extensions-vs-official.md  # 规范评审
└── README.md                  # 本文件
```

### 核心组件说明

| 组件 | 作用 | 调用方式 |
|------|------|----------|
| **generate-docs-agent** | 文档生成编排器，解析意图并调用 Skills | Task 工具 |
| **#generate-docs** | 用户入口命令，调用 Agent | `#generate-docs [参数]` |
| **Skills** | 具体文档生成逻辑 | Skill 工具 |
| **Hooks** | 自动上下文注入 | PreToolUse 事件 |

---

## 快速开始

### 前置要求

- Claude Code CLI 已安装
- 项目根目录有有效的 `CLAUDE.md`
- 已配置 `.claude/settings.json`

### 安装步骤

1. **复制扩展到项目**
   ```bash
   cp -r extensions/.claude your-project/.claude
   ```

2. **配置 Hooks**
   ```bash
   # 确保可执行权限
   chmod +x .claude/hooks/subagent-context-injector.sh
   ```

3. **验证安装**
   ```bash
   # 查看可用命令
   ls .claude/commands/
   ```

### 第一个文档生成

```bash
# 方式1: 使用命令
#generate-docs 为"AI绿植健康管家"生成技术方案

# 方式2: 直接调用 Agent
Task "subagent_type=generate-docs-agent&prompt=生成技术方案：AI绿植健康管家"
```

---

## 使用方法

### 基础用法

#### 生成单个文档

```bash
#generate-docs 生成技术方案：智能图像识别系统
```

**执行流程**:
1. 意图解析 → 识别为"技术方案"
2. 规划路径 → `technical/tech-solution`
3. 调用 Skill → 生成文档
4. 质量审核 → 循环评审
5. 输出结果 → `./generated_docs/[timestamp]/`

### 高级用法

#### 1. 并行生成多个独立文档

```bash
#generate-docs 同时生成：技术方案、商业价值分析、伦理风险评估
```

**执行模式**: 并行 (3 个 Task 同时发起)

#### 2. 生成完整专利文档链

```bash
#generate-docs 生成完整专利申请文档链：深度学习图像识别
```

**执行路径**:
```
1. tech-solution (技术方案)
   ↓
2. tech-disclosure (技术交底书)
   ↓
3a. patent-writing (权利要求书)
3b. patent-innovation-assessment-report (创新评估)
3c. business-analysis (商业分析)
   ↓
4. ip-strategy (IP策略)
```

#### 3. 批量处理多个创意

```bash
#generate-docs 为以下创意分别生成交底书：

创意1：AI绿植健康管家SaaS
创意2：跨境电商差评预警工具
创意3：智能简历优化系统
```

**执行模式**: 迭代 + 并行

#### 4. 复杂工作流

```bash
#generate-docs 根据创意生成技术方案，然后生成工程论文、科学论文、经济论文，
接着从每篇论文挖掘1个新创意，为每个新创意生成交底书和商业价值报告
```

**执行计划**:
```
阶段1 - 技术方案
  → technical/tech-solution

阶段2 - 三类论文（并行）
  → paper/engineering-paper
  → paper/science-paper
  → paper/economy-paper

阶段3 - 创意挖掘（迭代）
  → 读取3篇论文，各提取1个新创意

阶段4 - 衍生文档（迭代并行）
  → 创意1: patent/tech-disclosure + patent/business-analysis
  → 创意2: patent/tech-disclosure + patent/business-analysis
  → 创意3: patent/tech-disclosure + patent/business-analysis
```

### 命令参数

| 参数 | 说明 | 示例 |
|-----|------|-----|
| `(无)` | 基本生成模式 | `#generate-docs [创意描述]` |
| `--optimize [path]` | 优化现有文档 | `#generate-docs --optimize ./docs/tech.md` |
| `--batch [file]` | 批量处理文件 | `#generate-docs --batch ideas.txt` |
| `--output [dir]` | 指定输出目录 | `#generate-docs --output ./mydocs [创意]` |
| `--all` | 生成所有文档类型 | `#generate-docs --all [创意]` |

### 输出规范

#### 文件命名

```bash
[文档类型]_[创意简述]_[时间戳].md
```

#### 输出目录

```bash
./generated_docs/[YYYYMMDD]/
├── tech-solution_ai-green-plant_20260120.md
├── papers/
│   ├── engineering-paper.md
│   ├── economy-paper.md
│   └── science-paper.md
└── derived/
    ├── idea-1/
    │   ├── tech-disclosure.md
    │   └── business-analysis.md
    ├── idea-2/
    └── idea-3/
```

---

## 进阶指南

### 直接调用 Skill

```bash
# 跳过 Agent，直接调用 Skill
<invoke name="Skill">
<parameter name="skill">tech-solution</parameter>
<parameter name="args">{
  "idea": "智能图像识别系统",
  "target_audience": "技术团队",
  "detail_level": "详细"
}</parameter>
</invoke>
```

### 自定义审核标准

在 `.claude/knowledge/review-standards/` 下添加自定义标准：

```markdown
# custom-type-review.md

## 评分标准

### 综合评分计算
总分 = 维度1(30%) + 维度2(40%) + 维度3(30%)
...
```

### 扩展开发

#### 创建新 Skill

1. 在 `skills/` 下创建目录
2. 创建 `SKILL.md`:

```yaml
---
name: my-custom-skill
description: 简洁描述，用于 Claude 匹配
---

# 技能标题

## 角色定位
...

## 何时使用
...

## 工作流程
...
```

3. (可选) 添加审核标准
4. (可选) 在 Agent 中注册


---

## 技术支持

### 故障排除

**问题**: Hook 不执行
```bash
# 检查文件权限
chmod +x .claude/hooks/subagent-context-injector.sh

# 查看日志
tail -f .claude/logs/context-injection.log
```

**问题**: 上下文未注入
- 确认使用 Task 工具调用 Agent
- 检查 settings.json 中的 hooks 配置

**问题**: Skill 调用失败
- 确认 skill 路径正确
- 检查 YAML frontmatter 格式

### 贡献指南

欢迎贡献新的 Skills、Agents 或改进文档！

---

**版本**: v1.0
**最后更新**: 2026-01-20
**许可**: MIT
