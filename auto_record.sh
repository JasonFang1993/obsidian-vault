#!/bin/bash
# 自动记录对话到每日笔记
# 用法: ./auto_record.sh "对话内容"

CONTENT="$1"
DATE=$(date +%Y-%m-%d)
FILE="/data/vault/01-Memory/100-每日/${DATE}.md"
TIMESTAMP=$(date +"%H:%M")

if [ -z "$CONTENT" ]; then
    echo "用法: auto_record.sh <内容>"
    exit 1
fi

# 如果文件不存在，创建头部
if [ ! -f "$FILE" ]; then
    cat > "$FILE" << EOF
# ${DATE}

## 今日记录

EOF
fi

# 追加内容
echo "- ${TIMESTAMP}: ${CONTENT}" >> "$FILE"

echo "已记录到: $FILE"
