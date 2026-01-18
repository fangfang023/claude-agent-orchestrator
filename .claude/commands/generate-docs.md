# /generate-docs

*智能文档生成命令 - 调用 generate-docs-agent 处理文档生成工作流*

## 架构说明

本命令采用 **Command → Agent** 架构：
```
用户 → /generate-docs (Command)
           ↓
       Command 使用 Task 工具
           ↓
       generate-docs-agent (独立会话)
           ↓
       Agent 调用 Skills 完成任务
           ↓
       返回结果展示给用户
```

## 自动加载项目上下文
@/CLAUDE.md
@/docs/ai-context/project-structure.md

---

## 用户输入

用户输入：`"$ARGUMENTS"`

---

## 执行流程

使用 Task 工具调用 `generate-docs-agent`：

### 调用参数
```
subagent_type: generate-docs-agent
prompt: [用户输入]
description: 文档生成工作流
```

### 等待完成
Agent 在独立会话中执行以下操作：
1. 意图解析
2. 工作流规划
3. 调用 Skills
4. 结果汇总

### 结果展示
Agent 完成后，将其返回的结果直接展示给用户。

---

## 命令参数

| 参数 | 说明 | 示例 |
|-----|-----|-----|
| (无) | 基本生成模式 | `/generate-docs [创意描述]` |
| `--optimize [path]` | 优化现有文档 | `/generate-docs --optimize ./docs/tech.md` |
| `--batch [file]` | 批量处理文件 | `/generate-docs --batch ideas.txt` |
| `--output [dir]` | 指定输出目录 | `/generate-docs --output ./mydocs [创意]` |
| `--all` | 生成所有文档类型 | `/generate-docs --all [创意]` |

---

## 使用示例

### 示例 1：生成专利文档
```bash
/generate-docs 我有一个基于深度学习的智能图像识别系统的创意，帮我生成专利
```

### 示例 2：技术方案 + 商业分析
```bash
/generate-docs 为以下创意生成技术方案和商业分析：AI绿植健康管家SaaS
```

### 示例 3：批量处理
```bash
/generate-docs 为以下两个创意分别生成交底书：

创意1：AI绿植健康管家SaaS
创意2：跨境电商差评预警工具
```

### 示例 4：优化文档
```bash
/generate-docs --optimize ./generated_docs/tech_solution.md
```

---

## 与其他命令集成

| 命令 | 配合方式 |
|-----|---------|
| `/code-review` | 生成文档后进行代码/文档审查 |
| `/update-docs` | 生成文档后更新项目文档结构 |
| `/gemini-consult` | 生成前咨询架构设计建议 |

---

## Agent 能力说明

`generate-docs-agent` 支持以下功能：

### 文档类型
| 类型 | 对应 Skill | 类别 |
|-----|-----------|------|
| 技术方案 | tech-solution | 技术 |
| 技术交底书 | tech-disclosure | 专利 |
| 权利要求书 | patent-writing | 专利 |
| 商业分析 | business-analysis | 专利 |
| 工程论文 | engineering-paper | 论文 |
| 经济论文 | economy-paper | 论文 |
| 科学论文 | science-paper | 论文 |
| 专利创新评估 | patent-innovation-assessment-report | 专利 |
| IP保护策略 | ip-strategy | 专利 |
| 价值主张报告 | value-proposition | 技术 |
| 立论白皮书 | thesis-doc | 技术 |
| 项目可行性评估 | project-feasibility-assessment-report | 技术 |
| 伦理风险评估 | ethics-report | 技术 |
| 合规标准策略 | standard-doc | 技术 |

### 执行模式
| 模式 | 说明 |
|-----|------|
| 简单顺序 | 依次执行多个文档 |
| 并行独立 | 同时生成无依赖的文档 |
| 批量处理 | 处理多个创意 |
| 完整流程 | 生成完整的专利文档链 |
| 文档优化 | 优化现有文档 |

---

## 注意事项

1. **会话隔离**：Agent 在独立会话中执行，不影响主会话
2. **工具权限**：Agent 限定使用 Skill, Read, Write, Edit, Glob, Grep, Bash
3. **输出目录**：统一输出到 `./generated_docs/` 目录
4. **依赖管理**：Agent 自动处理文档间的依赖关系

---

*本命令作为调用 generate-docs-agent 的入口点，提供简洁的用户接口*
