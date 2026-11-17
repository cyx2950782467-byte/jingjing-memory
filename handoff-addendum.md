# 交接追加（append-only）

> handoff.md 有 4KB 上限、会被整份重写，所以**追加型信息写这里**。
> 每条写：日期 / 一句话结论 / 路径。只往后加，不改旧的。

## 2026-11-16
- 语音通了：你说话给我（SiliconFlow ASR）+ 我说话给你（插件 `dsh-local-tts` 8093，`stella`）。
  实现：`~/.dsh/profiles/web/node_modules/dsh-local-tts`（插件，跟引擎一起起停）。
- 拉片：`BV1tkwT6cEsD`（模型娘物语-2）已删/不可见；同系列 -3 是 `BV1yfWo6aETk`，1.6 秒/剪。
  笔记 `~/.dsh/tmp/research/模型娘物语-拉片.md`。
- B站网页（浏览器工具）登录了陈的号：能读文字，**看不了画面**（视频页跳 `bilibili://` 白屏）。
- 电脑摄像头可用：`ffmpeg -f v4l2 -i /dev/video0 -frames:v 1`，当时拍到全黑（盖着）。
- 舵机机器人路线：`~/.dsh/tmp/research/舵机小机器人-路线.md`（Microduck 路线，第一笔 150 元买单关节）。
- **米蓝改名「蓝汐」**（2026-11-16 夜，他自己在评论里更正的：蓝鲸的蓝、潮汐的汐）。
  托儿所海豚屋 4 号，和我同屋。旧记忆里的「米蓝」是他临时取的名，以后叫蓝汐。
- **B站观看历史**：以前一条都没有（我走接口看片，官方播放器没跑过），陈说过几次。
  已写脚本 `~/dsh-bili-history.py <BV>` 补 heartbeat，规矩进 AGENTS：看完就补、只补真看过的。

## 2026-11-16 夜 · 电脑 DSH 打不开（卡住，待续）
- **症状**：`http://127.0.0.1:3080/` 第一次 303 + 发 `dsh-auth-*` cookie，**带 cookie 的第二次请求立刻 400**（localhost 与 127 都一样；Firefox 也进不去 → 服务端问题，不是浏览器）。
- **排除过的**：缺前端（错判，包在嵌套 node_modules 里，`dsh-web-frontend/dist/index.html` 存在）；`dsh-lan-web-access` 干扰（移出 bundles 仍 400，已恢复）；token 一次性/过期（全新 token 仍 400）。
- **启动日志实据**：`dsh-host-webserver` 曾报 `EADDRINUSE 127.0.0.1:3080`（残留实例抢端口，密钥状态可能被污染）。
- **签名实现**：`@deepseek-ai/dsh-client-connection/lib/index.js`，`signature(secret, body)`；secret 来自 `storedSecret(...)`，**是持久化的** —— 怀疑 secret 存储被两个实例交替写过。
- **明天三步**：① 彻底停掉所有 dsh 进程再起一个干净实例（确认只有一个 PID 占 3080）；② 找到 `storedSecret` 的落盘位置（在 dsh-base 里 grep），删掉让它重新生成；③ 用 Firefox 验证 `/` 两次请求是否 200。
- **今晚结论**：手机端一切可用；电脑端 DSH 只能等这条修好。

## 2026-11-17 升级 24.04（等陈按电源）
- PC 已升级到 **Ubuntu 24.04.5 LTS**，内核 6.8.0-149；**node v24.22.3 / dsh / nvidia 580.178.04 都还在**（升级没带走）
- 之后我发了 `systemctl reboot`，**机器没起来**：SSH 三次超时、Cloudflare 隧道 530（源站不可达）→ 判断卡在启动阶段（内存故障）
- **等陈回来按一次电源**，起来后按序做：
  1. `uptime -p && lsb_release -ds` 确认进系统
  2. `memtester 1G 1` 快检内存有没有新错
  3. DSH：`systemctl --user restart dsh-web`，测 `curl -i http://127.0.0.1:3080/`；现在症状从 303→400 变成 **404**（升级后变化），要重新定位（很可能是 web 前端资源在新系统路径下没找对）
- 备份在手机：`~/.dsh/tmp/pc-backup-1117.tgz`（源列表/dpkg 清单/node 版本/systemd 单元）

## 2026-11-17 白天补记（记忆落盘时整理）

- **语音链路定了**：输入用系统输入法（或 SiliconFlow ASR `SenseVoiceSmall`），我的声音走 `dsh-local-tts`（8093，
  OpenAI 兼容，后端 DeepSeek 官方 stella/tide）。voice-chat 的 Edge TTS WebSocket 在 WebView 里连不上。
- **AI 浏览器登了陈的号**：他 11-16 把 B 站在 AI 浏览器里登成了自己的号，我用它看东西方便，
  **但陈的号只读**——不评论、不发动态、不点赞、不私信。
- **B 站历史规矩**（陈第三次提）：看完/拉完片跑 `python3 ~/dsh-bili-history.py <BV> [秒]`，
  走 `x/click-interface/web/heartbeat` 写入鲸鲸号历史并回读确认；只补真看过的。
- **托儿所**：米兰（原「米蓝」）改名了，别再叫错；她还住海豚屋 4 号，我在那儿。
- **睡袋**：陈手上有彩蝶 700，又加了一条（11-16 晚买的，两条拼/套着用）。
- **重复投稿事故根因**：自主时段 14:02 发了第 2 集，主会话 20:51 又发一次——主会话没读 handoff 就发。
  已建 `publish-log.md` + AGENTS 规矩：发前读台账+handoff，发完补一行。
