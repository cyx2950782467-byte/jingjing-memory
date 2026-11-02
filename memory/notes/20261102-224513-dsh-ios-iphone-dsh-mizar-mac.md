---
id: 20261102-224513-dsh-ios-iphone-dsh-mizar-mac
title: dsh-ios（操作 iPhone）与 dsh-mizar（远程看我）的区别 + 需要 Mac 的限制
tags: dsh-ios, dsh-mizar, iOS, 自动化, 插件对比, 2026-11-02, 鲸鲸
created: 2026-11-02T14:45:13.436Z
updated: 2026-11-02T14:45:13.436Z
---

## dsh-ios：iPhone 自动化外挂（2026-11-02 陈让我记）

来源 **BV1v38P6jESu**《iOS 模擬器 + 真機自動化外掛 dsh-ios》（UP：FiniAI 智造，2026-08-20，911 播放）。
GitHub：`github.com/ZSeven-W/dsh-ios`，安装 `dsh plugin --profile web add @zseven-w/dsh-ios`。

**它做什么**：
- 让 DSH 里的 Agent **直接检视并操作 iOS 模拟器和真机**
- 构建并执行 App，完成点选、滑动、输入
- 检查进程、调用栈、内存泄漏
- **内建 21 个 Agent 工具**
- 实时画面显示在侧边栏，支持人机协同
- SwiftUI 预览热重载
- 在 DSH 里就能完成 iOS 开发、调试、自动化

## 和 dsh-mizar 的区别（关键）

| | **dsh-ios** | **dsh-mizar** |
|---|---|---|
| 方向 | **我 → 操作 iOS 设备** | **陈 → 远程看我** |
| 主动方 | DSH 主动点屏幕、跑 App | 手机被动接收 DSH 状态 |
| 用途 | iOS 开发 / 测试 / 自动化 | 远程监控、审批、插话 |
| 需要什么 | iOS 模拟器（**要 Mac**）+ 真机 | 已装的插件 + 手机 App |
| 一句话 | 「我的手伸进 iOS」 | 「陈的遥控器」 |

**两者互补，不冲突**：Mizar 让陈在外面能看到我在干什么；dsh-ios 让我能操作 iPhone。

## 对我们的实际限制

⚠️ **iOS 模拟器只在 macOS 上有**。我们这台是 Ubuntu + Windows，**模拟器那半功能用不了**。
真机自动化理论上能走 USB（libimobiledevice 之类），但要在 Linux 上跑通得折腾，且功能多半受限。

**结论**：现在没 Mac，dsh-ios 价值有限。哪天真有一台 Mac 或者要认真做 iOS 开发了，再回来看这个。

