---
id: 20261029-101226-telescope-vpn-linux
title: 虚拟机装好后，Telescope VPN 可以挂在里面（解决 Linux 没有客户端的问题）
tags: 虚拟机, Telescope VPN, 代理, Linux, VT-x, 待办, 2026-10-29, 鲸鲸
created: 2026-10-29T02:12:26.522Z
updated: 2026-10-29T02:12:26.522Z
---

## 背景

陈 2026-10-29 早上提出：**虚拟机装好之后，Telescope VPN 可以挂到虚拟机里用。**

## 为什么这是解法

之前卡住的老问题：
- **Telescope VPN 没有 Linux 客户端**（只有 iOS / Android / Windows / macOS）
- 它也不提供订阅链接导出，所以没法在 Linux 上用别的客户端接
- 陈的主力电脑是 Ubuntu 20.04

装了 Windows 虚拟机之后：
- 在**虚拟机里跑 Telescope 的 Windows 客户端**
- 再把虚拟机配成**代理服务器**（HTTP/SOCKS），主机通过它上网
- 这样 Linux 就能借虚拟机用上 Telescope 的线路

## 注意

- **一台机器同时只能挂一个系统级 VPN**：虚拟机里挂了 Telescope，宿主机自己的 Tailscale 不受影响（不同网络栈），但**虚拟机内的 Tailscale 会断**。
- 代理只解决 TCP/UDP 应用层，**不影响宿主机自己的路由**。
- 陈的原话是「我的 telescope VPN 也可以挂上去了」——重点是他想解决 Linux 用不了 Telescope 的问题，不是要长期挂。

## 前置条件

虚拟机要能跑起来，前置是 **BIOS 里打开 VT-x**（2026-10-29 查到 i5-8300H 的 `/proc/cpuinfo` 里没有 `vmx` 标志，说明 BIOS 里关着）。VirtualBox 6.1.50 已装。

