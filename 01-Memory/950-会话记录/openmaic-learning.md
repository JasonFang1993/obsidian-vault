# OpenMAIC 学习计划

> 来源：https://github.com/THU-MAIC/OpenMAIC
> 定位：清华大学开源的 AI 互动课堂平台

---

## 🎯 项目目标

把任何主题或文档转化为**沉浸式多智能体互动课堂**。

---

## ✨ 核心功能

| 功能 | 说明 |
|------|------|
| **一键生成课堂** | 描述主题，AI 几分钟构建完整课程 |
| **多智能体课堂** | AI 老师 + AI 同学实时授课讨论 |
| **丰富场景** | 幻灯片、测验、交互式模拟、PBL |
| **白板+TTS** | 智能体画图、写字、语音讲解 |
| **导出** | 下载 pptx 幻灯片或 html 页面 |

---

## 🔧 使用方式

### 1. 在线体验（最简单）
- 访问 https://open.maic.chat/
- 获取访问码即可使用

### 2. OpenClaw 集成（推荐）
```
安装：clawhub install openmaic
然后告诉 AI："教我量子物理"
```

### 3. 本地部署
```bash
# 需求
- Node.js >= 20
- pnpm >= 10
- 至少一个 LLM API Key

# 步骤
git clone https://github.com/THU-MAIC/OpenMAIC.git
cd OpenMAIC
pnpm install
cp .env.example .env.local
# 填入 API Key（支持 OpenAI/Anthropic/Gemini/DeepSeek）
pnpm dev
# 访问 http://localhost:3000
```

---

## 📚 学习路径

### 第 1 步：在线体验（30分钟）
- [ ] 注册 open.maic.chat
- [ ] 生成第一个课堂

### 第 2 步：OpenClaw 集成（1小时）
- [ ] 安装 OpenMAIC Skill
- [ ] 在飞书/Discord 生成课堂

### 第 3 步：本地部署（2小时）
- [ ] 配置开发环境
- [ ] 跑通 demo

### 第 4 步：深度使用
- [ ] 自定义智能体
- [ ] 生成专属课程

---

## 🔗 相关链接

- GitHub: https://github.com/THU-MAIC/OpenMAIC
- 在线体验: https://open.maic.chat/
- 论文: https://jcst.ict.ac.cn/article/doi/10.1007/s11390-025-6000-0
