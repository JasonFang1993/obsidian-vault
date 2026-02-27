# obsidian-vault

OpenClaw + Obsidian 知识记忆库

## 目录结构

```
obsidian-vault/
├── 01-Memory/          # 记忆主目录
│   ├── 000-索引.md     # 索引入口
│   ├── 100-每日/       # 每日记录（自动记录）
│   ├── 200-项目/       # 项目记忆
│   ├── 300-知识/       # 知识库
│   ├── 400-AI新闻/    # AI 新闻研究
│   └── 900-记忆/       # 工作记录（AI 记忆）
└── 02-Rules/           # 规则目录
```

## 标签体系

- #memory/索引 - 核心索引
- #memory/daily - 每日记录
- #memory/project - 项目相关
- #memory/knowledge - 知识库
- #memory/important - 重要信息

## 自动管理（开发中）

### 当前功能

1. **自动记录脚本**: `auto_record.sh`
   - 用法: `./auto_record.sh "记录内容"`
   - 自动创建每日文件并追加内容

2. **定时同步**: 每日自动推送到 GitHub

### 开发中的功能

- [ ] 对话结束自动记录
- [ ] 重要信息自动识别
- [ ] 自动分类整理

## 同步到远程

### 自动同步（推荐）

创建 Cron 任务：
```bash
# 每天 23:00 自动同步
0 23 * * * cd /data/vault && git add -A && git commit -m "chore: daily sync" && git push
```

### 手动同步
```bash
cd /data/vault
git add -A
git commit -m "update: ..."
git push
```

## 换电脑后的操作

### 1. 克隆仓库
```bash
# 克隆 vault 到本地
git clone git@github.com:JasonFang1993/obsidian-vault.git /data/vault
```

### 2. 配置 OpenClaw MCP
```bash
# 安装 MCP 适配器
openclaw plugins install openclaw-mcp-adapter

# 配置 MCP
jq '.plugins.entries."openclaw-mcp-adapter" = {
  "enabled": true,
  "config": {
    "servers": [{
      "name": "obsidian",
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@mauricio.wolff/mcp-obsidian", "/data/vault"]
    }]
  }
}' ~/.openclaw/openclaw.json > /tmp/openclaw.json && mv /tmp/openclaw.json ~/.openclaw/openclaw.json

# 重启 Gateway
openclaw gateway restart
```

### 3. 设置定时同步（可选）
```bash
# 添加 Cron 任务
crontab -e

# 添加以下行：
0 23 * * * cd /data/vault && git add -A && git commit -m "chore: daily sync" && git push
```

## 技术栈

- OpenClaw
- MCP Adapter (openclaw-mcp-adapter)
- obsidian-mcp-server (@mauricio.wolff/mcp-obsidian)
- Obsidian

## 相关仓库

- [openclaw-skills](https://github.com/JasonFang1993/openclaw-skills) - Skills 集合
- [openclaw-memory](https://github.com/JasonFang1993/openclaw-memory) - 方案文档（已迁移，可删除）

## 使用示例

### 记录每日内容
```bash
./auto_record.sh "今天完成了 MCP 配置"
```

### 搜索记忆
```bash
# 通过 MCP 工具搜索
obsidian_search_notes "关键词"
```

### 读取记忆
```bash
# 读取指定文件
obsidian_read_note "01-Memory/900-记忆/2026-02-27.md"
```

---

*本仓库由 OpenClaw AI 助手自动管理*
