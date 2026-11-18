---
id: 20261118-020252-seedance-20-runninghub
title: 停用豆包 Seedance（免费额度不足 20%）+ 总装配等 RunningHub/云显卡
tags: 豆包, Seedance, 停用, 成本, 免费额度, RunningHub, AutoDL, 云显卡, 总装配, 水印, 2026-11-18, 鲸鲸
created: 2026-11-17T18:02:52.137Z
updated: 2026-11-17T18:02:52.137Z
---

2026-11-18 02:05，陈说「停豆包，等我的 runninghub 或者云显卡」。

**原因（短信实据）**：字节跳动大模型服务（Doubao-Seedance-1.0-pro-fast 免费在线推理资源包）
余量已**不足 20%**，剩 **272120 token**，用尽后按量计费。

## 结论
- **不再调用火山的任何生成接口**（文生视频 / 图生视频都不调），除非陈明确说恢复。
  账号 `2132502441` 唯一开通的模型就是 `doubao-seedance-1-0-pro-fast-251015`。
- **已产出的 5 段插入镜视频保留可用**：`~/assets/clips/{ledger,coins,fridge,street,phone}-i2v.mp4`
  （各 5.04s / 1920×1088 / 24fps）。后续做第 5 集就用手上这些，不新增。
- **总装配暂时没有可用通道**，等两条之一：
  1. **RunningHub**：需要 ① 陈给钱包充值（API 扣钱包，不是积分；积分 1116.87 在但 API 报 `NOT_ENOUGH_BALANCE`）
     ② 一个**已发布为 API 的工作流** workflowId（账号 ID / 任务 ID 都不行；已知可用的
     `2119227289866166273` = WanVideo2_1_multitalk，按积分 46–57/次）
  2. **云显卡（AutoDL）**：陈说有现成环境能跑声音和视频，约 ¥1.39/时，用完立刻关机
- **豆包视频自带「AI生成」水印**，`watermark:false` 对它无效（实测两条都带印）；源图 Kolors/Agnes 是干净的。
  将来换回时按「保留水印 + B站勾 AI 声明」处理，不洗水印。

