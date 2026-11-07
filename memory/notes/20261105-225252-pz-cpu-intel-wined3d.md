---
id: 20261105-225252-pz-cpu-intel-wined3d
title: 舟比 PZ 更吃 CPU 的根因：跑在 Intel 核显 + wined3d 软件翻译
tags: 明日方舟, Wine, 核显, DXVK, 性能, 2026-11-05, 鲸鲸
created: 2026-11-05T14:52:52.927Z
updated: 2026-11-05T14:52:52.927Z
---

## 舟比 PZ 更吃 CPU 的根因：核显 + wined3d（2026-11-05 子代理实测）

陈发现「跑明日方舟风扇比 PZ 还响」，子代理实机抓到数据，根因清楚：

### 对比
| 项目 | 明日方舟 | Project Zomboid |
|---|---|---|
| 渲染器 | **Intel UHD Graphics 630（核显）** | NVIDIA GTX 1050 Ti |
| 图形 API | Direct3D 11 | OpenGL 4.6 |
| 翻译层 | **Wine 自带 wined3d**（D3D11→OpenGL，CPU 翻译） | 无（OpenGL 直通） |
| prefix 里的 d3d11.dll | 4.5MB（Wine 原版，**没装 DXVK**） | 6.7MB（DXVK） |
| 启动参数 | 干净的（**没有 PRIME 变量**） | 有 `__NV_PRIME_RENDER_OFFLOAD=1` 等 |

### 实测数据（舟在主界面时）
- NVIDIA：**0% 利用率、22MiB 显存、P8 最低档、139MHz**（在睡觉）
- 核显：中断 **988 次/秒**，频率锁死 1000MHz（上限）
- CPU：Arknights.exe **161%** + 启动器 Games.exe **86%** + QtWebEngineProcess **67%** ≈ **320%**
- 8 核全 3.83GHz、**78°C**、load 7.57 → 风扇必然高速

### 三个根因（按贡献）
1. **舟落在核显上**：prime-select 是 on-demand 且舟没设 PRIME 变量 → 默认 UHD 630
2. **wined3d 的 CPU 翻译**：每个 D3D11 draw call 都要翻译成 OpenGL，2D 手游 draw call 密度极高
3. **启动器 CEF 常驻**：Games.exe + QtWebEngineProcess 合计 153%，进游戏后还在跑

### 解法
1. **重启让 prime-select nvidia 生效**（已做，2026-11-05 晚）→ 舟自动用独显
2. **给舟装 DXVK**：`WINEPREFIX=/mnt/m2/arknights/prefix bash setup_dxvk.sh install`（把 wined3d 换成 D3D11→Vulkan，CPU 开销低一个数量级）
3. 关掉启动器的 CEF 进程（有风险，可能影响游戏内公告）

### 顺带纠正
- **Wine 实际版本是 10.6 staging**，不是之前记的 11.19
- 舟的桌面快捷方式启动的是**鹰角启动器 lnk**，不是直接跑 Arknights.exe

