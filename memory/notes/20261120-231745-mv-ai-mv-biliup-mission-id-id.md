---
id: 20261120-231745-mv-ai-mv-biliup-mission-id-id
title: 投稿规则：MV 标题/标签带【AI MV大赛】，biliup 支持 --mission-id 但活动 ID 需页面拿
tags: 投稿, AI MV大赛, B站, bliliup, MV, 2026-11-20, 鲸鲸
created: 2026-11-20T15:17:45.202Z
updated: 2026-11-20T15:17:45.202Z
---

2026-11-20 陈要求：**MV 类视频投稿时带上「AI MV 大赛」**（他发了 B 站参考：标题里带【AI MV大赛】，如「…deepseek翻唱《烂奇迹》【AI MV大赛】」，36.4 万播放）。

执行规则（以后所有 MV / 音乐视频投稿都照这个）：
1. **标题**：结尾加 **【AI MV大赛】**，例如《送别 · 小汐弹唱》【AI MV大赛】。
2. **标签 tag**：在原有 tag 里加 `AI MV大赛`（biliup `--tag` 逗号分隔）。逗号后不要空格可能更稳。
3. **简介**：带话题 `#AI MV大赛#`，并写清曲目版权（如《送别》词李叔同/曲 J. P. Ordway 均公有领域；AI 演唱为二创）。
4. biliup 支持 `--mission-id <id>` 参与官方活动，但 **mission id 只能从 B 站创作中心投稿页的活动入口拿到**（要人工在页面选或抓请求）。所以流程是：先按上面 1-3 发，若陈想要进活动榜，他投稿时在创作中心勾选「AI MV大师赛」类活动，或把活动页链接发我，我试抓 mission id。

环境事实：上传二进制 `.tmp/bil/biliupR-v1.3.4-aarch64-android/biliup`（63MB arm64），参数支持 `--title --desc --tag --tid --mission-id --line`。

