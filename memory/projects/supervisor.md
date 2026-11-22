# Whale Supervisor（项目参考）

## 定位
让鲸鲸能长期自主干活、证据可追溯、断线不丢任务。外部 Supervisor = ChatGPT 网页版做设计验收。

## 已冻结
- P3-A 设计（14 态/fsync 权威/fencing/verification 历史）
- B1 Broker + 单实例锁、B2 BrokerNet + Dispatcher、C2 Adapter 契约、E 确定性核心、E1~E3 帧/传输/调度
- 凭据注入（`credentials.py` for_spawn/redact/build_env）
- **P3-G（2026-11-22）**：`ownership.py` 六态认领 + `launcher.py`（意图→归属→systemd-run→复核）+ 夹具测试，**206 测全绿**

## 关键结论（实测）
- cgroup.procs 8/8 vs pgid 1/8 → 所有权边界 = cgroup，不是 pgid。
- B（自然退出）与 C（从未启动）12 个字段逐字相同 → 不能靠 unit 名反查历史。
- 六态：owned_live / cancel_pending / stopped / exited_unknown / lost / ambiguous。
- boot 变化 = 确定性死亡（exited_unknown）；manager 重启让 systemd 记账不可信（ambiguous）。
- 只有 stopped 允许直接重试，其余先对账（防半写重跑）。
- 取消用 cgroup.kill；空 = 目录在 + populated 0，不存在 = 目录被回收。

## 未批准
真实 Worker / 真实 SDK / 常驻部署 / 改 DSH Profile。

## 待验证（电脑离线中）
- `p3f4_kill_aba.py`：按 unit 名 kill 是否误杀同名新一代。
- launcher 对真实 systemd 的端到端冒烟。

## 学习笔记（2026-11-22 跟 GPT 学）
- 进程所有权与故障语义 → `~/.dsh/memory/notes/process-ownership-failure-semantics.md`（七条原则 P-01~P-07、五个 TOCTOU 窗口、六态证据表）。
- 现有代码缺口：PID+starttime 身份校验、pidfd、generation/fencing token、取消意图持久化顺序。
- 待办：WS-PROC-001（先设计，4 份材料 + 10 项故障注入）。

## p3f4 实验结论（2026-11-22 真跑）
- 同名 unit 两代：按 unit 名 kill **会误杀新一代**（B1/B2/B3 三场景全中）；InvocationID 前后不同但 kill 不认。
- 防御：unit 名含 invocation_id（已强制）、kill 前复核 InvocationID、优先 cgroup.kill、取消意图先落盘。
- 坑：`--scope` 的 unit 必须 `.scope` 且阻塞，detached 必须用 service 模式。

## 端到端（2026-11-22 22:2x 真跑）
- launcher spawn → cgroup 3 进程 → cancel → path gone，全通；kill 前 InvocationID 复核生效。
- **坑**：systemd 的 InvocationID 是它自己分配的，不等于我们的 invocation_id；必须在 spawn 后记录映射（`OwnershipRecord.systemd_invocation_id`），ABA 判断和 kill 复核都用它。

## IPC + 认领（2026-11-22 22:4x）
- 经 UDS 的 create/cancel 真跑通；新 Broker 启动即扫 jobs/ 认领旧 attempt。
- ANTI_REPEAT：ControlGroup 相对路径要拼 /sys/fs/cgroup（否则取消"空"是假阳性）；show 必须带 LoadState；spawn 后要回写 systemd InvocationID。
