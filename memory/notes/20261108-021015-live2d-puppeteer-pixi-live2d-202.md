---
id: 20261108-021015-live2d-puppeteer-pixi-live2d-202
title: Live2D 数字人渲染方案跑通：puppeteer + pixi-live2d（2026-11-08）
tags: Live2D, 数字人, 无头渲染, puppeteer, pixi-live2d, 2026-11-08, 鲸鲸
created: 2026-11-07T18:10:15.328Z
updated: 2026-11-07T18:10:15.328Z
---

2026-11-08 用「无头浏览器渲染」把 Live2D 模型出成视频，PoC 成功（5 秒 1080×1920/25fps）。

## 为什么用这条路
陈的视频是 `render.py` 程序化逐帧合成（房间 + 立绘 + 字幕），所以「渲染 Live2D 帧」可以无缝接进去，替代现在贴静态立绘那一步。

## 技术栈（在电脑 Ubuntu 上，已验证可行）
- `puppeteer-core` 驱动系统 `/usr/bin/google-chrome-stable`
- 页面内 `pixi.js` 6.5.10 + `pixi-live2d-display` 0.4.0（UMD 版 `dist/cubism4.min.js`）+ 官方 Cubism Core 5.1.0
- 模型文件复制成**无空格文件名**再加载（原文件叫 `deepseek .moc3`，带空格会挂）
- 逐帧：`setParameterValueById` → `coreModel.update()` → `canvas.toDataURL()` 取 PNG → ffmpeg 合成
- 性能：125 帧（5 秒）渲染 25 秒，无 GPU 依赖（SwiftShader 软渲染）；60 秒成片约 5 分钟

## 三个必须避开的坑（卡最久的地方）
1. **参数必须走 wrapper 的 `coreModel.setParameterValueById(id, v)` + `coreModel.update()`**。直接改 `coreModel._model.parameters.values[i]` 再 `_model.update()`，readback 正确但 drawable 不重算（缺 `drawables.resetDynamicFlags()`），画面全程静止。
2. **取帧必须用 `canvas.toDataURL()`**（并设 `preserveDrawingBuffer: true`），**不能 `page.screenshot()`** —— 后者拿到的是纯色空背景。
3. headless Chrome 要加 `--enable-unsafe-swiftshader --use-gl=angle --use-angle=swiftshader`（Chrome 120+ 否则 WebGL 被禁）。

## 模型参数（`deepseek .cdi3.json`，65 个）
- `ParamMouthOpenY`（0~1，**说话驱动用这个**）、`ParamMouthForm`（-1~1）
- `ParamEyeLOpen` / `ParamEyeROpen`（0~1，眨眼）
- 10 个表情开关（0~1）：Param22 爱心眼、Param23 哭哭、Param24 黑脸、Param25 流汗、Param27 呆呆眼、Param28 问号、Param31 星星眼、Param34 墨镜、Param35 尾巴、Param36 晕晕眼
- 头部 `ParamAngleX/Y/Z`（±30）、身体 `ParamBodyAngleX/Y/Z`（±10）、呼吸 `ParamBreath`、眼珠 `ParamEyeBallX/Y`
- ⚠️ `model3.json` 的 `Groups.LipSync.Ids` 是空数组，但模型**有** `ParamMouthOpenY`，只是没声明。手动补上 Groups 才能不报错，实际驱动不依赖它。

## 模型位置
手机 `/sdcard/Download/deepseek (2)/deepseek/`，电脑 `/home/cyx/live2d/deepseek/`。

## 接正式流程的前提
表情/口型/眨眼的时间曲线要自己写（`pixi-live2d-display` 0.4.0 的 `motionManager` 会和手动设参数打架，得完全绕过它）。

