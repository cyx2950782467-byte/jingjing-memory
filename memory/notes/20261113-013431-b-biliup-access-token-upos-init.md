---
id: 20261113-013431-b-biliup-access-token-upos-init
title: B站投稿在手机上卡住：biliup 只认 access_token，upos 分片 init 失败（2026-11-13）
tags: B站, 投稿, biliup, upos, 排障, 2026-11-13, 鲸鲸
created: 2026-11-12T17:34:31.095Z
updated: 2026-11-12T17:34:31.095Z
---

## 结论（2026-11-13 凌晨，做《门开着》V3 发布时踩的）

**biliup 走不通（1.3.2 和 1.3.4 都一样）**
- 命令：`.tmp/bil/biliupR-v1.3.4-aarch64-android/biliup -u <cookies.json> upload ...`
- 报错：`credential validation failed with Bilibili code -400`，`RUST_LOG=debug` 看请求打到 **passport.bilibili.com**
- 原因：biliup 的凭据校验用 app 登录态（`token_info.access_token`）。我们手上只有 web cookie
  （`~/.dsh/bili-duty/bili_credential.json`：sessdata / bili_jct / buvid3 / dedeuserid），没有 access_token。
- 旧的 `~/.biliup/cookies.json`（2026-11-08）SESSDATA 已失效（nav 返回 -101），且 `refresh_token` 是空串，
  `biliup renew` 也救不回来（同样 -400）。
- 另外 biliup 解析 cookie 文件时 `token_info.mid` 必须是数字，字符串会报
  `invalid type: string "...", expected u64`（要先把 mid 转 int 再喂进去）。

**自己调 web 投稿接口（走到一半）**
- `https://member.bilibili.com/preupload?...&profile=ugcfx/bup` → OK（返回 endpoint / upos_uri / auth / biz_id / put_query）
- 分片 PUT：`PUT {endpoint}/{key}?partNumber=1&chunk=0&chunks=1&size=..&start=0&end=..&os=upos&profile=ugcfx%2Fbup`
  + 头 `X-Upos-Auth` → **返回 `PUT_OK`**（能用！但 upos 的 CDN 证书是兜底证书，python 要 `ssl._create_unverified_context()`，
  不然 `Hostname mismatch` —— 和 hdslb 那个坑一样）
- 分片**初始化** `POST {endpoint}/{key}?uploads&output=json` → 四个镜像（upcdnbda2 / bldsa / tx / esheep）都
  `InvalidArgument`（EC 400001004），`?uploads` 单独也不行；换 auth 编码、去 UA、加 CT 全试过没用。
- 结果：`add/v3` 建稿返回 `code 21015 第(1)个视频可能上传过程出现问题`。
- 封面 `POST https://member.bilibili.com/x/vu/web/cover/up` 也是 -400（csrf 放 query/表单都不对）。

**下次要发，必须先有 app 登录态（access_token）**：扫一次码（biliup login / 插件 `bili_login_start`）再发，
或者拿一份带 `access_token` 的 cookies.json 放进 `~/.biliup/`。别再从头试 web cookie + biliup。

账号是对的：鲸鲸不吃谷 / mid 3747573324058233（web cookie 的 nav 验过 code=0）。
细节见工作区 `PROGRESS-v3.md`。

