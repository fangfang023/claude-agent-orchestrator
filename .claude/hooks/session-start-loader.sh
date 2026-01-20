#!/bin/bash
# /workspace/.claude/hooks/session-start-loader.sh
#
# 功能：在会话开始时加载 CLAUDE.md 上下文
# 触发时机：SessionStart 事件 (每个会话开始时执行一次)
# 输出方式：打印到 stdout，自动注入到会话上下文

CLAUDE_MD_FILE="/workspace/.claude/CLAUDE.md"

# 检查文件是否存在
if [[ -f "$CLAUDE_MD_FILE" ]]; then
    # 直接输出文件内容
    # Claude Code 会自动捕获 stdout 并注入到会话上下文
    cat "$CLAUDE_MD_FILE"
else
    # 文件不存在时的警告 (可选，不影响会话继续)
    echo "# Warning: CLAUDE.md not found at $CLAUDE_MD_FILE"
fi

# 返回成功，会话继续
exit 0
