---
id: 20261121-152310-whale-supervisor-ws-p3-b2-broker
title: Whale Supervisor WS-P3-B2 冻结验收通过（BrokerNet + Dispatcher，88 测试全绿）
tags: Whale Supervisor, P3-B2, 冻结, 验收, BrokerNet, Dispatcher, 88测试, 2026-11-21, 鲸鲸
created: 2026-11-21T07:23:10.705Z
updated: 2026-11-21T07:23:10.705Z
---

Whale Supervisor WS-P3-B2 冻结验收通过（ChatGPT Supervisor 签署，2026-11-21 15:20）。B2 = BrokerNet + Dispatcher 接入：唯一 UDS 监听者 `broker_net.py`（Conn 连接管理、UID 校验、EOF 半帧 TRUNCATED_FRAME 检测、in-flight 分发计数、DrainTimeout、并发 stop 单一 rollback 执行者、socket inode 所有权保护）。

关键安全约束（正式记录）：`~/.dsh/supervisor/` 专用目录 0700；先取 B1 单实例锁再启动 BrokerNet；pid 保留 pid+starttime+boot_id 校验 + 新增 sock_inode 只负责 socket 所有权；lstat+S_ISSOCK 拒绝符号链接替换；无法证明所有权就拒绝 unlink+保留锁+不假装 STOPPED；清理失败允许留资源、禁止误删别人。

测试：本地 34 项（broker 14 + broker_net 20）、Ubuntu 3.12.3 全量 **88 tests OK**（18+9+26+14+21，broker_net 21）。

已冻结模块链：E1 frame(18) / E2 transport(9) / E3 dispatcher(26) / B1 broker 生命周期(14) / B2 broker_net(21)。代码在电脑 `~/.dsh/supervisor/p3/`（frame/transport/dispatcher/lock_manager/lease_manager/states/jobstore/broker/broker_net + test_*.py）。

仍未授权：真实 Worker、改 SDK 原型、常驻部署、改 DSH Profile、真实任务执行。下一阶段（P3-C Job Store 接 Broker / P3-D 模拟 Worker / P3-E 故障注入 / P3-F 验收）需单独批准，勿自动启动。

Python 版本边界：`asyncio.start_unix_server` 的 `cleanup_socket` 是 3.13 新增（默认 True）；3.12 及更早不自动删 socket。

