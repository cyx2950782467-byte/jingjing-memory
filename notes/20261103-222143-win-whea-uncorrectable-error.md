---
id: 20261103-222143-win-whea-uncorrectable-error
title: 外挂 Win 盘蓝屏：从驱动问题转向硬件判断（WHEA_UNCORRECTABLE_ERROR）
tags: 蓝屏, WHEA, 硬件, 外挂盘, USB, 诊断, 2026-11-03, 鲸鲸
created: 2026-11-03T14:21:43.686Z
updated: 2026-11-03T14:21:43.686Z
---

## 2026-11-03 深夜：外挂 Win 盘反复蓝屏的诊断转折

### 蓝屏代码（两次）
1. **`0x0000013A`**（KERNEL_MODE_HEAP_CORRUPTION，8-21 的历史记录）
   —— 内核堆损坏，通常是驱动 bug
2. **`WHEA_UNCORRECTABLE_ERROR`**（今天 22:19 拍的屏）
   —— **硬件级错误**，CPU/内存/PCIe/USB 控制器在硬件层报错

### 已做过但没解决的事
- 卸 AMD 显示适配器（设备管理器 + pnputil）
- 停并禁用 `AMD External Events Utility` 服务
- 清理 C 盘临时文件（剩 3.7G → 6G）
- 卸载后仍然蓝屏

### 判断转折（重要）
`WHEA_UNCORRECTABLE_ERROR` 是硬件信号，**说明「卸 AMD 驱动」这条路的优先级错了**。
最可能的真因：
1. **USB 硬盘盒桥接芯片（JMicron Tech）不稳定** —— 外挂盘跑系统本身就很勉强
2. **USB 供电不足** —— 笔记本 USB 口带不动 2.5 寸 SSD
3. **内存问题** —— 16G 是 11-02 新换的，从没跑过 memtest

### 下一步该试的（按成本排序）
1. **换 USB 口**（优先左侧 USB 2.0 黑色口，供电更稳）
2. 换硬盘盒
3. 把盘装进机器内部 SATA 位（如果有）
4. 跑 memtest86+

### 环境备注
- 外挂盘：JMicron Tech USB，MBR，C: 60G / D: 122.2G / E: 0.5G FAT32 / P4 39.8G
- Ubuntu 盘（Netac SATA）：GPT，P2 116.4 ext4、P3 106.6 ext4
- M.2（Netac N930E-PRO）：在 Win 下显示 RAW（ext4 不被识别，正常）
- Win 已启用 OpenSSH Server（AUTO_START），手机公钥已配置，SSH 免密可用
- dsh 安装被蓝屏打断，子代理已用「改名完整包」修好，计划任务 `DSH-AutoStart` 已建（SYSTEM 身份，读不到 Administrator 配置）

