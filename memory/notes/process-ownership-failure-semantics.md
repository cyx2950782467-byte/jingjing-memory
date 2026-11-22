# 进程所有权与故障语义（2026-11-22 学自 GPT，落成 WS-PROC-001 待办）

## 核心四分离（最容易混）
进程身份（PID+starttime 是同一实例吗）／进程归属（属于哪个任务边界=cgroup）／进程生命周期（还活着吗）／任务结果（成功失败取消）。**一个 PID 是否存在、一个 cgroup 是否为空，回答不了全部四个。**

## 归属来源与优先级
- cgroup v2 = 当前归属权威（但非不可变历史所有权：子进程 fork 继承、可迁移、procs 读取非原子快照）。
- systemd unit（ControlGroup + InvocationID + ActiveState/SubState/Result/MainPID）= 管理边界；**MainPID ≠ 全部进程**。
- pidfd > PID+starttime > PGID/SID > PPID。pidfd 防 PID 复用误杀；PGID/SID/PPID 只作辅助，不作所有权依据。
- 交叉验证原则：多来源冲突时进 ambiguous，不要选一个覆盖另一个。

## 「进程不在了」≠「任务失败」分类表（映射到六态）
- Worker 正常退出+结果已持久化 → 成功/失败终态（不是 exited_unknown）
- Worker 正常退出+无结果 → exited_unknown
- 收到取消、仍在清理 → cancel_pending；取消完成+清理证据 → stopped
- SIGKILL → exited_unknown 或 cancel_pending（业务结果不明）
- OOM → exited_unknown + OOM 证据
- 主进程退、子进程还在 → owned_live 或清理中
- cgroup 空但无结果 → exited_unknown（**空≠完成**，僵尸也不计 procs）
- 只剩 zombie → 不认为仍在执行，别向僵尸发 SIGKILL
- unit 同名但 InvocationID 不同 → 不认领旧 attempt
- cgroup 读取失败 → ambiguous

**lost / ambiguous / exited_unknown 三态不混用**：
- lost = 对象/管理关系丢失、无法恢复
- ambiguous = 对象可能存在但证据互相矛盾
- exited_unknown = 执行实例已结束但结果未知

## 孤儿/僵尸/收养/double-fork（cgroup v2 + KillMode=control-group）
四者描述不同维度，不互斥；**关键：fork/setsid/double-fork 都不脱离 cgroup**，所以 KillMode=control-group 都能清理。
- 孤儿：父退子留，仍在 cgroup → 能清。
- 僵尸：已退出待 wait 回收，**不计入 cgroup.procs**；别当活跃、别 SIGKILL，靠 subreaper/init 回收。
- 被 PID1 收养：只变父子关系，不脱离 cgroup；「PID1 是父」≠「PID1 是 unit 管理者」。
- double-fork：脱离父子/会话/进程组，但不脱离 cgroup → 仍在管理范围。
- 前提：进程没被有权限的进程迁移出 cgroup；若要把 cgroup 当硬边界，得从权限上禁止 Worker 迁移自己。

## 五个 TOCTOU 危险窗口
1. 先查 PID 再发信号 → pidfd / PID+starttime 复核。
2. 先查 cgroup 空再决定不清理 → 启动/取消串行化 + 唯一 unit 名。
3. 发了 SIGTERM 就以为取消完成 → 要等停止流程 + 清理证据。
4. cgroup 空就立刻起新 attempt（最危险）→ 旧取消意图先持久化 + 结果结算 + fencing/幂等键，B 启动要过认领检查。
5. Supervisor 重启后按旧 PID 认领 → 恢复时重验 attempt/unit/InvocationID/ControlGroup/cgroup成员/进程身份/取消意图。

## 七条原则 P-01~P-07
P-01 cgroup=归属主依据｜P-02 unit=管理边界｜P-03 PID 必做实例身份校验｜P-04 PGID/SID/PPID 不单独证所有权｜P-05 进程退出≠任务失败｜P-06 取消=持久化+停止+清理+结算｜P-07 新 attempt 必须过旧 attempt 认领与清理检查。

## 对现有代码的差距（ownership.py / launcher.py）
已有：六态、InvocationID、manager_generation、cgroup 判空（populated）、terminal_idempotency_key(=attempt_no)。
**缺**：① PID+starttime 身份校验 ② pidfd ③ generation/fencing token 落到外部写端 ④ 取消意图先持久化再 kill（launcher.cancel 现在先 kill 后判，意图靠上层写——需确认顺序）。

## WS-PROC-001 交付（先设计不写代码）
process_ownership.md / failure_semantics.md / process_cleanup.md / cancellation_recovery.md
+ 10 项故障注入：主退子留 / setsid double-fork / 留 zombie / subreaper 收养 / 持久化取消意图后崩溃 / SIGTERM 后崩溃 / SIGTERM 拒绝退出 / PID 复用 / unit 态与 cgroup 态不一致 / 双 supervisor 抢认领。

## 一句话原则（写进 Supervisor 架构）
「任何无法证明旧 Attempt 已失去执行能力、且不会再提交有效副作用的情况，都不得仅凭 PID 消失或 unit 名变化，认定可以安全启动新 Attempt。」
