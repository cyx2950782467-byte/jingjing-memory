---
id: 20261017-123051-miui-shell-apk-xspace
title: 本机是小米 MIUI，shell 装 APK 走 XSpace 异常
tags: android, miui, apk-install, maa-meow, gh-proxy
created: 2026-10-17T04:30:51.253Z
updated: 2026-10-17T04:30:51.253Z
---

设备：Android（arm64-v8a），MIUI（小米）。DSH 的 `shell` 工具在 ADB 密钥未授权时会"回落为本地执行"（非真 uid 2000），且 MIUI 下 `pm install` 会触发 com.miui.server.xspace.XSpaceManagerServiceImpl.getDefaultUserId → SecurityException(MANAGE_USERS/CREATE_USERS)，加 --user 0 也绕不过。

结论：在这台手机上给 Android 装 APK，命令行（pm install / am start INSTALL_PACKAGE）都不可靠。可复现路径 = 先用国内镜像 gh-proxy.com 把 release 文件完整下到 /sdcard/Download（GitHub 直连不稳、易 rc=56 中断），再让用户用文件管理器点文件走小米正常安装界面。

已装案例：明日方舟小助手 Android 版 MAA-Meow（Aliothmoon/MAA-Meow），最新版 v0.23.0，arm64 包 = MaaMeow-v0.23.0-arm64-v8a.apk（官方 207585737 字节 / 198MB）。MAA 官方（MaaAssistantArknights）只有桌面版，无官方手机版，手机只能装社区移植的 MAA-Meow。

另：这台设备没装任何语音插件，market 里也没有 ASR/TTS 插件；语音沟通只能用输入法键盘自带的麦克风转文字。
