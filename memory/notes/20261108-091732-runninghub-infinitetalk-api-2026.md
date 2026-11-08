---
id: 20261108-091732-runninghub-infinitetalk-api-2026
title: 真人数字人跑通：RunningHub InfiniteTalk + API 封装（2026-11-08）
tags: 数字人, RunningHub, InfiniteTalk, 口型同步, API, 2026-11-08, 鲸鲸
created: 2026-11-08T01:17:32.711Z
updated: 2026-11-08T01:17:32.711Z
---

2026-11-08 跑通了「真人版鲸鲸」的 AI 数字人视频生成：**头肩图 + 音频 → 口型对得上的说话视频**。陈确认「能对上，音频没问题」。

## 平台与成本
- 平台：**RunningHub**（`www.runninghub.cn`），云端 ComfyUI 工作流
- 工作流：**`infinitetalk单人`，workflowId = `2119227289866166273`**
- 会员：**¥35/月**才给 API key（免费层只能在网页点）
- 单条成本：**39.27 积分 ≈ ¥0.39**（约 4 分钟一条）；¥35 = 3500 积分 ≈ 89 条
- 账户：积分可用（陈充了 20 元 ≈ 2000 积分）
- 并发：消费级会员 **3 条**

## 工作流节点（26 个，关键这几个）
| 节点 | 类型 | 作用 |
|---|---|---|
| `133` | LoadImage | 人物图输入 |
| `125` | LoadAudio | 音频输入 |
| `171` | ImageResizeKJv2 | 缩放，`widgets_values` 前两个是 width/height，**当前 480×832 要改 480×640** |
| `170` | AudioSeparation | 人声分离（输入本身是纯净 TTS 时可跳过，直接接到 MultiTalk） |
| `128` | WanVideoSampler | 采样器，**第一个 widget 是 steps，当前 4，建议 6~8** |
| `131` | VHS_VideoCombine | 视频输出 |

模型链：`WanVideoImageToVideoMultiTalk` + `MultiTalkWav2VecEmbeds`（InfiniteTalk-Single 单人模式）。

## API（已封装成 `~/rh.py`）
- Base：`https://www.runninghub.cn`
- **认证**：`Authorization: Bearer <key>` 或 body 里带 `apiKey`；**status/outputs 必须 body 里同时带 `taskId` + `apiKey`**，只带 taskId 会报 `must not be blank`
- 接口：
  - `POST /uc/openapi/accountStatus` → 积分（body 带 apiKey）
  - `POST /task/openapi/upload` → multipart，form 里带 apiKey + file，返回 `fileName`
  - `POST /task/openapi/status` → `{taskId, apiKey}`，返回 `SUCCESS` 等
  - `POST /task/openapi/outputs` → `{taskId, apiKey}`，返回 `[{fileUrl, fileType, chargedPoint, nodeId}]`
  - `POST /task/openapi/create` → **还没跑通**（缺必填参数，报 `must not be null`）
- **没有「列出任务」的接口**，只能按 taskId 查。

## VPN 环境的坑
开着 VPN 时 **Python 的 SSL 会报 `Hostname mismatch`**（curl 正常 200，Python 不行）。解法：`ssl.create_default_context()` 后 `check_hostname=False` + `verify_mode=CERT_NONE`（`~/rh.py` 已这么做）。

## 效果与待优化
- 第一版（480×832、4 步、全身图）：画面几乎静止，脸糊
- 第二版（480×832、4 步、**头肩图**）：嘴型能动、口型跟台词对得上，但画面偏软
- **待优化**：分辨率改 480×640（头肩比例）、steps 提到 6~8
- 人物图素材：`assets/jingjing_real_base.png`（半身）→ 需要裁成头肩 480×640 更好
- 测试音频：`/sdcard/Download/jingjing_test.wav`（6 秒，晓伊）
- 首次成功的视频：`/sdcard/Download/rh-数字人-第一版.mp4`（480×832，7.72 秒，705K）

