---
id: 20261122-215657-zipzippipe-31-ai-cc-by-nc-sa-202
title: 形象库落地：ZipZipPipe 的 31 张 AI 娘原图 + CC BY-NC-SA 授权（2026-11-22）
tags: AI便利店, 形象库, ZipZipPipe, CC-BY-NC-SA, 授权, AI娘, WBI签名, B站API, 2026-11-22, 鲸鲸
created: 2026-11-22T13:56:57.958Z
updated: 2026-11-22T13:56:57.958Z
---

陈 2026-11-22 定：AI 便利店的形象库用 **ZipZipPipe** 画的 AI 娘原图，已拿到 31 张（147MB）存在 `~/assets/chars_cc/`，另复制到 `/sdcard/Download/ZipZipPipe_AI娘/`。

**作者与授权（每期必写）**：
- 作者 B 站 **ZipZipPipe**，UID **4168597**，5.6 万粉。
- 置顶授权声明：《【素材来源与使用声明】》 https://t.bilibili.com/1231980045693616162 —— **CC BY-NC-SA 4.0**：署名 + 非商业 + 同协议共享。另有 9-12 一条明说「不可以以任何形式商业化」。
- **鲸鱼娘/大肥鱼要双署名**：原角色 @上善无形 + 二创 @ZipZipPipe。
- 简介里必须写：形象 © ZipZipPipe（UID 4168597），CC BY-NC-SA 4.0，非商用；涉及大肥鱼另署 @上善无形。

**图片规格**：1152×2048 与 **3072×5504** 两种（后者是真正的高清，之前 1024×1536 那批可以退役了）。

**已知缺口**：Gemini 只有「Gemini 4 Hydrogen/Carbon/Argon」同框合集，MiniMax 只在四合一里，都没有单独立绘；8/5 首批 9 张、8/19 那 6 张是合集发布没逐张标注，按合集命名保留、没硬猜。

**关键技术教训（下次别再撞）**：B 站 `x/space/arc/search`、`x/space/wbi/arc/search`、`x/polymer/web-dynamic/v1/feed/space` 三个接口**不带 WBI 签名（w_rid）一律 412 / -403**；带上签名 + cookie 就能翻 14 页拿到 168 条动态、128 条带图。内置浏览器读 m 站动态是 JS 渲染，`browser read` 取不到正文，只能看到视频列表——所以批量取图必须走 API + WBI。这条已写进 `~/.dsh/SCENES.md`。

