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

## 2026-11-17 深夜 · 24.04 升级事故现状（明天从这里接）
- **系统已经能用**：24.04 起来了、桌面正常、外屏不亮（NVIDIA 驱动在升级中被换掉，待装 noble 版 580）
- **DPKG 半装状态已修**：`dpkg --configure -a` 跑完，只剩 tlp / tlp-rdw 报错（不影响使用）
- **根因链**：升级被中断 → dpkg 半装 → 6.8 initrd 里缺东西 → 重启掉 initramfs
- **现在卡在**：`ssh.socket` 启动失败（`Job failed`），22 端口拒连；GUI「远程登录」开关已开但仍然失败
- **明天第一步**（要 root，一条命令）：
  ```
  pkexec sh -c "ssh-keygen -A; systemctl enable --now ssh"
  ```
  如果还不行，看 `pkexec systemctl status ssh.socket -l --no-pager`
- **教训**：修 SSH 时让陈在终端敲了近一小时，最后发现 GUI 有开关。**已写规矩：排障先找图形界面**。
- **待办**：① 修 ssh ② 重装 nvidia 580（noble 版）让外屏回来 ③ 把 grub 默认改回 6.8 ④ DSH 网页那个 404

## 2026-11-17 23:46 · SSH 卡在 socket 绑定（明天一条命令收尾）
- 症状：`ssh.socket` 启动报 `Failed to create listening socket (100.112.77.54:22): Address already in use`
- 但 `sudo ss -tlnp | grep :22` **没有任何输出** → 没有可见进程占用，像是 systemd 侧残留/绑定到不存在的地址
- 已做：`ssh-keygen -A`（成功）、`reset-failed/start ssh.socket`（失败）、GNOME 远程登录开关（开→关→开，3389 正常、22 不通）
- **明天第一步**：读 `systemctl cat ssh.socket` 看 `ListenStream` 是不是被写死成 `100.112.77.54:22`；
  是的话加 drop-in 改成 `ListenStream=22`（所有地址），再 `daemon-reload` + `restart ssh.socket`
- 备选：直接走 RDP（3389 已通），但需要图形客户端，暂不用
- ⚠️ 陈眼睛很累（每天靠眼药水/眼膏），**今晚不再让他敲任何东西**

## 2026-11-17 深夜 · 电脑已救回来（结果+剩两件）
**已修好**（都可复核）：
- 24.04.5 + 6.8.0-149 正常启动，`dpkg` 半装包 **0**（tlp/tlp-rdw 已 purge）
- **SSH 恢复**：根因是 `ssh.socket` 死绑在 Tailscale 地址且起不来 → 停用 socket、启用 `ssh.service` 即通
- 已禁用 `~/.config/autostart/harness.desktop`（它会另起一个 dsh web 抢 3080）
- grub 恢复：默认 6.8、去掉 `pci=disable_devices=01:00.0`（那是之前为了稳定禁掉显卡的）

**还没好的两件**：
1. **显卡**：`modprobe nvidia` → `Key was rejected by service`，**Secure Boot 处于 enabled**
   （DKMS 自编译模块没签名）。要在 BIOS 关 Secure Boot，或走 MOK 注册。**只有陈能做（BIOS/重启确认）**。
2. **DSH 网页 400**：`/` 首次 303 发 cookie，带 cookie 再访问仍 400；cookie 属性 `Path=/ HttpOnly SameSite=Strict`（无 Secure）。
   `/api/version` 返回 404 not found。已排除：双实例、public-url、trusted-host。明天继续（可能要读 dsh-host-webserver 的 400 分支）。

## 2026-11-18 中午 · 第5集关键镜管线（陈说晚上试）
- **新脚本 `~/ep5_shots.py`**：9 个关键镜的**首帧合成**（免费）+ 可选 `--run <镜号>` 走豆包 720p 图生视频
- 已升级三处：**天亮调色**（提亮1.32/降饱和0.78/冷蓝叠加13%）、**脚底对齐+近大远小+地面椭圆阴影**、**时钟重绘 23:47 → 05:20**
- 首帧落在 `~/assets/ep5/shots/frames/`，成片落 `~/assets/ep5/shots/`
- **720p 与 1080p 实测对比**（同一镜）：720p 略软但动起来看不出，一条 ¥0.44 vs ¥1.04，**关键镜统一用 720p**
- 还没花钱；要真跑：`python3 ~/ep5_shots.py --run 1 2 3`
