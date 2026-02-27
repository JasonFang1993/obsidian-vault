#!/bin/bash
# 智能自动整理脚本（简单版）
# 功能：关键词匹配识别重要信息，自动分类

CONTENT="$1"
DATE=$(date +%Y-%m-%d)

# 关键词模式
PREFERENCES_KEYWORDS="喜欢|讨厌|偏好|爱用|用...而不是|更喜欢"
DECISIONS_KEYWORDS="决定|采用|选择|用...这个|就定下来"
TASKS_KEYWORDS="要做|需要做|计划|下周|明天|今天要"

# 分类函数
classify() {
    local content="$1"
    
    # 检查偏好
    if echo "$content" | grep -qE "$PREFERENCES_KEYWORDS"; then
        echo "preference"
        return
    fi
    
    # 检查决定
    if echo "$content" | grep -qE "$DECISIONS_KEYWORDS"; then
        echo "decision"
        return
    fi
    
    # 检查任务
    if echo "$content" | grep -qE "$TASKS_KEYWORDS"; then
        echo "task"
        return
    fi
    
    echo "normal"
}

# 保存函数
save_note() {
    local type="$1"
    local content="$2"
    local timestamp=$(date +"%H:%M")
    
    case "$type" in
        preference)
            echo "- [$timestamp] $content" >> "/data/vault/01-Memory/200-项目/用户偏好.md"
            echo "preference"
            ;;
        decision)
            echo "- [$timestamp] $content" >> "/data/vault/01-Memory/200-项目/重要决定.md"
            echo "decision"
            ;;
        task)
            echo "- [$timestamp] $content" >> "/data/vault/01-Memory/100-每日/${DATE}.md"
            echo "task"
            ;;
        normal)
            echo "- [$timestamp] $content" >> "/data/vault/01-Memory/100-每日/${DATE}.md"
            echo "normal"
            ;;
    esac
}

# 主函数
main() {
    local content="${1:-$CONTENT}"
    
    if [ -z "$content" ]; then
        echo "用法: auto-organize.sh <内容>"
        exit 1
    fi
    
    echo "内容: $content"
    
    # 分类
    local type=$(classify "$content")
    echo "类型: $type"
    
    # 保存
    save_note "$type "$content""
    echo "已保存"
}

main "$@"
