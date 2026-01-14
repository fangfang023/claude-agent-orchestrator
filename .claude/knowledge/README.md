# 知识库 (Knowledge Base)

本目录包含所有技能的审核标准和参考知识库，供各个 skill 引用。

## 目录结构

```
knowledge/
├── README.md                        # 本文件
├── review-standards/                # 审核标准
│   ├── tech-solution-review.md      # 技术方案审核标准
│   ├── business-analysis-review.md  # 商业分析审核标准
│   ├── patent-writing-review.md     # 专利撰写审核标准
│   ├── tech-disclosure-review.md    # 技术交底书审核标准
│   └── doc-gen-review.md            # 文档生成审核标准
└── guidelines/                      # 审查指南
    └── patent-guidelines.md         # 专利审查指南
```

## 使用方式

在 `SKILL.md` 中通过 `@` 引用：

```markdown
## 审核阶段

**生成完成后，必须执行以下审核：**

1. 读取审核标准：`@../knowledge/review-standards/tech-solution-review.md`
2. 读取相关指南：`@../knowledge/guidelines/patent-guidelines.md`
3. 按照标准进行检查和评分
```

## 维护原则

1. **单一职责**：每个文件只包含一个技能的审核标准
2. **可复用性**：通用的审查指南可被多个审核标准引用
3. **版本控制**：所有修改通过 git 追踪
4. **清晰命名**：使用 `{skill-name}-review.md` 格式

## 添加新审核标准

当添加新的 skill 时，在 `review-standards/` 目录下创建对应的审核标准文件。
