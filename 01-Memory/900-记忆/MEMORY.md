# MEMORY.md - 长期记忆

_精选值得长期保留的重要信息_

---

## ⚠️ 重要：记忆同步仓库

**Obsidian 仓库（主要）**：
- 本地：`/data/vault/`
- 远程：`https://github.com/JasonFang1993/obsidian-vault`

**同步位置**：
- 记忆 → `/data/vault/01-Memory/900-记忆/`
- 每日 → `/data/vault/01-Memory/100-每日/`
- 项目 → `/data/vault/01-Memory/200-项目/`

---

## 🔄 重装电脑后操作指引（完整版）

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
# 克隆 OpenClaw
git clone git@github.com:openclaw/openclaw.git
cd openclaw
npm install

# 初始化配置
```

### 4. 克隆仓库
```bash
mkdir -p ~/.openclaw/workspace
cd ~/.openclaw/workspace

git clone git@github.com:JasonFang1993/openclaw-memory.git
git clone git@github.com:JasonFang1993/openclaw-skills.git
git clone git@github.com:JasonFang1993/obsidian-vault.git /data/vault
```

### 5. 安装 Skills
```bash
# 链接 memory-manager
ln -s ~/.openclaw/workspace/openclaw-skills/memory-manager ~/.openclaw/skills/memory-manager
```

### 6. 配置 MCP（重要！）
```bash
# 安装 MCP 适配器
openclaw plugins install openclaw-mcp-adapter

# 配置 MCP
jq '.plugins.entries."openclaw-mcp-adapter" = {
  "enabled": true,
  "config": {
    "servers": [
      {
        "name": "obsidian",
        "transport": "stdio",
        "command": "npx",
        "args": ["-y", "@mauricio.wolff/mcp-obsidian", "/data/vault"]
      }
    ],
    "toolPrefix": true
  }
}' ~/.openclaw/openclaw.json > /tmp/openclaw.json && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

### 7. 启动 Docker
```bash
systemctl start docker
systemctl enable docker
```

### 8. 重启 Gateway
```bash
openclaw gateway restart
```

### 9. 设置定时同步（可选）
```bash
# 添加 Cron
crontab -e
# 0 23 * * * cd /data/vault && git add -A && git commit -m "chore: daily sync" && git push
```

### 10. 验证
```bash
# 检查 MCP
openclaw plugins list | grep mcp

# 检查 vault
ls -la /data/vault/
```
  }
}' ~/.openclaw/openclaw.json > /tmp/openclaw.json && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

### 4. 启动 MCP 服务器
```bash
# 确保 vault 目录存在
mkdir -p /data/vault

# 重启 Gateway
openclaw gateway restart
```

### 5. 加载记忆
- MEMORY.md（本文档）
- memory/2026-02-27.md（最新一天）
- USER.md、IDENTITY.md

### 6. 同步命令
```bash
# 记忆仓库
cd ~/.openclaw/workspace/openclaw-memory
git add -A && git commit -m "chore: sync" && git push

# Vault 仓库
cd /data/vault
git add -A && git commit -m "chore: sync" && git push
```

---

## 用户信息

- **GitHub**: JasonFang1993
- **用途**: OpenClaw AI 助手管理、WhatsApp 客服自动化、Skills 开发

---

## 项目状态

### openclaw-skills
- 仓库: github.com/JasonFang1993/openclaw-skills
- Skills: pdf, pptx, docx, xlsx, canvas-design, webapp-testing, weather, ddg-search, jina-reader, http-client, skill-creator, systematic-debugging, find-skills, drawio-diagrams, news-research, github-to-skills, skill-manager, skill-evolution-manager, **memory-manager**

### openclaw-memory
- 仓库: github.com/JasonFang1993/openclaw-memory
- 用途: 同步 daily notes 到 GitHub

### obsidian-vault（新仓库，整合所有笔记）
- 仓库: github.com/JasonFang1993/obsidian-vault
- 用途: 所有 Obsidian 笔记（包括 memory 迁移）

