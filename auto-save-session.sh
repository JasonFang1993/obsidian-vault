#!/bin/bash
# 自动保存当前会话脚本
# 每 30 分钟自动运行，保存当前会话内容

SESSION_DIR="$HOME/.openclaw/agents/main/sessions"
VAULT_DIR="/data/vault/01-Memory/950-会话记录"
DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")

# 创建目录
mkdir -p "$VAULT_DIR"

# 获取最新的会话文件（排除 .lock 文件）
LATEST_SESSION=$(ls -t "$SESSION_DIR"/*.jsonl 2>/dev/null | grep -v ".lock" | head -1)

if [ -z "$LATEST_SESSION" ]; then
    echo "没有找到会话文件"
    exit 1
fi

# 提取会话内容（用户和助手的对话）
# 从 JSONL 中提取 message 部分
CONTENT=$(cat "$LATEST_SESSION" | jq -r 'select(.message != null) | .message.content[].text' 2>/dev/null | head -100)

if [ -z "$CONTENT" ]; then
    echo "会话内容为空"
    exit 1
fi

# 生成摘要（取前 500 字符）
SUMMARY=$(echo "$CONTENT" | head -c 500 | tr '\n' ' ')

# 保存到文件
OUTPUT_FILE="$VAULT_DIR/${DATE}-auto.md"

echo "# 自动会话保存 - $TIMESTAMP

## 会话摘要

$SUMMARY

## 详细内容

$CONTENT

---
*自动保存于 $TIMESTAMP*
" > "$OUTPUT_FILE"

echo "已保存会话到: $OUTPUT_FILE"

# 同时同步到 GitHub
cd /data/vault
git add -A
if ! git diff --staged --quiet; then
    git commit -m "chore: auto-save session $TIMESTAMP" 2>/dev/null
    git push 2>/dev/null
fi
