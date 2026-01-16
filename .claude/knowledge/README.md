# 知识库 (Knowledge Base)

本目录包含所有技能的审核标准和参考知识库，供各个 skill 和 agent 引用。

## 目录结构

```
knowledge/
├── README.md                        # 本文件
├── review-standards/                # 审核标准（按类别分组）
│   ├── _index.md                   # 审核标准总目录和状态追踪
│   ├── patent/                     # 专利类审核标准
│   │   ├── writing-review.md       # 权利要求书审核标准
│   │   └── disclosure-review.md    # 技术交底书审核标准
│   ├── business/                   # 商业类审核标准
│   │   └── analysis-review.md      # 商业分析审核标准
│   ├── tech/                       # 技术类审核标准
│   │   └── solution-review.md      # 技术方案审核标准
│   ├── academic/                   # 学术类审核标准（待创建）
│   ├── reports/                    # 报告类审核标准（待创建）
│   └── strategy/                   # 策略类审核标准（待创建）
└── guidelines/                     # 审查指南和参考资料
    ├── 审查指南2023.pdf            # 专利审查指南
    ├── ai-patent-examination-issues.md
    ├── cn-patent-35-key-issues.md
    └── patent-guide-amendment-comparison.md
```

## 使用方式

### 方式一：通过 document-reviewer skill 自动使用

审核技能会根据 `document_type` 自动查找对应的审核标准文件：

```
调用: document-reviewer
参数: document_type = "patent-writing"
→ 自动查找: review-standards/patent/writing-review.md
```

### 方式二：直接引用审核标准文件

在 `SKILL.md` 中通过相对路径引用：

```markdown
## 审核阶段

**生成完成后，执行审核：**

1. 读取审核标准：`../../knowledge/review-standards/tech/solution-review.md`
2. 按照标准进行检查和评分
```

## 目录组织原则

1. **按类别分组**：审核标准按文档类型分类到不同目录
2. **单一职责**：每个审核标准文件只包含一个文档类型的审核规则
3. **可复用性**：通用的审查指南可被多个审核标准引用
4. **版本控制**：所有修改通过 git 追踪

## 添加新审核标准

当添加新的 skill 时：

1. **选择分类**：确定文档类型属于哪个分类
2. **创建文件**：在对应目录下创建 `{name}-review.md` 文件
3. **更新映射**：在 `document-reviewer/SKILL.md` 的映射表中添加记录
4. **更新索引**：在 `review-standards/_index.md` 中记录状态

**示例**：添加专利创新评估审核标准

```bash
# 1. 创建文件
touch review-standards/patent/innovation-review.md

# 2. 编辑文件内容（参考其他审核标准格式）

# 3. 更新 document-reviewer/SKILL.md 映射表
# 添加行: | patent-innovation-assessment | patent | patent/innovation-review.md |

# 4. 更新 review-standards/_index.md 状态
# 标记为 ✅ 已创建
```

## 审核标准状态查看

查看 `review-standards/_index.md` 了解：
- 已创建的审核标准
- 待创建的审核标准
- 每个标准的路径和对应 skill
