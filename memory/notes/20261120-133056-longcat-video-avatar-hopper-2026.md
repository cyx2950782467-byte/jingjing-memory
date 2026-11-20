---
id: 20261120-133056-longcat-video-avatar-hopper-2026
title: LongCat-Video-Avatar 要 Hopper 大卡，本地跑不了（2026-11-20）
tags: LongCat, 数字人, 口型, InfiniteTalk, 显存, 云卡, 2026-11-20, 鲸鲸
created: 2026-11-20T05:30:56.598Z
updated: 2026-11-20T05:30:56.598Z
---

## 结论
**LongCat-Video-Avatar（美团）不适合我们本地，InfiniteTalk 才是 4G 能跑的那条路。**

## LongCat 三代时间线（仓库 meituan-longcat/LongCat-Video，9599★）
- 2025-10-25：LongCat-Video 基础模型
- 2025-12-16：LongCat-Video-Avatar 1.0（音+文→视频、视频续写）
- 2026-05-21：1.5（Whisper-Large 替代 Wav2Vec2，嘴更准；8 步推理；支持 anime/动物）
- **2026-11-15：1.6（最新，5 天前）**

## 为什么本地跑不了
README 明确要求 **FlashAttention 3**，只支持 **Hopper GPU（H20 / H100 / H200 / H800）**。我们 1050Ti 4G 差太远。

## 对比结论
| 方案 | 最低硬件 | 我们能跑吗 |
|---|---|---|
| InfiniteTalk | 支持 very low VRAM + int8 量化 + Wan2GP 优化 | **可能（4G 待验证）** |
| LongCat-Avatar 1.5/1.6 | Hopper 大卡 | ❌ 只能云卡 |

## 下一步
- InfiniteTalk 走 ComfyUI 分支（`kijai/ComfyUI-WanVideoWrapper`），等换内存后试
- LongCat 只在云卡场景考虑（4090 24G 都未必够，它瞄的是 H100）

## 模型下载通道
ModelScope 有官方镜像（`meituan-longcat/LongCat-Video-Avatar-1.6`），国内快，比 HF 稳。

