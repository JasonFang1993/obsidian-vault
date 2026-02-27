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

### 目录编号规则

| 编号 | 含义 |
|------|------|
| 000 | 索引/入口 |
| 100 | 每日记录（高频） |
| 200 | 项目相关 |
| 300 | 知识库 |
| 400 | 专题（如 AI 新闻） |
| 900 | 归档/记忆 |

### 重要路径

- **Vault 路径**: `/data/vault/`
- **自动记录脚本**: `/data/vault/auto_record.sh`

## 标签体系

- #memory/索引 - 核心索引
- #memory/daily - 每日记录
- #memory/project - 项目相关
- #memory/knowledge - 知识库
- #memory/important - 重要信息

## 自动管理（开发中）

### 自动记录脚本详细用法

```bash
# 基本用法
/data/vault/auto_record.sh "今天完成了 MCP 配置"

# 自动创建当日文件并追加内容
# 输出格式：
# - HH:MM: 内容
```

### 自动记录示例

```bash
# 记录工作内容
./auto_record.sh "完成了 OpenClaw + Obsidian 集成"

# 记录学习内容
./auto_record.sh "学习了 MCP 协议"
```

### 定时同步

创建 Cron 任务：
```bash
# 每天 23:00 自动同步
0 23 * * * cd /data/vault && git add -A && git commit -m "chore: daily sync" && git push
```

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

## MCP 工具列表

通过 openclaw-mcp-adapter 提供以下工具：

| 工具 | 功能 |
|------|------|
| obsidian_read_note | 读取笔记 |
| obsidian_write_note | 创建笔记 |
| obsidian_search_notes | 搜索笔记 |
| obsidian_manage_tags | 管理标签 |
| obsidian_list_directory | 列出目录 |
| obsidian_get_vault_stats | 获取统计 |

## 故障排查

### MCP 连接失败
```bash
# 检查 npx 是否可用
which npx

# 手动测试
npx -y @mauricio.wolff/mcp-obsidian /data/vault

# 检查 Gateway 日志
tail -50 /tmp/openclaw/openclaw-2026-02-27.log | grep mcp
```

### 工具不可用
```bash
# 重启 Gateway
openclaw gateway restart

# 检查插件状态
openclaw plugins list | grep mcp
```

### Git 推送失败
```bash
# 检查网络
ping github.com

# 重新添加远程
git remote remove origin
git remote add origin git@github.com:JasonFang1993/obsidian-vault.git
```

## 备份与恢复

### 手动备份
```bash
# 打包 vault
cd /data
tar -czvf vault-backup.tar.gz vault/

# 推送到备份仓库
git push backup main
```

### 恢复
```bash
# 克隆备份
git clone git@github.com:JasonFang1993/obsidian-vault.git /data/vault
```

## 权限配置

### 目录权限
```bash
# 确保 vault 目录可读写
chmod -R 755 /data/vault
chown -R $(whoami) /data/vault
```

### Git 权限
```bash
# 检查 SSH 密钥
ssh -T git@github.com
```

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

## 依赖要求

### 运行时依赖
- Node.js 18+
- npx
- Git

### OpenClaw 依赖
- openclaw-mcp-adapter 插件
- @mauricio.wolff/mcp-obsidian

## 安全注意事项

1. **不要提交敏感信息** - API Key、密码等
2. **使用 .gitignore** - 排除 .obsidian 等目录
3. **定期备份** - 建议每日同步

## 更新日志

### 2026-02-27
- 初始化 vault
- 迁移所有旧 memory 文件
- 添加 MCP 配置
- 添加 memory-manager Skill

### 历史文件
- 原 openclaw-memory 仓库内容已迁移到 900-记忆/ 目录
