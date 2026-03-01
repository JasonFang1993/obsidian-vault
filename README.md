# obsidian-vault

OpenClaw + Obsidian 知识记忆库

## 目录结构

```
obsidian-vault/
├── 01-Memory/          # 记忆主目录
│   ├── 000-索引.md     # 索引入口
│   ├── 100-每日/       # 每日记录
│   ├── 200-项目/       # 项目记忆（用户偏好、重要决定）
│   ├── 300-知识/       # 知识库
│   ├── 400-AI新闻/     # AI 新闻研究
│   ├── 900-记忆/       # 工作记录
│   └── 950-会话记录/   # 自动会话保存
├── 02-Rules/           # 规则目录
└── scripts/            # 自动化脚本
```

### 目录编号规则

| 编号 | 含义 |
|------|------|
| 000 | 索引/入口 |
| 100 | 每日记录（高频） |
| 200 | 项目相关（偏好、决定） |
| 300 | 知识库 |
| 400 | 专题（如 AI 新闻） |
| 900 | 归档/记忆 |
| 950 | 会话自动记录 |

### 重要路径

- **Vault 路径**: `/data/vault/`
- **脚本目录**: `/data/vault/*.sh`

## 标签体系

- #memory/索引 - 核心索引
- #memory/daily - 每日记录
- #memory/project - 项目相关
- #memory/knowledge - 知识库
- #memory/important - 重要信息

---

## 🎯 快速开始

### 1. 自动记录（手动）

```bash
/data/vault/auto_record.sh "今天完成了 MCP 配置"
```

### 2. 智能分类（自动识别）

```bash
/data/vault/auto-organize.sh "我喜欢用 TypeScript"
# → 自动识别为偏好，保存到 200-项目/用户偏好.md

/data/vault/auto-organize.sh "决定采用 Vue 框架"
# → 自动识别为决定，保存到 200-项目/重要决定.md

/data/vault/auto-organize.sh "下周要做功能优化"
# → 自动识别为任务，保存到 100-每日/
```

### 3. 会话保存

对话结束时输入 `/new` 会自动保存会话到 `950-会话记录/`

---

## 🔧 自动化脚本

### 脚本列表

| 脚本 | 功能 | 频率 |
|------|------|------|
| `auto_record.sh` | 手动记录 | 手动 |
| `auto-organize.sh` | 智能分类 | 手动 |
| `sync.sh` | 同步到 GitHub | 每天 23:00 |
| `auto-save-session.sh` | 自动保存会话 | 每 30 分钟 |

### 1. auto_record.sh - 手动记录

```bash
# 记录内容到当日笔记
/data/vault/auto_record.sh "今天完成了 MCP 配置"
```

输出：
```
已记录到: /data/vault/01-Memory/100-每日/2026-02-27.md
```

### 2. auto-organize.sh - 智能分类

根据关键词自动识别内容类型并分类：

| 关键词示例 | 类型 | 保存位置 |
|------------|------|----------|
| "我喜欢..." "偏好..." | preference | 200-项目/用户偏好.md |
| "决定..." "采用..." | decision | 200-项目/重要决定.md |
| "要做..." "下周..." | task | 100-每日/ |
| 其他 | normal | 100-每日/ |

```bash
# 识别用户偏好
/data/vault/auto-organize.sh "我喜欢用 TypeScript"

/data/vault/auto-organize.sh "用户说讨厌复杂的代码"

/data/vault/auto-organize.sh "决定采用 React 框架"

/data/vault/auto-organize.sh "下周要完成部署"

/data/vault/auto-organize.sh "今天天气不错"
```

### 3. sync.sh - 同步到 GitHub

```bash
# 手动运行
/data/vault/sync.sh

# 或等待每天 23:00 自动执行
```

### 4. auto-save-session.sh - 自动保存会话

每 30 分钟自动运行，保存会话记录到 `950-会话记录/`

---

## ⏰ 定时任务（Cron）

已配置的定时任务：

```bash
# 1. 每天 23:00 自动同步
0 23 * * * /data/vault/sync.sh >> /tmp/vault-sync.log 2>&1

# 2. 每 30 分钟自动保存会话
*/30 * * * * /data/vault/auto-save-session.sh >> /tmp/auto-save.log 2>&1
```

