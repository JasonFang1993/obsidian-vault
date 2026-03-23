# Skill Quality Eval Framework

> 基于 eval-driven 迭代优化方法论
> 原则：二元 yes/no（非量表） | 最多 6 条 | 无重叠 | 可执行验证

---

## 活跃 Skill 清单

### 高频（今日使用）
- `feishu-im-read` — 飞书消息读取
- `feishu-create-doc` — 创建飞书云文档
- `feishu-fetch-doc` — 获取飞书文档内容
- `feishu-update-doc` — 更新飞书云文档
- `weixin-reader` — 微信公众号文章读取
- `jina-reader` — 网页内容提取

### 中频（经常使用）
- `feishu-calendar` — 飞书日历
- `feishu-task` — 飞书任务
- `feishu-bitable` — 飞书多维表格
- `pdf` — PDF 处理
- `xlsx` — 表格处理
- `docx` — Word 文档处理
- `github-search` — GitHub 搜索
- `summarize` — 内容摘要

### 低频/备用
- `browser-use` / `stealth-browser` — 浏览器自动化
- `obsidian` — Obsidian 同步
- `weather` — 天气查询
- `ddg-search` — DuckDuckGo 搜索

---

## feishu-im-read

**用途**：飞书 IM 消息读取、搜索、thread 展开

### Eval 条目（6条）
1. ✅ 能正确获取指定 chat_id 的群聊历史消息
2. ✅ 能搜索关键词并返回匹配的 message_id 和摘要
3. ✅ thread 消息能通过 thread_id 正确展开
4. ✅ 图片/文件资源能从 message 中提取并下载
5. ✅ 能按时间范围（start_time/end_time）过滤消息
6. ❌ 当 chat_id 不存在时不报内部错误，能给出可读错误信息

### 当前状态
- 最近使用：2026-03-23（今天）
- 翻车记录：thread 展开曾经需要手动传 thread_id，容易漏

---

## weixin-reader

**用途**：读取微信公众号反爬文章

### Eval 条目（5条）
1. ✅ 能提取公众号文章正文，无"此链接不可见"类错误
2. ✅ 能正确解析图片（img标签）
3. ✅ 多 UA 重试机制有效（mobile WeChat → mobile Safari → desktop）
4. ✅ JSON 模式（`--json`）输出可解析的结构化数据
5. ❌ 超时时间足够，不因网络波动误判为失败

### 当前状态
- 最近使用：2026-03-23（今天）
- 依赖：Node.js 18+，无外部依赖

---

## feishu-create-doc

**用途**：从 Markdown 创建飞书云文档

### Eval 条目（6条）
1. ✅ 创建成功返回 doc_id 和 doc_url
2. ✅ 能指定 wiki_space（个人知识库）创建
3. ✅ Lark-flavored Markdown 高亮块（callout）能正确渲染
4. ✅ 分栏（grid）语法能正确转换为飞书格式
5. ✅ 表格（lark-table）嵌套结构能正确创建
6. ❌ 当 folder_token 无效时报权限错误而非静默失败

### 当前状态
- 最近使用：2026-03-23（今天，OpenCLI × CLI-Anything 文档）
- 成功率：基本稳定

---

## feishu-fetch-doc

**用途**：获取飞书云文档内容并转换为 Markdown

### Eval 条目（5条）
1. ✅ 能正确获取 docx 类型文档的标题和正文
2. ✅ 图片/文件/画板能以 token 形式保留在输出中
3. ✅ 分页获取大文档（offset + limit）正常工作
4. ✅ 支持 wiki URL 自动解析为实际 doc token
5. ❌ 当文档不存在或无权限时，给出可区分的错误（非 500 类）

### 当前状态
- 最近使用：2026-03-23（今天）
- 注意：画板只能获取 token，无法还原 Mermaid 源码

---

## jina-reader

**用途**：网页内容提取（Markdown 格式）

### Eval 条目（5条）
1. ✅ 能提取公开网页正文，去除导航/广告/侧边栏
2. ✅ 支持 `maxChars` 截断且不破坏 Markdown 结构
3. ✅ 提取结果包含标题
4. ✅ 失败时有降级处理（不是直接报 500）
5. ❌ 不暴露服务器 IP（已内置隐私保护）

### 当前状态
- 最近使用：本周
- 依赖：Jina AI Reader API

---

## 迭代记录

### 2026-03-23
- 框架建立，完成 5 个高频 skill 的初版 eval
- 下次目标：为 feishu-calendar、feishu-task、pdf 各加 6 条 eval
