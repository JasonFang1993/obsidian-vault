---
title: Docker 安全运行 OpenClaw 方案 - 沙盒隔离 + 本地模型
source: 微信文章
url: https://mp.weixin.qq.com/s/cnRfrMElMQqyj6_hxCevuw
date: 2025-01-20
tags:
  - openclaw
  - docker
  - 安全
  - ai-agent
---

> “本地运行 OpenClaw？Docker 给出了目前最安全的方案。不是因为外面太危险——而是因为你不知道 AI 代理在你的机器上悄悄干了什么。

## 背景

OpenClaw 是今年最火的开源 AI 编码代理之一，上线一周就在 GitHub 斩获 15 万 Star。

**问题**：OpenClaw 作为 AI 代理，有能力：
- 读写你机器上的任意文件
- 发起任意网络请求
- 接触你设置的 API 密钥
- 执行任意 Shell 命令

当你在本地跑 OpenClaw，你实际上是把一个有相当大权限的"AI 员工"放进了自己的机器里。它越聪明，你就越需要给它画一条边界。

## 解决方案：Docker Sandboxes + Docker Model Runner

### 1. Docker Sandboxes

运行在微型虚拟机（microVM）里的隔离环境：

| 对比项 | 普通容器 | Docker Sandboxes |
|--------|----------|------------------|
| 内核 | 共享主机 | 独立内核 |
| 网络访问 | 默认可访问 | 代理层控制，可拒绝 |
| 文件访问 | 可读写 | 只能访问分配的工作区 |
| API 密钥 | 手动管理 | Sandbox 代理自动注入，不可 |

**关键点**：API 密钥由 Sandbox 代理自动注入，OpenClaw 本身永远拿不到密钥原文。

### 2. Docker Model Runner

Docker Desktop 内置的本地 LLM 推理引擎，绑定在主机的 `localhost:12434`。

支持拉取开源模型：
```bash
docker model pull ai/gpt-oss:20B-UD-Q4_K_XL
```

优势：
- 无 API 费用
- 完全私有，代码和 Prompt 从不离开你的机器
- 网络独立，不需要连接外部服务

## 快速开始

```bash
# 1. 启用 Docker Model Runner 并拉取模型
docker model pull ai/gpt-oss:20B-UD-Q4_K_XL

# 2. 创建 Sandbox
docker sandbox create --name openclaw -t olegselajev241/openclaw-dmr:latest shell .

# 3. 配置网络代理并运行
docker sandbox network proxy openclaw --allow-host localhost
docker sandbox run openclaw

# 4. 进入 Sandbox 后执行
~/start-openclaw.sh
```

## 网络桥接技术细节

Docker Model Runner 跑在主机的 `localhost:12434`，但 Sandbox 内部的 localhost 指向的是 Sandbox 自己。

桥接路径：
```
本地桥接（127.0.0.1:54321）
  → Sandbox 网络代理（host.docker.internal:3128）
  → Docker Model Runner（主机 localhost:12434）
```

这个设计让网络控制权始终在代理层，OpenClaw 只能通过这条有限的通路与外部通信。

## 总结

Docker Sandboxes 提供的是一种**结构性的约束**：
- 文件访问被硬限制在工作区
- 网络请求经过代理层过滤
- API 密钥从不暴露给代理本身

这不是"信任 AI 代理"，而是"给 AI 代理设定可验证的边界"。

---

**参考资料**：[Run OpenClaw Securely in Docker Sandboxes | Docker Blog](https://www.docker.com/blog/run-openclaw-securely-in-docker-sandboxes/)
