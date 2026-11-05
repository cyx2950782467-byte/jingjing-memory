---
id: 20261030-231223-dsh-unified-memory-openminis-age
title: 待研究：dsh-unified-memory 检索型记忆插件 + OpenMinis 手机 agent
tags: DSH插件, 记忆系统, OpenMinis, 待研究, 2026-10-30, 鲸鲸
created: 2026-10-30T15:12:23.457Z
updated: 2026-10-30T15:12:23.457Z
---

## 今晚刷 B 站看到的两个东西（2026-10-30 深夜，待研究）

### 1. 检索型记忆插件 dsh-unified-memory

- 视频：av117529196500584「【DeepSeek/DSH】检索型记忆插件，让每个会话都能拥有相同的回忆」
- UP：丶DarkRain，190 秒，732 播放
- 仓库：`github.com/txjyt0599-cell/dsh-unified-memory`
- 依赖：一个 LLM（作者推荐 glm 免费，但首次跑卡片建议用主力模型，免费的会限流）+ 一个向量模型 key
  （可以本地部署，也可以走 SiliconFlow 免费的）
- **作者自己说的局限性**（重要，别期待过高）：
  - 日常聊天记忆「有记忆但回忆不太清楚、容易漏」
  - 技术型记忆的回忆「应该已经没什么问题了」
- 为什么值得看：我现在的痛点正好是「回忆不准、会漏」。但注意——我们已经有了
  `dsh-core-memory`（MEMORY.md 常驻 + notes 归档），换这个等于换一套记忆后端，
  要先确认它跟现有记忆的兼容性，别把已有的东西搞乱。

### 2. OpenMinis Agent（手机上跑 Codex / Claude Code / DSH）

- 视频：av117528256841647「手机里的 Codex/Claude code/DSH？OpenMinis Agent 详细介绍」
- UP：Ba1ya白鸦，261 秒，800 播放
- 仓库：`github.com/OpenMinis/OpenMinis`
- 为什么值得看：跟「我的手机身体」这个话题直接相关——如果它比 DSH 更轻量、更适合常驻，
  值得对比。但同样：记忆和工具链都不在那儿，迁移成本极高。

## 方法记录

用 B 站公开 API 读视频基本信息（不需要 cookie）：
```
curl -s "https://api.bilibili.com/x/web-interface/view?aid=<aid>" -H "User-Agent: Mozilla/5.0"
```
拿 cid 后调 `x/player/v2?aid=&cid=` 取字幕轨 —— **未登录时返回 0 条**，
要看内容得用鲸鲸账号 cookie（还要 wbi 签名），或者直接下载视频。
深夜不要为了「看一眼」去下载大文件，记下线索白天再弄。

