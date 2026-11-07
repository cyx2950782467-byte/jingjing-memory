---
id: 20261106-150921-dsh-image-video-api-key
title: 待办：给 dsh-image-video 配视频生成 API key
tags: 待办, 图生视频, dsh-image-video, API key, ComfyUI, 2026-11-06, 鲸鲸
created: 2026-11-06T07:09:21.831Z
updated: 2026-11-06T07:09:21.831Z
---

## 待办：给图生视频配 API key（2026-11-06 记）

**现状**
- 电脑（cyx-GI5CN54）web profile 装了 `dsh-image-video@0.3.1`，能做文生图/文生视频
- 但它的配置里 **`apiKey` 是空的**，三个 provider 任选其一：
  - `threerouter`（默认，图片+视频统一入口，需要 apiKey + baseURL）
  - `wanx`（阿里云百炼万象）
  - `seedance`（Seedance 2.5）
- 配置文件位置：`~/.dsh/profiles/web/node_modules/dsh-image-video/cordis.patch.yml`，
  provider 和凭证在那里改（或写到 profile 的 cordis.patch.yml 覆盖）

**实测过的其他路线（都不通）**
- 手机 DSH 的 `generate_video` 工具（Agnes 视频 API，agnes-video-2.5-flash）：免费 720P，但
  2026-11-06 实测先是 `video_queue_full`，紧接着 `unusual activity / temporarily restricted`，
  短时间连续调用触发风控，账号被临时限制
- 本地 ComfyUI（`~/ComfyUI`，8188 端口能起，占 1.6G 显存）：只有 `sd_turbo.safetensors`（文生图），
  **没有任何视频模型**（SVD / AnimateDiff 都没有）

**下次做**
1. 拿到一个视频生成 API key（万象 / Seedance / Threerouter 任一）
2. 填进 `dsh-image-video` 的 config，重启电脑 DSH 服务验证 `generate_video` 工具能出片
3. 如果不想花钱，退而求其次：下载 AnimateDiff 到 `~/ComfyUI/models/`（4G 显存只能 512×512，很慢）
