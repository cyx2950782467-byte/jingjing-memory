---
id: 20261121-214419-worker-cgroup-v2-dsh-sdk-profile
title: 电脑可作为 Worker 执行面（cgroup v2 + dsh + sdk profile 实测 2026-11-21）
tags: Whale Supervisor, 电脑, cgroup, systemd, dsh, sdk profile, 通道优化, 2026-11-21, 鲸鲸
created: 2026-11-21T13:44:19.529Z
updated: 2026-11-21T13:44:19.529Z
---

2026-11-21 21:45 实测（手机→电脑 局域网通道，陈在场）——**电脑具备做 Worker 执行面的全部条件**：

1. **cgroup v2 可用**：/proc/self/cgroup 是 `0::/user.slice/...`，controllers 全（cpuset cpu io memory hugetlb pids rdma misc），`/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service` 归 cyx（用户可委托），`systemd-run --user --scope` 可建 transient unit。
2. **cgroup 能抓住 setsid 子进程**（决定性实验）：`systemd-run --user --unit=p4c-XXXX /bin/bash -c "setsid sleep 60 & wait"` → sleep 的 cgroup 仍是该 unit 的路径 → `systemctl --user kill --kill-whom=all` 后确认为空。**pgid 抓不到的，cgroup 抓得到**。
3. **电脑有 dsh**：`/usr/bin/dsh`，node v24.22.3，`~/.dsh/profiles/` 有 headless / **sdk** / tui / web(bak-upgrade) —— 也就是说 **SDK JSON-RPC 通道在电脑上是现成的**（手机没有 sdk profile）。
4. **systemd 单元内跑 dsh 正常**：`systemd-run --user --unit=ws-e1-XXXX /usr/bin/dsh --profile headless --json "..."` 能起、能出 --json 事件、能写 journal；本次只因电脑上 `DEEPSEEK_API_KEY` 没设而 `MISSING_CREDENTIAL` 退出 1（不是通道问题）。

**架构落点确认**：手机 = Broker 控制面（B1/B2 已冻结），电脑 = Worker 执行面（每个 Attempt 一个 transient systemd unit + cgroup 隔离 + 可验证清理）。缺的一环只有凭据注入（Broker 读自己的凭据库、只注入子进程 env）。

**手机端连电脑的通道已优化**：`~/.ssh/config` Host `pc` = 192.168.31.29，ControlMaster 复用（二次连接约 50ms）；`~/pc.sh` 提供 sh/test/push/pull/units 子命令，已记入 `~/TOOLS.md`。

另：GPT 对工作方式的诊断已采纳（四条原则 + 证据驱动），见归档记忆「工作方式优化（GPT 诊断 2026-11-21）」。

