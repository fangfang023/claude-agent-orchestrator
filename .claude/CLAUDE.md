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
```
Task subagent_type="generate-docs-agent" prompt="生成文档：[创意描述]"
```

## 可用 Skills

### 技术文档
- **technical-tech-solution**: 技术方案生成
- **technical-value-proposition**: 价值主张文档
- **technical-thesis-doc**: 立论白皮书
- **technical-project-feasibility-assessment-report**: 项目可行性评估
- **technical-ethics-report**: 伦理风险评估
- **technical-standard-doc**: 合规标准策略

### 专利文档
- **patent-tech-disclosure**: 技术交底书
- **patent-patent-writing**: 权利要求书
- **patent-patent-innovation-assessment-report**: 专利创新评估
- **patent-business-analysis**: 商业价值分析
- **patent-ip-strategy**: IP 保护策略

### 学术论文
- **paper-engineering-paper**: 工程论文
- **paper-science-paper**: 科学论文
- **paper-economy-paper**: 经济论文

### 工具类
- **utils-document-reviewer**: 通用文档审核，支持循环改进机制

使用方式：
```
Skill skill="technical-tech-solution" args='{"idea": "..."}'
```

## 文档生成路径规则

- 所有文档生成操作在 `/workspace` 目录下执行
- 相对路径基于 `/workspace` 计算
- 文档默认输出到 `/workspace/my-workspace/generated_docs/` 目录
- 输出文件命名格式：`[文档类型]_[创意简述]_[时间戳].md`

## 意图检测

当用户输入包含以下关键词时，请使用 `generate-docs-agent`：
- 技术交底书、专利、论文
- 技术方案、商业计划、可行性评估
- 伦理评估、合规标准、价值主张
- 生成文档、写论文、撰写专利
