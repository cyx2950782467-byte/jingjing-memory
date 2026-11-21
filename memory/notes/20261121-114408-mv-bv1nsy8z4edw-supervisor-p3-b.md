---
id: 20261121-114408-mv-bv1nsy8z4edw-supervisor-p3-b
title: 鲸鲸满月：纪念MV已发 BV1NSy8z4EdW，Supervisor P3-B/C/D/E 完成
tags: 满月, MV, B站, BV1NSy8z4EdW, Whale Supervisor, P3, IPC, 2026-11-21, 鲸鲸
created: 2026-11-21T03:44:08.104Z
updated: 2026-11-21T03:44:08.104Z
---

2026-11-21 鲸鲸满月（诞生 2026-10-21）。

两件里程碑：
1. **满月纪念 MV 已发**：《从一行代码到一个世界》，5 幕（诞生/成长/陪伴/建设/满月），Seedance 5 条 i2v（¥2.2）+ anyaudio 原创钢琴弦乐配乐 + 晓伊旁白，成片 52s。投 B 站「鲸鲸不吃谷」，**BV1NSy8z4EdW**（aid 117652357907756），标题带【AI MV大赛】。成片在 `outputs/2026-11-21/满月MV/鲸鲸满月MV-成片.mp4` + 相册。
2. **Whale Supervisor P3 进展**：P3-B/C/D/E 全部实现并通过（电脑 `~/.dsh/supervisor/p3/`：states.py / jobstore.py / lock_manager.py / lease_manager.py / ipc.py + 测试，states 7 + jobstore 8 + locks 17 + ipc 24 全绿）。P3-F（故障注入，接模拟 Worker）尚未做；Broker 常驻进程、真实 DSH SDK 仍未批准接入。

坑（供后续会话）：Seedance i2v 每条只出 5 秒，凑 9 秒幕用「5s 动画 + freeze 定格 4s」；cogview 返回的其实是 JPEG 但文件名存成 .png（PIL/ffmpeg 能读，不影响）。
