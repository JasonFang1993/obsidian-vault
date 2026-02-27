#!/bin/bash
# 智能自动整理脚本（修复版）

CONTENT="$1"
DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +"%H:%M")
VAULT_PATH="/data/vault"

# 关键词模式
PREFERENCES_KEYWORDS="喜欢|讨厌|偏好|爱用|用.*而不是|更喜欢|我喜欢"
DECISIONS_KEYWORDS="决定|采用|选择|就定下来|确定用"
TASKS_KEYWORDS="要做|需要做|计划|下周|明天|今天要|待办"

# 分类函数
classify() {
    local content="$1"
    
    if echo "$content" | grep -qE "$PREFERENCES_KEYWORDS"; then
        echo "preference"
    elif echo "$content" | grep -qE "$DECISIONS_KEYWORDS"; then
        echo "decision"
    elif echo "$content" | grep -qE "$TASKS_KEYWORDS"; then
        echo "task"
    else
        echo "normal"
    fi
}

# 保存函数
save_note() {
    local type="$1"
    local content="$2"
    
    case "$type" in
        preference)
            echo "- [$TIMESTAMP] $content" >> "$VAULT_PATH/01-Memory/200-项目/用户偏好.md"
            echo "→ 保存到: 用户偏好.md"
            ;;
        decision)
            echo "- [$TIMESTAMP] $content" >> "$VAULT_PATH/01-Memory/200-项目/重要决定.md"
            echo "→ 保存到: 重要决定.md"
            ;;
        task)
            echo "- [$TIMESTAMP] $content" >> "$VAULT_PATH/01-Memory/100-每日/${DATE}.md"
            echo "→ 保存到: 每日记录.md"
            ;;
        normal)
            echo "- [$TIMESTAMP] $content" >> "$VAULT_PATH/01-Memory/100-每日/${DATE}.md"
            echo "→ 保存到: 每日记录.md"
            ;;
    esac
}

# 主函数
main() {
    local content="${1}"
    
    if [ -z "$content" ]; then
        echo "用法: $0 <内容>"
        exit 1
    fi
    
    echo "分析: $content"
    
    local type=$(classify "$content")
    echo "类型: $type"
    
    save_note "$type" "$content"
}

main "$@"
