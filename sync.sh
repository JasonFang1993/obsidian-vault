#!/bin/bash
# 自动同步脚本 - 每天定时执行

cd /data/vault

# 添加所有更改
git add -A

# 检查是否有更改
if git diff --staged --quiet; then
    echo "没有更改需要提交"
else
    # 提交并推送
    git commit -m "chore: daily sync $(date +'%Y-%m-%d %H:%M')"
    git push
    echo "同步完成: $(date)"
fi
