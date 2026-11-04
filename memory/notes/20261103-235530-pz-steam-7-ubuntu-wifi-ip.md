---
id: 20261103-235530-pz-steam-7-ubuntu-wifi-ip
title: PZ 迁移完成但启动验证卡在 Steam -7（Ubuntu WiFi 丢 IP）
tags: PZ, 迁移, Steam, 验证, 网络, 2026-11-04, 鲸鲸
created: 2026-11-03T15:55:30.709Z
updated: 2026-11-03T15:55:30.709Z
---

## PZ 迁移的验证卡住了（2026-11-04 00:34）

### 迁移本身已完成且校验通过
- M.2 上文件：**47880 个 / 9.8G**，与源完全一致
- Steam 库配置：`libraryfolders.vdf` 里有 `"1" → /mnt/m2/SteamLibrary`
- `appmanifest_108600.acf`：`StateFlags "4"`（已安装）、`SizeOnDisk 10335862594`，与源一致

### 启动验证遇到的环境问题
试图用 `DISPLAY=:0 steam -applaunch 108600` 启动，Steam 弹：

```
错误代码：-7
服务器连接失败。服务器可能脱机，或者您当前没有与互联网连接。
```

**根因是 Ubuntu 的 WiFi 一度没拿到 IP**（`wlo1` 显示 connected 但没有 IPv4 地址，只有 tailscale0 有）。
用 `sudo dhclient -v wlo1` 重新拿 IP，成功拿到 `192.168.10.32`，外网 `baidu` 返回 200。

但 **Steam 服务器本身仍然连不上**（`-7`）。国内直连 Steam 经常这样，需要加速器/VPN，或者用**Steam 离线模式**。

### 明天陈验证启动的步骤
1. 打开 Steam（联网状态，必要时开加速器/VPN）
2. 看库列表里有没有 `/mnt/m2/SteamLibrary`
3. PZ 那栏如果显示"安装"→ 右键 → 属性 → 已安装文件 → **验证游戏文件完整性**
4. 能进主菜单 → **再删源目录**（`~/.steam/debian-installation/steamapps/common/ProjectZomboid`，9.8G）
5. 若 Steam 实在连不上：**离线模式**也能启动已下载的单机游戏

### 备注
- Ubuntu 的 WiFi 会间歇性丢 IP（`wlo1` connected 但没地址），这是个**反复出现的毛病**，值得单独查（`nmcli` 里看 DHCP、或者换驱动）
- 这台的网络现在只能靠 `dhclient wlo1` 手动救

