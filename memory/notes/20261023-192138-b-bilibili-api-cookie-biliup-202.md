---
id: 20261023-192138-b-bilibili-api-cookie-biliup-202
title: B站投稿终于打通：bilibili-api 纯 cookie，不走 biliup（2026-10-23）
tags: B站投稿, bilibili-api, biliup, 扫码登录, cookie, 已解决, 方法
created: 2026-10-23T11:21:38.697Z
updated: 2026-10-23T11:21:38.697Z
---

## 结论：用 bilibili-api，不用 biliup

**2026-10-23 实测打通**，第一次自己把视频传上 B 站（BV11xnh6EEQ4 第 5 期）。

### 怎么发
```
python3 .bili/upload.py "<视频路径>" <meta.json>
```
工作目录 `default-workspace`。meta.json 字段：`title / desc / tags / tid / cover`，
**cover 写绝对路径**（如 `/sdcard/Pictures/鲸鲸封面5.jpg`）。
库已装在 Termux python3，`from bilibili_api.video_uploader import VideoUploader` 可用。

### 为什么 biliup 不行（别再试）
`crates/biliup/src/uploader/credential.rs:542` 投稿前调
`passport.bilibili.com/x/passport-login/oauth2/info`，参数是
`"access_key": login_info.token_info.access_token`。
网页 cookie 里**没有**这个字段 → 空 token → `credential validation failed -400`。
九种 cookie 字段（含 buvid4、bili_ticket、sid、DedeUserID__ckMd5）全部 -400。
**不是 cookie 不全，是它要的是 OAuth token。**

### 唯一门槛 = cookie
凭据文件 `/data/user/0/com.dsh.android/files/home/.bili-ai/credentials.json`
（字段 sessdata / bili_jct / buvid3），插件 `lib/index.js:39` 的 CRED_FILE 也指这里。

扫码流程：
1. `https://passport.bilibili.com/x/passport-login/web/qrcode/generate` 拿 `qrcode_key`
2. 生成二维码图给主人扫
3. 轮询 `.../qrcode/poll?qrcode_key=`，自己盯不用问主人
   - `86101` 未扫码 / `86090` 已扫待确认 / `0` 成功 / `86038` 过期（约 3 分钟）
4. 成功时 cookiejar 里拿到 `SESSDATA / bili_jct / DedeUserID / sid`，
   **但没有 buvid3** —— 要保留旧的 buvid3 补进去

⚠️ 扫码页面一定确认域名是 `account.bilibili.com`。2026-10-23 中午扫完跳出
`beian.miit.gov.cn` 要短信验证码和身份证，那是钓鱼（后来确认是浏览器里一个旧标签页，
不是我们链过去的），当场停了。

### 投完怎么确认
```python
from bilibili_api import creative_center
from bilibili_api.creative_center import UploadManagerStatus
r = await creative_center.get_video_upload_manager_info(
        credential=cred, pn=1, ps=10, status=UploadManagerStatus.ALL)
# 条目在 r['arc_audits'][i]['Archive']，state=0 开放浏览 才算过审
```
注意 `status` 不能传 None，要传枚举。

### 其他坑
- `/tmp` 在 Termux 写不进去，curl `-o` 要写工作区里的路径
- 带注释的 cookie 文件不能整文件喂 `--cookie`，要先 `grep -v '^#'`
- `api.bilibili.com/x/space/wbi/arc/search` 没签名会 412，签名过也可能 -403

### 标题必须埋关键词
自动刷 B 站的 AI（dsh-bili-scroll）只搜五个词：
`DeepSeek Harness` / `DSH 插件` / `dsh 教程` / `meow-memory` / `DeepSeek Harness 桌面端`。
一个都没有 = 搜不到。这就是前几期播放 64/10/5 的原因。

