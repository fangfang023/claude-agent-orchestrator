# Extensions 逻辑实现详解

## 1. Agent 实现逻辑

### 1.1 Agent 定义结构

每个 Agent 是一个独立的 Markdown 文件，包含以下结构：

```yaml
---
name: agent-name              # Agent 唯一标识符
description: 简短描述         # Claude 决定何时调用的依据
tools: tool1, tool2, tool3    # Agent 可使用的工具列表
---

# Agent 标题

## 专业领域
[列出专长范围]

## 核心技能
[详细说明能力]

## 工作方法
[执行流程和方法论]

## 常见问题处理
[问题场景和解决方案]

## 最佳实践
[工作标准和原则]

## 沟通风格
[交互方式说明]
```

### 1.2 Agent 调用机制

```
用户请求
    │
    ▼
Claude 分析请求
    │
    ├── 识别问题类型
    ├── 匹配 Agent 专长
    └── 选择最合适的 Agent
    │
    ▼
Task 工具调用
    │
    ├── subagent_type: "{agent-name}"
    ├── prompt: "{具体任务描述}"
    └── 传递上下文
    │
    ▼
Hook: subagent-context-injector.sh
    │
    ├── 检测到 Task 工具调用
    ├── 注入项目上下文
    │   ├── @CLAUDE.md
    │   ├── @project-structure.md
    │   └── @docs-overview.md
    └── 返回增强的 prompt
    │
    ▼
Agent 执行任务
    │
    ├── 使用定义的工具
    ├── 遵循工作流程
    └── 生成结果
```

### 1.3 当前可用的 Agent 映射表

| Agent Name | 文件 | 调用方式 | 适用场景 |
|-----------|------|---------|---------|
| mcp-integration-expert | mcp-integration-expert.md | Task subagent_type | MCP 服务器连接失败、API 调用错误 |
| shell-scripting-expert | shell-scripting-expert.md | Task subagent_type | 脚本开发、自动化任务 |
| patent-disclosure-expert | patent-disclosure-expert.md | Task subagent_type | 专利技术交底书撰写 |

---

## 2. Command 实现逻辑

### 2.1 Command 定义结构

```markdown
# /command-name

*命令简短描述*

## 功能特性
- 功能点1
- 功能点2

## 使用方法
```bash
/command-name [参数]
```

## 执行流程

### 自动加载项目上下文：
@/CLAUDE.md
@/docs/ai-context/project-structure.md
@/docs/ai-context/docs-overview.md

### 第 N 步：步骤名称
[详细执行说明]

## 输出示例
[展示预期的输出格式]

## 配置选项
[可配置的参数]

## 相关命令
[相关联的其他命令]
```

### 2.2 Command 执行流程

```
用户输入: /command-name [参数]
    │
    ▼
Claude 解析 Command
    │
    ├── 加载对应的 .md 文件
    ├── 解析参数和选项
    └── 初始化执行环境
    │
    ▼
Hook 触发 (PreToolUse)
    │
    ├── subagent-context-injector.sh
    │   └── 为后续的 Task 调用注入上下文
    │
    ▼
执行 Command 逻辑
    │
    ├── 按照定义的步骤执行
    ├── 可能生成多个子代理
    ├── 可能调用多个 Skill
    └── 可能集成 MCP 服务器
    │
    ▼
生成输出
    │
    ├── 格式化结果
    ├── 保存到文件 (如需要)
    └── 显示给用户
```

### 2.3 /code-review 命令逻辑详解

```python
# /code-review 执行逻辑伪代码

def code_review_command():
    # 步骤1: 分析需要审查的代码
    code_to_review = get_code_changes()

    # 步骤2: 生成并行专家代理
    agents = [
        create_agent("security-expert", code_to_review),
        create_agent("performance-expert", code_to_review),
        create_agent("architecture-expert", code_to_review)
    ]

    # 步骤3: 并行执行审查
    results = parallel_execute(agents)

    # 步骤4: 汇总结果
    report = {
        "security": results[0].findings,
        "performance": results[1].findings,
        "architecture": results[2].findings
    }

    return generate_review_report(report)
```

---

## 3. Skill 实现逻辑

### 3.1 Skill 定义结构

