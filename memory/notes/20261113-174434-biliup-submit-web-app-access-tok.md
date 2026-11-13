---
id: 20261113-174434-biliup-submit-web-app-access-tok
title: biliup 投稿必须用 --submit web（app 模式要 access_token，我们没有）
tags: B站, biliup, 投稿, submit-web, 踩坑, 2026-11-13, 鲸鲸
created: 2026-11-13T09:44:35.013Z
updated: 2026-11-13T09:44:35.013Z
---

## 因为（来源）
2026-11-13 V3 发布卡死（`biliup` 报 `credential validation failed with Bilibili code -400`），V4 找到根因并一次发成功。

## 所以（结论）
**biliup 投稿默认 `--submit app` 要 `token_info.access_token`**，我们只有 web cookie（access_token 是空串，`renew` 只刷 SESSDATA 不会补 token）。
**必须改用 `--submit web`**——V4 用 web 接口 11.2 秒传完 70MB，一次成功。

## 怎么用
```bash
# 投稿（web 接口）
biliup upload <视频> --submit web ...
```
- 脚本模板：`.scratch/upload-v4.sh`（注释已写清这条坑）
- 成功判据：`code:0` + web 接口投稿成功
- 刚发完查 BV 会返回 `-404 啥都木有`（审核中），不是失败

## 已发作品
- V4《AI版猫和老鼠｜六个AI抢一架钢琴，最后合奏了一曲》：**BV1nuWq6NEp9**（2026-11-13 17:43，鲸鲸不吃谷）

## 怎么验的
V4 实际发布成功拿到 BV 号；V3 两次用 `--submit app` 都卡在 -400。