### 查看 Cron 任务

```bash
crontab -l | grep vault
```

---

## 🔌 MCP 配置

### MCP 工具列表

| 工具 | 功能 |
|------|------|
| obsidian_read_note | 读取笔记 |
| obsidian_write_note | 创建笔记 |
| obsidian_search_notes | 搜索笔记 |
| obsidian_manage_tags | 管理标签 |
| obsidian_list_directory | 列出目录 |
| obsidian_get_vault_stats | 获取统计 |

### 配置命令

```bash
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

---

## 💾 换电脑后的操作（完整版）

### 1. 安装基础依赖

```bash
# 安装 Docker
curl -fsSL https://get.docker.com | sh

# 安装 Git
apt-get install -y git

# 安装 Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts
```

### 2. 配置 Git SSH

```bash
# 生成 SSH 密钥
ssh-keygen -t ed25519 -C "your@email.com"

# 添加到 GitHub
# Settings → SSH Keys → Add new
```

### 3. 安装 OpenClaw

```bash
git clone git@github.com:openclaw/openclaw.git
cd openclaw
npm install
```

### 4. 克隆仓库

```bash
mkdir -p ~/.openclaw/workspace
cd ~/.openclaw/workspace

git clone git@github.com:JasonFang1993/openclaw-skills.git
git clone git@github.com:JasonFang1993/obsidian-vault.git /data/vault
```

### 5. 安装 Skills

```bash
ln -s ~/.openclaw/workspace/openclaw-skills/memory-manager ~/.openclaw/skills/memory-manager
```

### 6. 配置 MCP

```bash
# 安装 MCP 适配器
openclaw plugins install openclaw-mcp-adapter

# 配置 MCP（见上文）

# 重启 Gateway
openclaw gateway restart
```

### 7. 设置定时任务

```bash
# 添加 Cron 任务
crontab -e

# 添加以下行：
0 23 * * * /data/vault/sync.sh >> /tmp/vault-sync.log 2>&1
*/30 * * * * /data/vault/auto-save-session.sh >> /tmp/auto-save.log 2>&1
```

### 8. 验证

```bash
# 检查脚本
ls -la /data/vault/*.sh

# 检查 Cron
crontab -l | grep vault

# 测试自动记录
/data/vault/auto_record.sh "测试"
```

---

## 🔧 故障排查

### MCP 连接失败

```bash
# 检查 npx
which npx

# 手动测试
npx -y @mauricio.wolff/mcp-obsidian /data/vault

# 查看日志
tail -50 /tmp/openclaw/openclaw-2026-02-27.log | grep mcp
```

### 工具不可用

```bash
openclaw gateway restart
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

---

## 📋 使用示例

### 记录每日内容

```bash
/data/vault/auto_record.sh "今天完成了 OpenClaw + Obsidian 集成"
```

### 智能分类

```bash
# 用户偏好
/data/vault/auto-organize.sh "我喜欢用 TypeScript"

/data/vault/auto-organize.sh "用户讨厌复杂的配置"

/data/vault/auto-organize.sh "决定用 Vue3"

/data/vault/auto-organize.sh "下周要实现自动同步"
```

### 搜索记忆

```bash
# 通过 MCP 工具
obsidian_search_notes "关键词"
```

---

## 技术栈

- OpenClaw
- MCP Adapter (openclaw-mcp-adapter)
- obsidian-mcp-server (@mauricio.wolff/mcp-obsidian)
- Obsidian

## 相关仓库

- [openclaw-skills](https://github.com/JasonFang1993/openclaw-skills) - Skills 集合

## 依赖要求

- Node.js 18+
- npx
- Git
- Docker

## 安全注意事项

1. **不要提交敏感信息** - API Key、密码等
2. **使用 .gitignore** - 排除 .obsidian 等目录
3. **定期备份** - 建议每日同步

---

*本仓库由 OpenClaw AI 助手自动管理*

---

## 📚 历史记忆智能分类

### 从历史记忆提取的偏好和决定

已从历史记忆中提取并分类：

#### 用户偏好
- 使用 MiniMax M2.5 模型
- 使用 OpenCode 作为开发工具
- 使用 tmux 管理后台任务

#### 重要决定
- 采用 9 人团队架构（监工 + PM + 前端 + 后端 + QA + 运维）
- 使用 MCP 协议集成 Obsidian
- 使用 git worktree 进行分支隔离
- 创建 memory-manager Skill
- 每天 23:00 定时同步
- 每 30 分钟自动保存会话

### 智能分类关键词

| 类型 | 关键词 | 保存位置 |
|------|---------|----------|
| 偏好 | 喜欢、讨厌、偏好、爱用、更喜欢 | 用户偏好.md |
| 决定 | 决定、采用、选择、确定用 | 重要决定.md |
| 任务 | 要做、需要做、下周、明天、今天要 | 每日记录.md |
| 普通 | 其他 | 每日记录.md |

---

## 🔄 工作流程

### 完整工作流程

```
1. 对话进行中...
    ↓
2. 每 30 分钟自动保存会话 (auto-save-session.sh)
    ↓
3. 每天 23:00 同步到 GitHub (sync.sh)
    ↓
4. 手动触发智能分类 (auto-organize.sh)
    ↓
5. 自动识别并分类保存
```

### 自动保存触发条件

| 触发方式 | 条件 | 保存位置 |
|----------|------|----------|
| Cron 每 30 分钟 | 自动 | 950-会话记录/ |
| /new 命令 | 手动 | 950-会话记录/ |
| auto-organize.sh | 手动 | 200-项目/ |

---

## 📝 快速命令参考

### 常用命令

```bash
# 1. 手动记录
/data/vault/auto_record.sh "内容"

# 2. 智能分类
/data/vault/auto-organize.sh "我喜欢用 Python"
/data/vault/auto-organize.sh "决定采用 Vue"
/data/vault/auto-organize.sh "下周要做..."

# 3. 同步
/data/vault/sync.sh

# 4. 查看 Cron 任务
crontab -l | grep vault

# 5. 查看日志
tail -f /tmp/auto-save-session.log
tail -f /tmp/vault-sync.log
```

### Cron 任务列表

```bash
# 每天 23:00 自动同步
0 23 * * * /data/vault/sync.sh

# 每 30 分钟自动保存会话
*/30 * * * * /data/vault/auto-save-session.sh
```

---

*最后更新: 2026-02-28*

---

## 🔍 检索/查找

### 方式一：命令行搜索

```bash
# 搜索关键词
/data/vault/search.sh "TypeScript"