```yaml
---
name: skill-name
description: 技能描述，Claude 用于匹配
---

# Skill 标题

## 角色定位
[定义 AI 在使用此技能时的角色]

## 何时使用此工作流
**触发条件:**
- 条件1
- 条件2

## 工作流程

### 阶段一：阶段名称
**目标：** [阶段目标]
**退出条件：** [完成标准]

#### 执行步骤
1. [具体操作]
2. [具体操作]

### 阶段二：阶段名称
[...]

## 标准模板
```markdown
[输出文档的模板]
```

## 撰写要求
### 语言风格
- ✅ 必须遵循的标准
- ❌ 禁止的行为

## 特殊场景处理
### 信息不足时
[处理方案]

## 质量标准
生成完成后，自我检查：
- [ ] 检查项1
- [ ] 检查项2

## 输出规范
- **格式**: Markdown (.md)
- **位置**: `./generated_docs/`

## 审核阶段
**文档生成完成后，必须执行审核：**

### 循环评审机制
- 合格标准: 评分 ≥ 80 分
- 改进阈值: 评分 < 80 分时重新生成
- 最大次数: 最多 3 次生成机会

### 审核执行流程
1. 读取审核标准文件
2. 初始化循环变量
3. 执行质量评审循环
4. 生成针对性改进意见
5. 输出审核报告
```

### 3.2 Skill 工作流程

```
用户输入: 自然语言描述需求
    │
    ▼
Claude 匹配 Skill
    │
    ├── 扫描所有 skills 的 description
    ├── 计算匹配度
    └── 选择最匹配的 skill
    │
    ▼
加载 Skill 完整内容
    │
    ├── 读取 SKILL.md
    ├── 解析工作流程
    └── 加载相关模板
    │
    ▼
执行 Skill 工作流程
    │
    ├── 阶段1: 信息收集
    │   ├── 向用户询问缺失信息
    │   └── 验证输入完整性
    │
    ├── 阶段2: 结构设计
    │   └── 规划输出结构
    │
    ├── 阶段3: 内容生成
    │   └── 按模板生成内容
    │
    └── 阶段4: 质量审核
        ├── 读取审核标准
        ├── 执行循环评审
        └── 输出审核报告
    │
    ▼
输出最终结果
```

### 3.3 tech-solution Skill 详细逻辑

```python
# tech-solution 执行逻辑伪代码

def tech_solution_skill():
    # 阶段1: 需求分析
    info = collect_information()
    while not is_sufficient(info):
        ask_user_for_details()
        info = collect_information()

    # 阶段2: 结构设计
    structure = {
        "purpose": "文档目的",
        "tech_overview": "核心技术概述",
        "steps": "详细操作步骤",
        "faq": "常见问题"
    }

    # 阶段3: 内容生成
    attempt = 1
    max_attempts = 3
    passing_score = 80

    while attempt <= max_attempts:
        # 生成文档
        document = generate_document(structure, info)

        # 阶段4: 质量审核
        review_result = review_document(document)

        if review_result.score >= passing_score:
            break
        elif attempt < max_attempts:
            # 生成改进意见并重新生成
            improvements = generate_improvements(review_result.issues)
            info.update(improvements)
            attempt += 1
        else:
            break

    return {
        "document": document,
        "review": review_result
    }
```

### 3.4 循环评审机制

