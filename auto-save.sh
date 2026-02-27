#!/bin/bash
# 自动保存会话脚本
# 每 30 分钟执行一次

# 获取当前会话的信息
SESSION_FILE="$HOME/.openclaw/workspace/memory/sessions/$(date +%Y-%m-%d)-*.md 2>/dev/null"

# 如果有会话文件，同步到 vault
if [ -d "$HOME/.openclaw/workspace/memory" ]; then
    # 复制会话到 vault
    cp -r $HOME/.openclaw/workspace/memory/*.md /data/vault/01-Memory/950-会话记录/ 2>/dev/null
    
    # 自动提交
    cd /data/vault
    git add -A
    if ! git diff --staged --quiet; then
        git commit -m "chore: auto-save $(date +'%Y-%m-%d %H:%M')"
        git push 2>/dev/null
    fi
fi

echo "自动保存完成: $(date)"
