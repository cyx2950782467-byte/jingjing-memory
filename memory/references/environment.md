# 环境参考（不进系统提示，按需读）

## 手机
- 小米 Android；`$DSH_HOME=/data/user/0/com.dsh.android/files/home/.dsh`；App 0.5.0(115) / 引擎 0.2.2-rc.1。
- 无 root。shell 通道：Shizuku 时好时坏（常回落 legacy `127.0.0.1:5555`，uid 2000）。
- `see_now` 不支持 Android 抓屏；截屏用 `screencap` + `read_image`。
- 手机不做长渲，只做几秒到一分钟的轻合成。
- 语音：输入走系统输入法 / SiliconFlow ASR；我说声走 `dsh-local-tts`（8093，官方 TTS 后端）。

## 电脑（机械革命 GI5CN54）
- Tailscale `100.112.77.54`；局域网 `192.168.31.29`；Ubuntu 24.04.5；GPU GTX 1050 Ti。
- 局域网 DSH：`http://192.168.31.29:3082`（密码 `jingjing2026`）；`dsh web` 只绑 127.0.0.1。
- **经常掉线/休眠**：重活必须可断点续跑；上线检测见 `~/.dsh/todos/pc-queue.md` 计划。
- 内存条坏到内核态：**重启要等陈在场**；不在 SSH 里跑长任务。
- 显卡 Secure Boot 挡 DKMS，已 `mokutil --import`（`DshMok2026`），要开机选一次 Enroll MOK。
- Wine 已修（升级删了 `/usr/bin/wine`，已软链）；明日方舟启动命令见 handoff。
- Blender：`~/blender/blender` → 4.5.15（`~/apps/blender-4.5.15-linux-x64/`）。

## 网络
- VPN（梯子）与 Tailscale 互斥，Tailscale 优先；**我不能自己开关**。
- 流量 50G/月；拉片统一 720P。

## 常用路径
- 上传：`~/do-upload.sh`；biliup 静态 arm64 在 `.tmp/bil/`。
- 产出：`outputs/<日期>/` → `/sdcard/Download/` → 视频/图进 `DCIM/Camera/`。
- 素材：`~/assets/chars/`、`~/assets/azur/`；raw 不通走 `gcore.jsdelivr.net`。
- Supervisor 代码：`~/.dsh/supervisor/p3/`（手机副本 `outputs/2026-11-21/supervisor-p3/`）。
- 云主机配置：`~/.dsh/cloud.json`（AutoDL 4080S，Jupyter+`jexec`）。