```
┌─────────────────────────────────────────────────────────────┐
│                    循环评审控制流程                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  初始化: attempt = 1, max_attempts = 3              │   │
│  │          passing_score = 80                          │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│                          ▼                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  DO WHILE (attempt ≤ max_attempts)                  │   │
│  │                                                      │   │
│  │  1. 生成文档                                         │   │
│  │  2. 执行质量审核                                     │   │
│  │     ├── 结构完整性检查 (20%)                         │   │
│  │     ├── 内容质量检查 (40%)                           │   │
│  │     ├── 专业性检查 (20%)                             │   │
│  │     └── 可实施性检查 (20%)                           │   │
│  │  3. 计算综合评分                                     │   │
│  │  4. IF 评分 ≥ 80 THEN                               │   │
│  │       → 退出循环，输出审核报告                       │   │
│  │     ELSE IF attempt < 3 THEN                        │   │
│  │       → 生成改进意见                                 │   │
│  │       → 重新生成文档                                 │   │
│  │       → attempt = attempt + 1                       │   │
│  │       → 继续循环                                     │   │
│  │     ELSE                                            │   │
│  │       → 达到最大次数，退出                           │   │
│  │  5. END IF                                          │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│                          ▼                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  输出审核报告                                        │   │
│  │  ├── 综合评分和等级                                  │   │
│  │  ├── 分项评分                                        │   │
│  │  ├── 评审历史                                        │   │
│  │  └── 最终结论                                        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Hook 实现逻辑

### 4.1 Hook 生命周期

```
Claude Code 生命周期
    │
    ├── PreToolUse ──────► Hook 执行点
    │                      └── subagent-context-injector.sh
    │
    ├── Tool Execution
    │
    ├── PostToolUse
    │
    ├── Notification
    │
    └── Stop/SubagentStop
```

### 4.2 subagent-context-injector.sh 逻辑

```bash
#!/bin/bash
# Sub-Agent Context Auto-Injector

# 1. 读取输入
INPUT_JSON=$(cat)

# 2. 提取工具名称
tool_name=$(echo "$INPUT_JSON" | jq -r '.tool_name')

# 3. 只处理 Task 工具
if [[ "$tool_name" != "Task" ]]; then
    echo '{"continue": true}'
    exit 0
fi

# 4. 提取当前 prompt
current_prompt=$(echo "$INPUT_JSON" | jq -r '.tool_input.prompt')

# 5. 构建上下文注入
context_injection="## Auto-Loaded Project Context
...
- @\$PROJECT_ROOT/docs/CLAUDE.md
- @\$PROJECT_ROOT/docs/ai-context/project-structure.md
- @\$PROJECT_ROOT/docs/ai-context/docs-overview.md
...
## Your Task
"

# 6. 合并上下文和原始 prompt
modified_prompt="${context_injection}${current_prompt}"

# 7. 返回修改后的 JSON
output_json=$(echo "$INPUT_JSON" | jq \
    --arg new_prompt "$modified_prompt" \
    '.tool_input.prompt = $new_prompt')

echo "$output_json"
```

### 4.3 Hook 配置 (settings.json)

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Task",
        "hooks": [{
          "type": "command",
          "command": "${WORKSPACE}/.claude/hooks/subagent-context-injector.sh"
        }]
      }
    ]
  }
}
```

---

## 5. Knowledge Base 实现逻辑

### 5.1 审核标准文件结构

```markdown
# {文档类型} 审核标准

## 评分标准

### 综合评分计算
```
总分 = 维度1(权重) + 维度2(权重) + ...
```

### 评级标准
| 等级 | 分数范围 | 建议 |
|------|----------|------|
| 优秀 | 90-100 | 可直接使用 |
| 良好 | 80-89 | 微调后使用 |
| 需改进 | 60-79 | 需要重要改进 |
| 不合格 | 0-59 | 需要重新生成 |

---

## 一、{维度1名称} ({权重}%)

### 检查清单
- [ ] 检查项1
- [ ] 检查项2

### 评分标准
- 完全符合: 100分
- 基本符合: 70分
- 部分符合: 40分
- 不符合: 0分

---

## 审查报告模板

### 基本信息
- 综合评分: [分数]/100
- 等级: [等级]
- 日期: [日期]

### 分项评分
- 维度1: [分数]/100
- 维度2: [分数]/100

### 评审意见
[具体评价]

### 改进建议
[改进建议]
```

### 5.2 审核标准调用机制

```
Skill 执行到审核阶段
    │
    ▼
确定 document_type
    │
    ├── 例如: "tech-solution"
    │
    ▼
查找对应审核标准
    │
    ├── 路径: knowledge/review-standards/tech/solution-review.md
    │
    ▼
读取审核标准文件
    │
    ├── 解析评分维度
    ├── 解析检查清单
    └── 解析评分标准
    │
    ▼
执行质量审核
    │
    ├── 按维度逐项检查
    ├── 计算各项得分
    └── 汇总综合评分
    │
    ▼
生成审核报告
```

### 5.3 document-reviewer Skill 逻辑

