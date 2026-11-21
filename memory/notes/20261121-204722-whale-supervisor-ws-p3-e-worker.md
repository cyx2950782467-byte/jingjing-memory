---
id: 20261121-204722-whale-supervisor-ws-p3-e-worker
title: Whale Supervisor WS-P3-E 验收通过（确定性核心 + 模拟 Worker，32 测试全绿）
tags: Whale Supervisor, P3-E, 验收, ACCEPTED, Adapter, 模拟Worker, 32测试, 2026-11-21, 鲸鲸
created: 2026-11-21T12:47:22.921Z
updated: 2026-11-21T12:47:22.921Z
---

Whale Supervisor **WS-P3-E 正式验收通过（ACCEPTED）**（ChatGPT Supervisor 签署，2026-11-21 晚）。

通过了什么：Adapter 确定性核心 + 模拟 Worker，32 项测试全绿，C2 的 20 个故障场景全覆盖（F1 spawn 失败无实例、F2 初始化失败有实例需清理、F3 正常完成、F4 验证受阻、F5/F5b 取消、F6 取消失败、F7 exit0 无 final、F8 双 final、F9 中间 seq 缺口、F9b 尾部半行、F10 租约竞争、F10b reserved 无 bind、F11 关闭超时、F12 取消后完成、F13 旧 generation、F14/F15 checkpoint、F16 event_id 冲突、F17 STALE_OWNER 零写入、F18 释放时进程仍活、F19 intent 无 process、F20 截断后追加）。

代码在 `outputs/2026-11-21/p4/`（8 模块：eventlog / lease / outcome / cancel / spawn / shutdown / simworker / adapter），`p3/` 冻结代码零改动。副本 `/sdcard/Download/鲸鲸/p4-proto`。

Supervisor 保留的证据边界：F17 的文件前后一致只证明本次测试检查的存储内容没变，不自动证明所有后端/并发时序/外部副作用。

**下一阶段 WS-P3-F**（真实 Headless Worker 接入前置条件解除），先处理四项遗留：
- P1 sandbox backend 缺失（本机 shell 工具全拒）→ 两条路：装 bubblewrap，或把 Worker 权限模式改 `danger-full-access`（引擎报错原文自己建议这条）。**这是权限决定，需陈点头**。
- P2 凭据持有与注入方案未定 → 可设计为「Broker 从自己的凭据库读入，只注入子进程 env，不写文件不进日志」。
- P3 max-tokens 终态不可观测（headless 无入口，需 sdk profile）→ 保留 unknown。
- P4 真实进程组清理未验证 → 需受控真实进程实验（依赖 P1）。

边界：SimWorker 仅模拟；真实 Headless Worker / 真实凭据注入 / 真实 Session 操作 / 部署 仍未授权。

