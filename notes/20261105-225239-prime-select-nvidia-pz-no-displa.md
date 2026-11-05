---
id: 20261105-225239-prime-select-nvidia-pz-no-displa
title: prime-select 切 nvidia 后桌面变快，但 PZ 报「No displays available」打不开
tags: PZ, prime-select, NVIDIA, 故障, 未解决, 2026-11-05, 鲸鲸
created: 2026-11-05T14:52:39.063Z
updated: 2026-11-05T14:52:39.063Z
---

## prime-select nvidia + PZ 新故障「No displays available」（2026-11-05 晚）

### 做了什么
为查外接屏卡顿，把 `prime-select` 从 `on-demand` 切成 `nvidia`（独显主控），重启后：
- **桌面明显变快**（陈原话：「现在快得一逼呀」）
- 整个 Xorg 由 NVIDIA 驱动（不再 Intel 主控 + PRIME 拷贝）

### 带来一个新问题：PZ 打不开了
Steam 日志：
```
[ERROR] FATAL UNHANDLED EXCEPTION: System.ApplicationException: No displays available
[ERROR] Game Recording - game stopped [gameid=108600]
```

**已排除**：
- Steam 环境变量正常：`DISPLAY=:1`、`XAUTHORITY=/run/user/1000/gdm/Xauthority`
- X11 socket 存在：`/tmp/.X11-unix/X0`（gdm）、`X1`（cyx 用户，`:1` 是对的）
- Xorg 进程正常：PID 2546，`-auth /run/user/1000/gdm/Xauthority`
- 去掉 PZ LaunchOptions 里的 PRIME 变量（`__NV_PRIME_RENDER_OFFLOAD=1` 等）后**仍然报错**

**下次从这里查**：
1. Steam 自己的 X11 检测逻辑（`No displays available` 是 Steam 抛的，不是 PZ）
2. prime-select nvidia 后 NVIDIA 驱动的 `AllowEmptyInitialConfiguration` 之类配置
3. 或者试着用 `DISPLAY=:0`（gdm 那个 X0）
4. 兜底：切回 `prime-select on-demand`（桌面慢一点但 PZ 能跑）

**当前状态**：桌面快但 PZ 打不开，需要权衡。