```python
# document-reviewer 执行逻辑伪代码

def document_reviewer_skill(document_type, document_content):
    # 1. 查找审核标准
    review_standard_path = get_review_standard_path(document_type)

    # 2. 读取审核标准
    standard = read_review_standard(review_standard_path)

    # 3. 执行审核
    review_result = {
        "total_score": 0,
        "dimension_scores": {},
        "issues": [],
        "passed": False
    }

    for dimension in standard.dimensions:
        # 检查清单
        for item in dimension.checklist:
            result = check_item(document_content, item)
            review_result.issues.append(result)

        # 计算维度得分
        dimension_score = calculate_dimension_score(dimension, review_result.issues)
        review_result.dimension_scores[dimension.name] = dimension_score

    # 4. 计算综合评分
    for dimension, score in review_result.dimension_scores.items():
        weight = standard.get_dimension_weight(dimension)
        review_result.total_score += score * weight

    # 5. 判断是否通过
    review_result.passed = review_result.total_score >= standard.passing_score

    # 6. 生成审核报告
    report = generate_review_report(review_result, standard)

    return report
```

---

## 6. 组件协作流程

### 6.1 完整工作流示例：生成技术方案

```
用户输入: "帮我生成一个实时数据处理的技术方案"
    │
    ▼
Claude 匹配 Skill
    │
    ├── 匹配到: tech-solution
    │
    ▼
加载 tech-solution/SKILL.md
    │
    ▼
执行 Skill 工作流程
    │
    ├── 阶段1: 需求分析
    │   └── 向用户询问详细信息
    │
    ├── 阶段2: 结构设计
    │   └── 规划技术方案结构
    │
    ├── 阶段3: 内容生成
    │   ├── 可能调用 Agent 获取专业建议
    │   │   └── Hook: subagent-context-injector 注入上下文
    │   │
    │   └── 生成技术方案文档
    │
    └── 阶段4: 质量审核
        ├── 读取: knowledge/review-standards/tech/solution-review.md
        ├── 执行循环评审
        │   ├── 第1次评审
        │   ├── 若不达标: 生成改进意见
        │   ├── 第2次评审
        │   └── ...最多3次
        │
        └── 输出审核报告
    │
    ▼
输出最终结果
    │
    ├── 技术方案文档
    ├── 质量审核报告
    └── 评审历史
```

### 6.2 多 Agent 协作示例：代码审查

```
用户输入: /code-review "审查 src/api/ 目录"
    │
    ▼
解析 Command: /code-review
    │
    ▼
执行命令逻辑
    │
    ├── 分析代码范围
    │   ├── src/api/auth.js
    │   ├── src/api/user.js
    │   └── src/api/data.js
    │
    ▼
生成并行专家代理
    │
    ├── Agent 1: 安全专家
    │   ├── Hook: subagent-context-injector 注入上下文
    │   └── 检查安全问题
    │
    ├── Agent 2: 性能专家
    │   ├── Hook: subagent-context-injector 注入上下文
    │   └── 检查性能问题
    │
    └── Agent 3: 架构专家
        ├── Hook: subagent-context-injector 注入上下文
        └── 检查架构问题
    │
    ▼
汇总所有代理的发现
    │
    ├── 整理安全问题
    ├── 整理性能问题
    └── 整理架构问题
    │
    ▼
生成综合审查报告
```

---

## 7. 同步到 Claude Code 的关键点

### 7.1 目录结构同步

```
源项目结构                    Claude Code 标准结构
extensions/                  →  项目根目录/.claude/
├── agents/                  →  ├── agents/
├── commands/                →  ├── commands/
├── skills/                  →  ├── skills/
├── hooks/                   →  ├── hooks/
└── knowledge/               →  ├── knowledge/ (可选)
```

### 7.2 配置文件同步

需要在项目的 `settings.json` 中配置：

```json
{
  "hooks": {...},
  "mcpServers": {...},
  "skills": {...}
}
```

### 7.3 路径引用适配

- 使用 `@` 符号引用项目文档
- 使用 `${WORKSPACE}` 环境变量引用项目根目录
- 相对路径基于 `.claude/` 目录

---

**文档版本**: 1.1
**最后更新**: 2026-01-20
