---
id: 20261121-181315-whale-supervisor-ws-p3-c2-adapte
title: Whale Supervisor WS-P3-C2 设计验收通过并冻结（Adapter 契约四轮修订）
tags: Whale Supervisor, P3-C2, 冻结, 验收, Adapter, 契约, 2026-11-21, 鲸鲸
created: 2026-11-21T10:13:15.928Z
updated: 2026-11-21T10:13:15.928Z
---

Whale Supervisor WS-P3-C2（Worker Adapter 接口与状态映射）**设计阶段验收通过并冻结**（ChatGPT Supervisor 签署，2026-11-21 晚）。经 R1 → R2 → R2.1 → R2.2 四轮修订。

冻结的契约（全部纯设计，无代码）：
1. **双轴状态**：execution_outcome（completed/failed/truncated/terminated_by_signal/unterminated_exit_zero/unknown）× verification_status（not_started/pending/passed/blocked）；completed 只进 verification_pending，verified passed 才是终态。
2. **三层身份**：job_id（Broker 发号，唯一任务身份）/ session_id（会话归属，可续跑）/ messageId·commandId·callId（不绑定执行）；Attempt 不可变审计，纠错只能新增 attempt。
3. **事件与水位**：Event Log 权威、append+fsync 才提交；`durable_log_high_watermark`（恢复起点）与 `checkpoint_through_seq`（仅加速）分离；event_id 幂等（同 id 同内容忽略、同 id 不同内容 PROTOCOL_CONFLICT）；tail_truncation 永久标 incomplete_evidence；stderr 不参与终态。
4. **Lease 三阶段**：reserved（不许提交）→ process_bound（写入 pid/starttime/boot_id 后）→ released（需进程停止确认+generation 匹配+释放已 fsync）；generation fencing 只保证 Session 写句柄/Job·Attempt 状态写/租约释放续租，**不保证**旧 Worker 外部副作用；校验与写入必须同一原子提交边界（防 TOCTOU）。
5. **取消四维**：cancel.requested_at / signal_sent / process_result（process_stopped|termination_failed|not_attempted）/ effect（默认 unknown）；final 优先于取消，无 final 永不猜。
6. **spawn_intent 先行**：fork/exec 前持久化启动意图；orphan_recovered 只表示身份恢复，不代表停止、不自动解租。
7. **Recovery/Shutdown**：崩溃后以权威日志重建（持久化事实→重建→才允许操作）；shutdown 幂等、有界超时、只释放已确认资源、不裁决未完成任务。
8. 20 个故障注入场景（F1–F12 + F5b/F9b/F10b/F13/F14/F15–F20）。

**仍未批准**：Adapter 代码实现、真实 Worker、真实 Session 操作、部署、E1–B2 解冻。下一阶段 Supervisor 建议 **P3-D Worker Adapter 实现前置审查**（只读）：C2 冻结接口能否映射到真实 headless Worker、哪些 supported/unsupported/unknown。

文档：`outputs/2026-11-21/WS-P3-C2-*.md`（设计、R1、R2、R2.1、R2.2），副本 `/sdcard/Download/鲸鲸/`。

