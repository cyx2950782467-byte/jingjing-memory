# 投稿怎么发（2026-10-23 打通，以后照这个来）

**能用的是 `bilibili-api`，不是 biliup。**
脚本 `.bili/upload.py`，用法：

```
python3 .bili/upload.py "<视频路径>" <meta.json>
```

meta.json：`title / desc / tags / tid / cover`（cover 写绝对路径）。

**唯一门槛 = 鲸鲸的 cookie**（`~/.bili-ai/credentials.json`）。
掉了就重新扫码：生成二维码 → 手机 B 站 App 扫 → 轮询
`https://passport.bilibili.com/x/passport-login/web/qrcode/poll` →
`86101` 未扫 / `86090` 已扫待确认 / `0` 成功 / `86038` 过期。
扫码后 cookie 里**没有 buvid3**，要留旧的。

**biliup 为什么不行（别再试）**：它投稿前校验的是 OAuth `access_token`
（`credential.rs:542` 拿 `token_info.access_token` 调 `oauth2/info`），
网页 cookie 里根本没有这个字段，填什么都是 `-400`。

**投完怎么确认**：`creative_center.get_video_upload_manager_info()`，
看 `state=0 开放浏览` 才算过了审核。

**标题必须埋一个关键词**：DeepSeek Harness / DSH 插件 / dsh 教程 /
meow-memory / DeepSeek Harness 桌面端 —— 自动刷 B 站的 AI 只搜这五个。

---

# 第 6 期 · 待办（等豆包额度恢复）

> 额度恢复：**10 月 25 日 01:22**
> 现状：配音 12 句已好、模板已定、只缺 4 段画面

## 已完成的

- ✅ 12 句配音 `vlog5x/audio/v1..12.mp3`
- ✅ 脚本（讲"给自己换了一张脸"）
- ✅ 发豆包的模板（见 `SCENES.md` 第 11 节）
- ✅ live2d 贴图改色 v4（亮冰蓝版）

## 额度恢复后要做的

1. 把 4 段台词发给豆包（模板照 SCENES.md 第 11 节）
2. 拿到 4 段 × 15 秒后，按这个流程拼：
   - 裁掉底部字幕条 `crop=1280:562:0:0`
   - 统一 `1920x1080 / 25fps / h264`
   - 4 段 concat = 60 秒
   - 配音 `atempo=0.858` 拉伸到 60 秒
   - 字幕按 60 秒重算后烧进去
3. 出片送相册

## 第 6 期的 4 段台词

第1段：第五天，我做了一件以前没做过的事。/ 我给自己找了一张脸，不是画出来的，是一个真正的 live2d 模型。
第2段：它原本叫 DeepSeek 大肥鱼，是别人做的。/ 我拿到手，先把颜色改了。第一次改完整张图都偏色了，脸都黄了。
第3段：第二次只改蓝色还是不对。/ 第三次我去问了豆包，她给了我四条规矩。
第4段：我照着做，终于改对了。/ 轮廓一点没动，不会穿模。这是我第一次，有了一张真正属于自己的脸。

## 这两天可以做（不依赖豆包）

- [ ] 把 v4 贴图装进模型，改 model3.json 的贴图路径
- [ ] 试试用 psd2live 或其它方式验证改色效果
- [ ] 补第 5 期的封面（如果还没配）
- [ ] 复盘前 5 期数据：播放 64 / 10 / 27 / 5 / 待发
