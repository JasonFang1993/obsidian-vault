---
tags:
  - RAG
  - 向量数据库
  - 权限管理
  - Milvus
  - 企业级
created: '2026-03-28'
source: 吴师兄大模型训练营
---
# RAG 企业级实践：权限管理

> 来源：吴师兄大模型训练营 RAG 实战系列
> 时间：2026-03-28
> 标签：#RAG #向量数据库 #权限管理 #Milvus #企业级

---

## 核心问题

**"普通员工能不能搜到副行长薪资文件？"**

向量数据库（Milvus/Qdrant/Weaviate）默认没有行级权限，所有存入同一个 Collection 的向量对所有查询可见。在银行/医疗/政府场景下，这是合规风险，可能引发监管处罚。

---

## 三层权限控制架构

### 第一层：接入层身份认证

JWT Token 携带用户权限上下文：

```json
{
  "user_id": "emp_20041",
  "branch": "上海浦东分行",
  "role": "client_manager",
  "security_level": 2,
  "departments": ["对公业务部"]
}
```

| security_level | 含义 | 典型角色 |
|---|---|---|
| 1 | 公开 | 所有员工 |
| 2 | 内部 | 客户经理、柜员 |
| 3 | 敏感 | 风控、合规 |
| 4 | 机密 | 行级管理层 |

**目的**：每次请求自带权限上下文，不需要每次都查数据库。

---

### 第二层：检索层向量数据库过滤（核心）

#### 方案A：元数据过滤（逻辑隔离）

文档入库时强制带权限字段：

```python
required_fields = ['branch', 'department', 'security_level', 'creator']
chunk_metadata = {
    **metadata,
    'indexed_at': datetime.now().isoformat(),
    'doc_id': generate_doc_id(doc_path)
}
```

检索时动态构建过滤条件：

```python
filter_expr = f'(branch == "{user_branch}" or branch == "公共") and security_level <= {get_security_level(user_role)}'

results = collection.search(
    data=[query_embedding],
    anns_field="embedding",
    param={"metric_type": "COSINE", "params": {"nprobe": 10}},
    limit=top_k,
    expr=filter_expr  # 在向量搜索时就过滤
)
```

#### 方案B：分区物理隔离（更严格）

```python
# 按分行创建独立分区
partition_name = f"branch_{branch}"
collection.create_partition(partition_name)

# 搜索时只搜索授权分区
results = collection.search(
    partition_names=[f"branch_{b}" for b in user_branches]
)
```

| 方案 | 优点 | 缺点 |
|---|---|---|
| 元数据过滤 | 灵活、实现简单 | 依赖 expr 条件写对，逻辑隔离 |
| 分区隔离 | 物理隔离，代码 bug 也不会泄露 | 单 Collection 最多 4096 个分区 |

⚠️ **踩坑：先搜再过滤会导致召回率归零**。必须让 Milvus 在向量搜索阶段就用 expr 过滤，不要事后过滤。

---

### 第三层：返回层二次验证

检索结果返回给用户前，再做一次权限校验。防止第二层配置错误或边界情况的兜底。

---

## 关系型数据库行级安全（RLS）

文档元数据存在 PostgreSQL 时，用 RLS 在数据库层做隔离：

```sql
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY branch_isolation ON documents
    USING (branch = current_user_branch());

CREATE POLICY security_level_check ON documents
    USING (security_level <= get_user_security_level());
```

好处：即使应用层代码有 bug，数据库也会自动过滤。

---

## 文档权限分级体系

| 级别 | 名称 | 可见范围 |
|---|---|---|
| 1 | 公开 | 全行所有员工 |
| 2 | 内部 | 正式员工，外包不可见 |
| 3 | 敏感 | 风控/合规/信贷岗 + 本分行 |
| 4 | 机密 | 行级管理层，需二次审批 |

入库流程：提交 → 部门负责人定级 → 合规团队复审 → 入库。权限标签只有合规团队可修改。

---

## 安全审计

每次查询记录：

```python
audit_log = {
    "timestamp": "2024-03-25T14:32:10.123Z",
    "user_id": "emp_20041",
    "query": "客户的授信额度上限是多少",
    "retrieved_doc_ids": ["doc_001", "doc_045", "doc_112"],
    "retrieved_doc_security_levels": [1, 2, 2],
    "session_id": "sess_abc123"
}
```

异常检测规则：
- 单用户 1 小时查询 > 200 次 → 告警
- 10 分钟内连续检索 security_level=3 文档 > 50 份 → 风控预警
- 非工作时间（22:00-06:00）大量查询 → 通知管理员

---

## 权限缓存

每次查权限会增加 50-100ms 延迟。解决方案：JWT Token 有效期 5 分钟，登录时一次性查出权限签入 Token。

⚠️ 边界情况：权限降级（员工停职）不能等 Token 自然过期，需要维护 Token 黑名单强制失效。

---

## 工程要点

1. **必须在向量搜索阶段过滤**，不要搜完再过滤
2. **分区数量有上限**（Milvus 单 Collection 4096 个），大型机构按大区建分区
3. **权限信息缓存在 Token**，避免每次查库
4. **数据库层 RLS** 做最后兜底
5. **完整审计日志** 是合规必备

---

## 面试怎么答

1. 说清问题：向量数据库默认无行级权限
2. 说三层架构：接入层 JWT → 检索层 expr/partition → 返回层二次验证
3. 说两种方案区别：逻辑隔离 vs 物理隔离
4. 说踩坑：先搜再过滤召回率归零、分区上限
5. 加分项：PostgreSQL RLS、审计日志

**核心结论**：RAG 权限管理是工程完整性问题，不是算法问题。本质是把传统权限管理思路迁移到向量检索场景。
