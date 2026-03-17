# The Agency 学习笔记

> GitHub: msitarzewski/agency-agents
> Stars: 50,745 | Forks: 7,553

---

## 🎯 是什么

**AI Agent 专家集合** - 147 个专业化 Agent，分为 12 个部门。

每个 Agent 都是：
- 🎯 专业领域专家（非通用模板）
- 🧠 有独特个性
- 📋 有交付成果
- ✅ 生产可用

---

## 📂 Agent 部门（12个）

| 部门 | 数量 | 示例 |
|------|------|------|
| 💻 工程部 | 22 | Frontend Developer, Backend Architect, AI Engineer |
| 🎨 设计部 | 8 | UI Designer, UX Researcher, Whimsy Injector |
| 💰 付费媒体 | 7 | PPC Strategist, Search Query Analyst |
| 💼 销售部 | 8 | Outbound Strategist, Deal Strategist |
| 📢 营销部 | ... | Growth Hacker, Content Creator |
| ... | ... | ... |

---

## 🚀 使用方式

### 1. Claude Code（推荐）
```bash
cp -r agency-agents/* ~/.claude/agents/
# 然后说："Activate Frontend Developer mode"
```

### 2. OpenClaw 集成
```bash
./scripts/convert.sh --tool openclaw
./scripts/install.sh --tool openclaw
```

### 3. 其他工具
支持：Cursor, Aider, Windsurf, Gemini CLI, OpenCode, Qwen Code

---

## ✨ 核心特点

1. **专业化** - 每个 Agent 只做一件事
2. **人格化** - 有独特声音和风格
3. **可交付** - 产出真实代码和成果
4. **生产级** - 经过验证的工作流

---

## 🔗 相关资源

- 中文版：https://github.com/jnMetaCode/agency-agents-zh（100个Agent）
- OpenClaw 集合：https://github.com/mergisi/awesome-openclaw-agents

---

## 💡 对比

| 项目 | The Agency | OpenClaw |
|------|------------|----------|
| 定位 | Agent 模板集合 | Agent 运行平台 |
| 数量 | 147 个 | 用户自定义 |
| 复用 | 即插即用 | 需配置 |

---

## 🎯 价值

- 可以直接把 Agent 模板导入 OpenClaw
- 学习如何设计专业化 Agent
- 快速构建团队级 AI 助手
