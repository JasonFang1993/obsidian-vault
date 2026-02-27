#!/bin/bash
# 搜索记忆脚本

QUERY="$1"
VAULT_PATH="/data/vault"

if [ -z "$QUERY" ]; then
    echo "用法: search.sh <关键词>"
    echo "示例: search.sh TypeScript"
    exit 1
fi

echo "搜索: $QUERY"
echo "---"

# 1. 使用 grep 搜索
echo "=== 搜索结果 ==="
grep -r "$QUERY" "$VAULT_PATH" --include="*.md" -l 2>/dev/null | head -10

echo ""
echo "=== 文件内容预览 ==="
grep -r "$QUERY" "$VAULT_PATH" --include="*.md" -H -n 2>/dev/null | head -20