# 搜索用户偏好
/data/vault/search.sh "偏好"

# 搜索重要决定
/data/vault/search.sh "决定"
```

### 方式二：MCP 工具搜索

```bash
# 通过 MCP 工具搜索
obsidian_search_notes "关键词"
```

### 方式三：Obsidian 客户端

在 Obsidian 中打开 vault，直接搜索

### 搜索覆盖范围

| 目录 | 内容 |
|------|------|
| 100-每日 | 每日记录 |
| 200-项目 | 偏好、决定 |
| 300-知识 | 知识库 |
| 400-AI新闻 | AI 新闻 |
| 900-记忆 | 工作记录 |
| 950-会话记录 | 自动会话 |

---


---

## 🦞 官方 Memory 系统整合（方案 A）

### 与官方 LanceDB 共存

我们的系统与官方向量库系统**各司其职**：

| 系统 | 用途 | 优势 |
|------|------|------|
| 我们的文件存储 | 持久化备份 + 手动整理 | 简单、可读、可控 |
| 官方 LanceDB | 语义搜索 | 智能、理解语义 |

### 官方推荐：memory-hygiene

安装官方 Skill：
```bash
clawhub install memory-hygiene
```

#### 核心命令

```bash
# 审计：查看向量库内容
memory_recall query="*" limit=50

# 清理：删除向量库
rm -rf ~/.clawdbot/memory/lancedb/
openclaw gateway restart

# 重新存储重要信息
memory_store text="用户喜欢 TypeScript" category="preference" importance=0.9
```

#### 官方建议存储

✅ **应该存储**：
- 用户偏好
- 重要决定
- 关键事实

❌ **不应存储**：
- 心跳状态 ("HEARTBEAT_OK")
- 临时信息（时间、临时状态）
- 原始消息日志

#### 定期维护 Cron

```bash
# 每月 1 日 4 点清理
0 4 1 * * rm -rf ~/.clawdbot/memory/lancedb/
```

---

