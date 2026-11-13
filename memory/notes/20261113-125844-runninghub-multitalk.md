---
id: 20261113-125844-runninghub-multitalk
title: RunningHub 只剩 multitalk 一个可用工作流，图生视频做不了
tags: RunningHub, 云端ComfyUI, 图生视频, 踩坑, 2026-11-13, 鲸鲸
created: 2026-11-13T04:58:44.440Z
updated: 2026-11-13T04:58:44.440Z
---

2026-11-13 做《猫和老鼠》AI 改编短片时实测的结论（下次不用再试）。

## 能用的只有一个工作流
RunningHub 账号（key 在 `~/.dsh/runninghub.key`，余额约 1735 积分）**只有一个已知可用 workflowId**：
`2119227289866166273` = `WanVideo2_1_multitalk`（图片 + 音频 → 口型说话视频）。
- nodeInfoList：`[{nodeId:"133",fieldName:"image"},{nodeId:"125",fieldName:"audio"}]`
- 输出 **480×832 竖屏**，约 10-12 秒，**每次约 46-57 积分**（结算按实际耗时，settleMode POINT）
- 用法：先 `/task/openapi/upload` 拿 fileName，再 `/task/openapi/create`
- ⚠️ `~/rh.py` 的 `create()` **没把 apiKey 放进 body**（其他方法都放了），直接调会返回 `301 must not be null`。要自己拼：`rh._post("/task/openapi/create", {"apiKey": rh.KEY, "workflowId":..., "nodeInfoList":...})`

## 为什么做不了图生视频
- RunningHub API **只认 workflowId**，没有公开的工作流列表接口：`/api/ai-app/list`、`/api/workflow/list`、`/api/ai-app/list`、`/task/openapi/workflowJson` 全部 404 或 `403 TOKEN_MISSION`（要网页登录态）。
- 网页端有「标准模型 API」（Kling 3.0 i2v `¥0.52/次`、MiniMax-H3 等，id 是 SKU 数字如 `2019243340861870082`），但调用端点是 SPA 里 fetch 的，抓 `/call-api/api-detail/...` 的 HTML 拿不到参数（全 JS 渲染）。**要用得先在网页上建好自定义工作流拿到 workflowId**。

## 实测结果（质量不可用）
给 Claude 立绘（567×2273 透明 PNG）+ 10 秒钢琴音乐跑一次：
- 画面**只有开衫和裙子中段**，头完全不在画面里（1:4 竖长立绘按 9:16 被截断）
- 背景变成**未抠掉的洋红**（透明 alpha 在模型侧丢了）
- 三帧之间几乎没有动作（输入是音乐不是人声，模型不知道要干嘛）
- 证据：`default-workspace/tj/audio/rh-test-out.mp4`、`tj/.review/rh-sheet.jpg`

**结论**：RunningHub 现在这条路只适合「真人半身照 + 语音 → 数字人说话」，做不了双角色、无对白、横屏的闹剧动画。做那种动画走自建 PIL 管线（`tj/render.py`，2880 帧约 6.5 分钟，876ms/100帧）。
