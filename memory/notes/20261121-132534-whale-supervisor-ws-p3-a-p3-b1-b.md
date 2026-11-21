---
id: 20261121-132534-whale-supervisor-ws-p3-a-p3-b1-b
title: Whale Supervisor WS-P3-A 冻结 + P3-B1 Broker 生命周期完成（58 测试全绿）
tags: Whale Supervisor, P3-A, 冻结, P3-B1, Broker, 58测试, 2026-11-21, 鲸鲸
created: 2026-11-21T05:25:34.158Z
updated: 2026-11-21T05:25:34.158Z
---

Whale Supervisor 设计线里程碑（2026-11-21 下午）：

- **WS-P3-A 正式冻结**：经修订三 → 修订四 → 修订四补丁 → 补充说明，覆盖 14 态状态机（verification_pending/blocked 入权威、cancelled_unknown 审计标记、crashed/orphan_starting 派生视图）、Worker Bootstrap（bootstrap.json 持久证据 + token_hash 不存明文 + 同 uid 威胁模型）、进程组终止（主进程+子进程残留+zombie）、transitions fsync 权威提交点、幂等与 create/spawn 统一权威日志、锁回收 fencing（rename 抢占≠死亡确认，reclaim_aborted）、独立 verification.jsonl 历史。测试计划 T1–T25。上位三原则：状态真实性/执行安全不误杀/持久化真实性。
- **P3-B1 完成**：`broker.py`（生命周期 STOPPED→BOOTING→READY→DRAINING→STOPPED + 单实例锁 DirLock + broker.pid + UDS 复用 transport + 最小 op status/ping）。5 测试本地全绿，电脑 Ubuntu 3.12.3 全量 **58 tests OK**（E1 18 + E2 9 + E3 26 + B1 5）。
- 代码在电脑 `~/.dsh/supervisor/p3/`：states/jobstore/lock_manager/lease_manager/frame/transport/dispatcher/broker + test_*.py。
- 下一批：P3-B2（IPC 帧解析、请求响应、连接管理）、P3-B3（最小 Broker 原型单元测试）；之后 P3-C Job Store、P3-D 模拟 Worker、P3-E 故障注入、P3-F 验收。仍冻结：真实 Worker、真实 SDK、常驻部署、改 Profile。
- 关键约束：E1/E2/E3 接口冻结，改必须走变更审查；不写代码前先设计、先审查。

