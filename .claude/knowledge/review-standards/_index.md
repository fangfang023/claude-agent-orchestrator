# 审核标准知识库

本目录包含所有文档类型的审核标准文件，采用**按类别分组**的组织结构。

## 📁 目录结构

```
review-standards/
├── _index.md                    # 本文件：总目录和状态追踪
├── patent/                      # 专利类审核标准
│   ├── writing-review.md        # 权利要求书审核标准 ✅
│   ├── disclosure-review.md     # 技术交底书审核标准 ✅
│   └── innovation-review.md     # 专利创新评估审核标准 (待创建)
├── business/                    # 商业类审核标准
│   ├── analysis-review.md       # 商业分析审核标准 ✅
│   └── value-proposition-review.md  # 价值主张审核标准 (待创建)
├── tech/                        # 技术类审核标准
│   └── solution-review.md       # 技术方案审核标准 ✅
├── academic/                    # 学术类审核标准
│   ├── economy-paper-review.md      # 经济论文审核标准 (待创建)
│   ├── engineering-paper-review.md  # 工程论文审核标准 (待创建)
│   ├── science-paper-review.md      # 科学论文审核标准 (待创建)
│   └── thesis-doc-review.md         # 立论文档审核标准 (待创建)
├── reports/                     # 报告类审核标准
│   ├── ethics-report-review.md      # 伦理报告审核标准 (待创建)
│   └── feasibility-review.md        # 可行性评估审核标准 (待创建)
└── strategy/                    # 策略类审核标准
    ├── ip-strategy-review.md        # IP策略审核标准 (待创建)
    └── standard-doc-review.md       # 合规策略审核标准 (待创建)
```

## 📋 审核标准状态

| 分类 | 文档类型 | 文件 | 状态 |
|------|---------|------|------|
| **专利类** |
| patent | patent-writing | patent/writing-review.md | ✅ 已创建 |
| patent | tech-disclosure | patent/disclosure-review.md | ✅ 已创建 |
| patent | patent-innovation-assessment | patent/innovation-review.md | ⏳ 待创建 |
| **商业类** |
| business | business-analysis | business/analysis-review.md | ✅ 已创建 |
| business | value-proposition | business/value-proposition-review.md | ⏳ 待创建 |
| **技术类** |
| tech | tech-solution | tech/solution-review.md | ✅ 已创建 |
| **学术类** |
| academic | economy-paper | academic/economy-paper-review.md | ⏳ 待创建 |
| academic | engineering-paper | academic/engineering-paper-review.md | ⏳ 待创建 |
| academic | science-paper | academic/science-paper-review.md | ⏳ 待创建 |
| academic | thesis-doc | academic/thesis-doc-review.md | ⏳ 待创建 |
| **报告类** |
| reports | ethics-report | reports/ethics-report-review.md | ⏳ 待创建 |
| reports | project-feasibility-assessment | reports/feasibility-review.md | ⏳ 待创建 |
| **策略类** |
| strategy | ip-strategy | strategy/ip-strategy-review.md | ⏳ 待创建 |
| strategy | standard-doc | strategy/standard-doc-review.md | ⏳ 待创建 |

## 🔗 使用方式

### 在 document-reviewer skill 中使用

审核技能会根据 `document_type` 自动查找对应的审核标准文件：

```
document_type: "patent-writing"
→ 查找: review-standards/patent/writing-review.md

document_type: "business-analysis"
→ 查找: review-standards/business/analysis-review.md
```

### 创建新的审核标准

1. **确定分类**：根据文档类型选择合适的分类目录
2. **创建文件**：在对应目录下创建 `{filename}-review.md` 文件
3. **更新映射**：在 `document-reviewer/SKILL.md` 的映射表中添加记录
4. **参考模板**：可参考现有审核标准文件的格式

## 📝 审核标准文件格式

每个审核标准文件应包含以下结构：

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
| ... | ... | ... |

---

## 一、{维度1名称} ({权重}%)

### 检查清单
- [ ] 检查项1
- [ ] 检查项2

### 评分标准
...

---

## 审查报告模板
...

---

**文档版本**: vX.X
**最后更新**: YYYY-MM-DD
```

## 🔄 版本历史

- **2026-01-15**: 重构为按类别分组结构，提升可维护性

---

**维护者**: AI 专利文档生成系统
**最后更新**: 2026-01-15