### openclaw-memory（旧仓库，可删除）
- 仓库: github.com/JasonFang1993/openclaw-memory
- 状态: 内容已迁移到 obsidian-vault，建议删除

---

## 技术配置

- GitHub SSH: ✅ Ed25519
- OpenClaw Skills: ~/.openclaw/skills/
- 模型: minimax-portal/MiniMax-M2.5

---

## 待办/计划

### 高优先级
- [ ] 实现自动记忆整理功能
- [ ] 配置 Cron 定时同步

### 中优先级
- [ ] 完善 memory 自动同步到 GitHub
- [ ] 优化 MCP 工具调用

---

## 重要笔记

### HTTP Client v2.3
- 原生 Node.js，无外部依赖
- Bug: `parsedUrl.path` → `parsedUrl.pathname`

### Draw.io Diagrams Skill
- 正确格式: PlantUML (SVG)
- 导入: Arrange > Insert > Advanced > PlantUML

### MCP 配置要点
- 使用 @mauricio.wolff/mcp-obsidian（支持 stdio）
- vault 路径: /data/vault
- 需要配置 toolPrefix: true

---

## 记忆管理（2026-02-27 更新）

### 层级结构

| 类型 | 位置 | 共享 |
|------|------|------|
| Project memory | ./.claude/CLAUDE.md | Git |
| Project rules | ./.claude/rules/*.md | Git |
| User memory | ~/.claude/CLAUDE.md | 仅自己 |
| Local | CLAUDE.local.md | 仅自己（自动 .gitignore） |
| Auto memory | memory/ | 本地 |

### 最佳实践

- MEMORY.md 保持精简（~200行）
- 详细内容拆分到 memory/full/
- 定期审查清理过时信息

---

## 参考链接

- OpenClaw 文档: https://docs.openclaw.ai
- Skills 市场: https://clawhub.com
- Claude Code Memory: https://code.claude.com/docs/en/memory

---

## 📚 学到的经验（持续更新）

### 2026-02-28: 从微信文章学习 Skills 最佳实践

**来源**: https://mp.weixin.qq.com/s/qR2vU_gFZLp2jffjgyITaQ

#### 1. Skills 搜索工具
- Vercel 官方 `skills` CLI: `npx skills find/add/check/update`
- 官网: skills.sh

#### 2. Skill 编写最佳实践
- **渐进式加载**: 元数据 → 主体 → 引用（省上下文）
- **自由度匹配**: 任务越脆弱，指令越具体；任务越灵活，指令越宽松
- **简洁原则**: 只保留 AI 需要的信息，不要 README/安装指南

#### 3. 系统化调试方法论（四阶段）
1. **观察**: 仔细读错误信息，可靠复现
2. **分析**: 找类似代码，对比差异
3. **假设**: 单一假设，最小改动测试
4. **修复**: 先写失败测试，验证修复

**核心原则**: 没有找到根本原因前，禁止尝试修复

**统计**: 系统化调试 15-30分钟 vs 随机修复 2-3小时

#### 4. 设计先行
- 任何项目必须先设计，获得批准后才能实现
- 看似繁琐，实则避免返工

### 2026-03-02: Agent-Reach 学习

**来源**:
- 微信文章：https://mp.weixin.qq.com/s/01UG0T6cbzZZMzGWvTc9dg
- GitHub：https://github.com/Panniantong/Agent-Reach

**项目介绍**：
- 让 AI Agent 一键拥有互联网能力
- 2天 1.1K Star → 现在 3K+ Star
- 核心理念：脚手架，不是框架

**功能**：
| 平台 | 费用 |
|------|------|
| Twitter/X | 免费（Cookie） |
| YouTube/B站 | 免费 |
| 小红书 | 免费（Cookie） |
| GitHub | 免费 |
| 全网搜索 | 免费（Exa） |

**学到的观点**：
- AI 时代，想法、判断力比技术重要
- 通才 > 专才
- 与其死磕代码，不如死磕念头

**已添加到技能仓库**：agent-reach

---

## 🧠 OpenClaw 经验总结（2026-03-01）

### 翟星人 OpenClaw 系列（12篇）核心认知

#### 1. 架构定位
- OpenClaw = 7×24 常驻 AI 助理平台
- 不是"另一个 OpenCode"，是"智能体助理"
- 核心价值：集成 + 编排 + 调度

#### 2. 底层引擎
- OpenClaw 底层是 **Pi Coding Agent**
- Pi 只有 4 个工具：Read/Write/Edit/Bash
- Pi 本身支持 15+ LLM Provider
- 架构选择：底层交给 Pi，自己专注做上层（渠道/调度/记忆/编排）

#### 3. 记忆系统（四层）
1. 文件记忆：MEMORY.md + 每日日记
2. 自动刷盘+压缩：memoryFlush 先刷盘再压缩
3. 向量搜索：Hybrid Search（BM25 + 向量）
4. 高阶：LanceDB/Supermemory

#### 4. 多 Agent 协作
- Spawn：异步后台任务，不阻塞主 Session
- 独立 Agent：有独立 workspace/记忆/Session
- ACP：结构化协议，比PTY更可控

#### 5. 调度器
- Heartbeat：周期性巡检（默认30分钟）
- Cron：精确时间任务
- Webhook：外部触发

#### 6. 安全分层
- Gateway 认证 → Agent 工具权限 → Workspace 隔离 → 沙箱

---

### 实践评估与建议

#### 已验证可借鉴的方案

| 方案 | 状态 | 说明 |
|------|------|------|
| cron-tools | ✅ 有 | daily-brief.sh, weekly-review.sh |
| pm-toolkit | ✅ 有 | STATE.yaml 协调多 AI |

#### 评估后暂不推荐的方案

| 方案 | 原因 |
|------|------|
| 多 Agent 分工 | 复杂度暴增，当前不需要 |
| ACP 调用 OpenCode | 风险高，当前 exec 模式够用 |
| 向量搜索 | 等真正需要时再配 |

#### 核心原则
- **当前模式够用**：OpenClaw 调度 + exec 调用 OpenCode
- **不给自己找麻烦**：锦上添花 vs 雪中送炭
- **等痛点来了再配**：不要过度工程化

---

### 知识库

- 翟星人 12 篇系列已保存到：knowledge-base/Resources/AI/
- 文件：opencode-vs-openclaw.md, openclaw-seven-files.md, openclaw-feishu-team.md, openclaw-camera-monitor.md, openclaw-memory-system.md, openclaw-gateway.md, openclaw-scheduling-security.md, openclaw-multi-agent.md, openclaw-workflows.md, openclaw-acp.md, openclaw-pi-engine.md

---


---

## 🎯 OpenCode 系列评估总结（2026-03-01）

### 已学完的系列

| 系列 | 篇数 | 来源 |
|------|------|------|
| 翟星人 OpenClaw 系列 | 12篇 | 微信 |
| 翟星人 OpenCode 系列 | 10篇 | 微信 |

---

### OpenCode 系列核心认知

#### 1. Skills 系统（三级加载）
- L1: name + description（始终在上下文）
- L2: SKILL.md（触发时加载）
- L3: scripts/references（按需加载）

#### 2. MCP vs Skills
- MCP = 器官（提供能力）
- Skills = 技能（提供方法）

#### 3. 十大场景
- 图文视频生产线
- 智能问数（NL2SQL）
- 知识库管理
- ...

#### 4. 核心方法论
```
需求 → 找GitHub项目 → 包装成Skill → 永久拥有
```

---

### 评估结论（与当前模式对比）

| 方案 | 推荐度 | 与当前冲突？ |
|------|--------|-------------|
| Skills三级加载 | ⭐⭐ | 无冲突 |
| 多Skill协作 | ⭐⭐ | 无冲突（已有pm-toolkit）|
| 知识库增强 | ⭐⭐ | 无冲突（已有link-to-knowledge）|
| 视频生成 | ⭐ | 暂不需要 |
| NL2SQL | ⭐ | 暂不需要 |

---

### 我们的模式

- **OpenClaw** = 调度中心 + 对外连接
- **OpenCode** = 本地深度执行

> 当前模式够用，不冲突，保持现状

---

