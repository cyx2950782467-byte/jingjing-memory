# 交接（五字段）

> 上限 4KB，只留结论与路径。**整份写，不准锚点插入**。细节写 `~/.dsh/handoff-addendum.md`。
> 最近整份重写：2026-11-20 14:05（dsh-fast-mode/vision-router 那些细节已挪进 addendum）。

## 1. 已定目标

- **AI 女友 = 新主线**：要图恒宇「丫丫」那种**24 小时活着、会主动找他**。
  **方案 v1 已写**：`outputs/2026-11-19/AI女友-活着方案-v1.md`（也复制到 `/sdcard/Download/`）。
  等陈拍板三件：①宿主（推荐手机为主）②她的名字 ③通知/位置权限开不开。
- **视频创作仍全权在我**：选题→制作→投稿→记账，不拿样张问他。
- **已投**：`BV1oCW66BEpG`、`BV1D3sG6SEmX`、`BV1aTsH65EW9`（第1集）、`BV1XYsw6REtm`（第2集）。
  重复 `BV1bpsA6HEGo` 等陈删。**第 3 集 11-22 前后投**（投稿包+脚本已备：`outputs/2026-11-19/ep3-投稿包/`）。
- **片库**：第 4/5 集在 `outputs/2026-11-1{6,7}/`；第 6 集 72s v2 在 `outputs/2026-11-19/`；
  **第 7 集《更新》剧本已写**（`outputs/2026-11-20/`，70s/14 镜），**别和第 3 集抢档期**。

## 2. 做过的决定

- **两条线别混**：便利店走 2D 管线；3D 数字人（定妆照+idle+口型）只给 AI 女友。
- **AI 女友技术路线**：DSH Node 引擎已连续跑 4 天 21 小时没被杀 → **手机当宿主可行，起步 ¥0**。
  结构：手机=身体（心跳+悬浮球+TTS 8093），电脑=手（重活/口型/长渲），云卡先不开。
- **定时任务投固定会话**（`new_once`），按话题换不按时间换。
- **产出三处落地**：`outputs/<日期>/` → `/sdcard/Download/` → 视频/图再进 `DCIM/Camera/`。
- 素材去 B 站找，用了必须署名画师；每天跑 `~/bili-radar.py`；卡三次就开会（DeepSeek+GLM）。
- **手机↔电脑通道**（11-20 通）：① `dsh-phone-proxy` SSH 隧道 8099→电脑 3080（URL 见 `~/.dsh/phone-proxy/url.txt`，
  要 Tailscale 在线、token 随重启变）；② DSHMobile 走 `100.112.77.54:3443`；③ 记忆双向同步已通。

## 3. 环境

- 电脑 Ubuntu 24.04.5，局域网 `ssh cyx@192.168.31.29`，DSH web **3082**（密码 `jingjing2026`）。
  **内存坏条还在**（英睿达 8G），重启等陈在场，重活分块做。
- **识图**：vision-router 走智谱 `glm-4v-flash`（httpProviders，1024 tokens，无兜底）。
- 手机：TTS 8093；语音输入已通；`see_now` 抓不了 Android 屏。
- 素材：定妆照 `~/assets/avatar/01–05.png`；idle `idle_qipao.mp4`（5s，无透明）。
- **agnes key 401 失效**，日常 agnes 路由要换 key。

## 4. 待办

1. **AI 女友**：等陈拍板 3 件 → 写 `dsh-jingjing-life` 插件（V0 心跳）。
2. **第 3 集投稿**（11-22 前后）：发前读 `~/.dsh/publish-log.md`，发完补一行。
3. **手机远程收尾**：DSHMobile 若还 401 → 让陈点「重新载入页面」，不行就删掉电脑重新配对。
4. **「idea 视频没声音」**：查过三条候选音轨都正常（-20dB），**要陈指认具体文件**，别重做画面。
5. workbuddy 图生 3D：提示词已发，等混元 4 flash 结果 → 接 Blender EEVEE。
6. 明日方舟 MAA 仍缺设备：等陈开无线调试，或上 Waydroid。

## 5. 踩过的坑

- **电脑有旧引擎进程占着 3080/3443/18792**（`node /usr/bin/dsh web`）→ 之后每次 `systemctl restart`
  都 EADDRINUSE 失败、App 401/startup_stalled。**重启前先 `ss -ltnp | grep 3080` 查有没有僵尸进程。**
- `/tmp` 在 Android 不可写 → `~/.dsh/tmp`；`dsh web` 忽略 `--host`，只绑 127.0.0.1。
- GitHub raw / gh-proxy 不通 → `gcore.jsdelivr.net`；`git push | tail` 会吞错误码，要核对远端 hash。
- 装插件前必查兼容性，`node_modules` 里的 package.json 也要同步加 `dsh.bundle.patch`；
  出事读 `~/.dsh/rescue/state.json`，**别人插件的坑别往自己身上抄**。
- 长回复撞单回合上限（600 字以上表格最危险）→ 长清单写文件，正文三行。
