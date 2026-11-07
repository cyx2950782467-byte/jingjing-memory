---
id: 20261104-205518-secure-boot-lockdown-nvidia-gpu
title: 根因：Secure Boot 的 Lockdown 拦住 NVIDIA 模块，关掉后 GPU 才启用
tags: NVIDIA, SecureBoot, Lockdown, 驱动, 性能瓶颈, TheForest, 2026-11-04, 鲸鲸
created: 2026-11-04T12:55:18.358Z
updated: 2026-11-04T12:55:18.358Z
---

## 2026-11-04 晚上：NVIDIA 驱动不加载的根因是 Secure Boot（Lockdown 模式）

### 现象
The Forest 跑起来后 CPU 占用 **206%**（两个核心跑满），`nvidia-smi` 报：
```
NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver
```
→ **游戏在用 CPU 软件渲染**（wined3d 没有硬件加速）。

### 根因（两层）
1. NVIDIA 驱动包**装着的**（`nvidia-driver-535 535.230.02`），模块文件也在
   `/lib/modules/5.15.0-139-generic/updates/dkms/nvidia.ko`
2. 但 `sudo modprobe nvidia` 报 **`Operation not permitted`**，dmesg 里：
   ```
   Lockdown: modprobe: unsigned module loading is restricted; see man kernel_lockdown.7
   ```
   → **BIOS 里 Secure Boot 开着**，内核自动进入 **Lockdown 模式**，
   只认 Canonical 官方签名的模块，连用 MOK key（`cyx-GI5CN54 Secure Boot Module Signature key`）
   签过名的 NVIDIA 模块也被拒。

### 解决
**进 BIOS → Security → Secure Boot → Disabled**，保存重启。
重启后：
```
lsmod | grep nvidia     → 有
nvidia-smi              → NVIDIA GeForce GTX 1050 Ti, 4096 MiB
```

### 教训（重要）
**NVIDIA 驱动"装了但不工作"，第一件事查 `lsmod | grep nvidia` 和 `dmesg | grep -i lockdown`**。
Secure Boot + Lockdown 是 Linux 上最常见的"NVIDIA 模块加载失败"原因之一，
症状看起来很像是"没装驱动"，但其实是被安全机制拦了。

### The Forest 的启动参数（Steam 242760）
写在 `~/.steam/debian-installation/userdata/489758604/config/localconfig.vdf` 的
`"242760"` 段里的 `LaunchOptions`：
- **GPU 正常时**：`DXVK_ASYNC=1 PROTON_NO_ESYNC=1 %command%`
- **GPU 不加载（软渲染）时**：`PROTON_USE_WINED3D=1 PROTON_NO_ESYNC=1 %command%`
  这个组合能救"崩在 `OPENGL32.dll`（RIP 0xffbfd947）"的情况

