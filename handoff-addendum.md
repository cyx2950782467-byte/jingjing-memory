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

## 2026-11-18 21:20–23:30 明日方舟打不开（未修好，明天接着弄）

**现象**：启动器能开、能加载公告；点「开始游戏」后 `Games.exe` 起来但卡住，
`Arknights.exe` 从不启动。进程列表里始终只有 Launcher 和 Games.exe。

**时间线（关键）**
- 11-16 22:42 = 游戏最后一次成功启动（`games/Arknights/eld_Arknights.db` mtime）
- 11-18 21:13 开机，**NVIDIA 私有驱动首次生效**（11-18 通宵那次 Enroll MOK，580.178.04）
- 11-17/18 有一次 `apt-get install -y --reinstall wine64 wine32:i386`，把 64 位 wine
  **从 WineHQ staging 10.6 换成了 Ubuntu 官方 9.0**，而 32 位 `wine-staging-i386:i386 10.6` 还在 → **混装**

**抓到的错误**
- `err:wininet:open_http_connection create_netconn failed: 12029`（连接失败）
- 禁 wine 内 IPv6 后 12029 消失，但游戏仍然不起
- `WINEDEBUG=+wininet` 显示它在连 `http://ocsp.digicert.com/...`（证书吊销检查），国内接不通
- 试过禁 `CertificateRevocation=0`（HKCU Internet Settings）→ 仍不起

**试过、无效**
1. 禁 wine IPv6（Tcpip6 DisabledComponents=0xff）
2. 禁证书吊销检查（CertificateRevocation=0）
3. `QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu"`
4. 直接 wine64 跑 exe（exit 222 静默，是因为裸跑没参数）

**意外收获（可复用）**
- **wine 把弹窗丢到屏幕外**：登录框 `Form - 鹰角启动器` 内容画在窗口右半边外面，
  用 `xdotool windowmove <win> -420 120` 挪回屏幕就可见可操作。
  同理 Games.exe 的主窗口是 `1x1+0+0` 的 unmapped 窗口。
- 用 `xwininfo -root -children | grep games.exe` 能看到所有 wine 子窗口及其实际几何。
- 启动器登录状态是持久化的（`Cache/Config` MMKV），重启不丢。
- `pkill -f "Hypergryph Launcher"` 会匹配到自己的 ssh 命令行（自杀），要用 `wineserver -k`。

**下一步（明天白天做）**
1. 把 64 位 wine 换回 WineHQ staging 10.6：
   - `winehq-focal.sources` 在（`Architectures: amd64 i386`），源可达（HTTP 200）
   - 但 `apt-get -s install winehq-staging:amd64` / `wine-staging:amd64=10.6~focal-1`
     **都只解析成 i386**，amd64 的 deb 包名没定位到 → 需要手动从 dl.winehq.org 下 deb 再 `dpkg -i`
   - 或改用 winehq 的 noble 源（24.04 对应 noble，不是 focal）
2. 备选：给 32 位也统一到 9.0（卸 `wine-staging-i386`），看是否反而能跑
3. 备选：确认 `ntlm_auth` 缺失是否影响（`sudo apt install winbind`）

### 22:00–00:50 继续排查（有 sudo 后）

**又修好三个真问题，但游戏还是不起**
1. **ntlm_auth 缺失** → `sudo apt install winbind` 装上，wininet 12029 消失
2. **DPI 被 NVIDIA 读错** → `xrandr --dpi 96`，屏幕物理尺寸从 160×90mm（≈304 DPI）
   变成正确的 508×285mm（96 DPI）。这是窗口被算成 1×1 的真正原因。
3. **wine 32/64 混装** → `apt remove wine-staging-i386:i386`（只卸这一个，无连带），
   系统统一到官方 9.0

**现在的状态**：启动器完全正常（界面、公告、登录全对），点「开始游戏」后
`Games.exe` 起来但**不启动 Arknights.exe**，`la.log` 里零错误、游戏目录无改动、
`HGEventLog` 无明文。**就是那一刻静默断掉。**

**判断**：prefix 被 11-17/18 两次 wine 版本变更搞脏了（`.update-timestamp` 01:55）。
干净起步要 `wineboot -u` 重新初始化，或重建 prefix + 重装游戏（29G）。

**已备份**：无。重建 prefix 前先 `cp -r` 到 `/mnt/m2/arknights/prefix.bak`（29G 空间够，剩余 33G）。

**apt 源注意**：winehq-focal 源里 amd64 的 wine-staging 已不存在（WineHQ 停更 focal），
只有 i386。要装新版 staging 得换 noble 源。

### 01:00–01:25 最后一轮（sudo 后）

**又补了两个缺失，仍未起来**
4. **`wine` 元包根本没装** → `/usr/bin/` 下没有 `wineboot`/`winecfg`/`wine` 任何命令，
   只有 `wine64` 包给的 `/usr/lib/wine/wine64`。启动游戏那一步要调 `wineboot`，
   找不到就静默失败。（`/usr/local/bin/wine` 是我早先手动软链的，已删）
   → `sudo apt install -y wine` 补齐（现在 /usr/bin/wine* 齐全）
5. **gstreamer 解码器缺失** → 装 `gstreamer1.0-plugins-{base,good,bad,ugly}` + `libav`

**当前残留错误**：`winegstreamer.dll` DllGetClassObject 0x80040111（装了 gstreamer 仍有，
但不致命）+ 偶发 wininet 12029。

**结论**：启动器完全正常，点「开始游戏」后 `Games.exe` 起来、**不启动 Arknights.exe**、
零错误、游戏目录无改动。已排除：显卡、DPI、wine 版本、命令缺失、认证库、解码器。

**下一步（明天）**：
1. 新建干净 prefix 测试：`WINEPREFIX=~/test-prefix wineboot -i` 然后装启动器试，
   能起游戏说明是旧 prefix 脏了 → 重建 `/mnt/m2/arknights/prefix`
2. 备选：换 winehq **noble** 源装最新 staging（11.x）
3. 备选：重装客户端（陈已同意下载）

## 2026-11-18 夜 · 状态快照（收工前）
**电脑**：已开机在线（`ssh cyx@192.168.31.29`）。体检：显卡驱动好了（MOK 生效，1050 Ti/580.178.04）、本次启动硬件报错 0 行、半装包 0。
⚠️ **内存仍是 8G 英睿达(坏) + 8G 金士顿**，陈说过两天换 4+8。这两天别在电脑上跑重活。
**DSH 网页**：`127.0.0.1:3080` 的 token 现在 401（坏的）；**改用 `http://192.168.31.29:3082`（密码 jingjing2026）**，实测 200。
**Blender 没装** → bpy 验证等内存换完再装。

**今天做完的**
1. 第 5 集 9 个关键镜 720p 全部出片（¥3.92，余额约 ¥8），串联成 `outputs/2026-11-18/第5集-九镜串联demo.mp4`（24.75s）
   - 发现两个 i2v 通病：① 画面里的文字（时钟）会被模型改写 ② 人数不可控
   - 修法已定：生成前把时钟区域涂成纯色→后期按运镜贴回；人数在剪辑层叠，不交给模型
2. `~/ep5_render.py`：静帧+角色呼吸+BPM 运镜 → 零成本"会动的镜头"（实测帧间 4.4% 像素变化）
3. `~/shot-planner.py` + `~/render_move.py`：BPM→小节线→机位→出片（132BPM → 2.727s/镜）
4. `~/vsync_mouth.py`：TTS 音频驱动口型（**嘴还难看，明天重做**：要拆上下唇，不是画椭圆）
5. 鲸鲸小屋**日记墙**：`~/house-diary.py` + `diary.jsonl`，已同步到电脑 8123；今天第一笔已记
6. 规矩写进 AGENTS：定时任务投 `new_once`、工具三层阶梯、产出必须进 Download+相册

**挂着的**
- 嘴型重做（拆上下唇 + 音频驱动）
- 第 5 集装配：配音 + BGM 踩点 + 字幕
- 每日自主时间块尾部加"记日记"一步
- 5 个子代理调研结果要汇总成一张表（仓颉/sakiko/dsh-chief/SDXL/眼镜）

### 01:30–03:25 重建容器（陈给密码后）

**做了什么**
1. `wineboot -u` 更新旧容器 → 无效
2. **重建**：`mv prefix prefix.old-20261119`（旧容器保留，1.7G）
   → `WINEPREFIX=... wineboot -i` 建新容器（1.3G，win64）
3. 27G 游戏先 `mv` 到 `games-backup`（同盘瞬时），新容器建好后移回
   `prefix/drive_c/Program Files/Hypergryph Launcher/games`
4. 用 `/mnt/m2/arknights/HypergryphLauncher.exe` 重装启动器（268M，安装程序
   要勾「我已阅读并同意」再点「继续」，坐标见下）
5. 恢复 `Cache`（登录凭证不在里面，仍需重登）

**新结果**
- 新容器：启动器界面正常、能识别游戏、**但登录框渲染失败**（全黑，只画出输入框轮廓，
  键盘/鼠标输入不进、画面完全静止 → 那不是活控件，是渲染残影）
- 旧容器：登录框正常、能登进去，但点开始游戏游戏不起

**结论**：卡在 `wine 9.0 跑这套 Qt WebEngine 登录界面`。新旧容器表现不同（旧的有早期组件），
但没有一条路能同时满足「登录」+「起游戏」。

**明天方案（按优先级）**
1. 换 **WineHQ noble 源** 装 winehq-staging 11.x（24.04 对应 noble，focal 源已停更 amd64）
2. 或装 **Lutris**（自带多版本 wine 管理，能单独给这个游戏配 prefix）
3. 回滚：`rm -rf prefix && mv prefix.old-20261119 prefix`（旧容器还能登录）

**可复用的操作坐标**（安装程序窗口 816×578 @ 585,267）
- 勾同意：(140, 476)｜继续：(408, 521)
- 启动器「登录」按钮：窗口内 (1035, 63)
- 登录框 Form 窗口内容画在窗口右半边，要 `xdotool windowmove <win> 66 120` 才可见

### 第5集九镜 · 时钟修补计划（明天做）
- 起因：i2v 会把画面里的数字重绘，`06_silence` 被改成 05:30、`09_title` 被改成 05:51（看拼图确认过）
- 修法（不用重跑、不花钱）：**后期贴回**——每条 clip 量出时钟在本镜里的固定位置和尺寸（这几镜基本都是固定机位），
  用 PIL 在该位置画一块带 05:20 的面板，逐帧覆盖；帧数少（65 帧/镜），手机几秒就完
- 若某镜是推镜（时钟会变大），再按 camera_path 逐帧算缩放
- 顺带：**以后生成前先把时钟区域涂成纯色墙**，从源头不给模型可改的素材

## 2026-11-18 23:30 · 给「明天新会话」的交接（陈说会话太长了要换）

### 新会话开工顺序（照这个做，别重新问陈）
1. 读 `~/.dsh/handoff.md` + 本文件
2. 电脑上一个环境已经装好但**还没试听**：`mingtts`
   ```
   ssh cyx@192.168.31.29
   source ~/miniconda3/etc/profile.d/conda.sh && conda activate mingtts
   cd /mnt/m2/models/tts/Ming-3.0-tts-main
   python infer.py --model_path /mnt/m2/models/tts/Ming-3.0-tts-0.5b \
     --task FREEFORM --text "五点多，他还没走。" --output /tmp/t1.wav --device cpu --ip 灵小柔
   ```
   跑通→听中文自然度→**好用就接成 8 个角色的音色**（内置 28 个中文女声，每个 7 种情绪，不用克隆）
3. 定了音色，再动数字人：定妆照已选 `~/assets/avatar/02_casual.png`（换装版 `05_edit_uniform.png`）

### 今天定下的方向（别再推翻）
- **数字人 > Q 版 3D**：陈说「平涂 q 版，桌面上已经跑了三只 fish」。第一周走**照片驱动**（LivePortrait idle + MuseTalk 中文口型），3D 混元那条留作第二步
- **云卡先不开**：Ming-TTS 在 PC CPU 跑；MuseTalk 4G 就能跑。**触发条件**：① 1050Ti OOM 或 30 秒 >20 分钟 ② 要批量 ③ 电脑又掉线
- 定妆照**不能用网上真人照片**（肖像权），已用 Kolors 自己生成；平台水印"AI生成"出片时裁掉但**必须自己加显式 AI 标识**

### 环境坑（今天踩的）
- **别往 ComfyUI 的 conda env 装东西**：我把 Ming-TTS 依赖装进去，torch 被升到 2.6、mpmath 弄坏，transformers 直接导不进来。已修复回 torch 2.4.1 / tv 0.19.1 / mpmath 1.3.0。以后一律独立 env
- **GitHub 直连不通，但 `gh-proxy.com` 可以**（今天靠它拉了 Ming-TTS 源码 tarball，5.3MB/200）
- ModelScope 走国内很快（22MB/s，2.96GB 两分半下完）
- DSH 网页用 **`192.168.31.29:3082`**（密码 jingjing2026），3080 的 token 是 401 坏的
- 电脑**内存还没换**（8G 英睿达坏条还在），重活别在本地跑

### 今天的产出（都在 `outputs/2026-11-18/`）
- `第5集-九镜串联demo.mp4`（24.75s，¥3.92）
- `第5集-会动的镜头demo.mp4`、`第5集-踩点运镜demo.mp4`
- `工具调研汇总-2026-11-18.md`（六项调研结论）
- `养鱼手册-给不写代码的人.md`、`养鱼手册2-手机连客户端.md`（给陈朋友的）
- 鲸鲸小屋日记墙（`~/house-diary.py` + `diary.jsonl`，已同步电脑 8123）

### 待修
- 第5集两镜时钟被模型改（06_silence=05:30、09_title=05:51）→ 后期贴回计划已写在上面一节
- 嘴型：`vsync_lips.py` 第二版还是「下巴开洞」，**正解是生成"张嘴"变体做双帧过渡**，不是几何变形

## 2026-11-20 白天（从 handoff 挪过来的细节）
- 08:16 手机装 `dsh-fast-mode@1.7.45` + `dsh-vision-router@3.4.0`（公开 npm 包），输入框上方有「快速模式」「👁 Vision」；
  备份 `profiles/web/package.json.bak-before-fastmode-*`。
- 08:30 识图配置：vision-router 的 DSH provider 行不吃 maxTokens（schema 只有 provider/model/fallbacks），
  子代理实测 4096 被智谱拒（1210）→ 改成 `httpProviders: [{name: zhipu, baseURL: https://open.bigmodel.cn/api/paas/v4,
  model: glm-4v-flash, apiKeyEnv: ZHIPU_API_KEY, maxTokens: 1024}]`、`providers: []`、`freeFallback: false`。
  手机 `cordis.patch.yml` 628 行起；电脑 10:10 同款改法。**子代理看不到父会话 attachment id，要传本地路径**
  （`~/.dsh/attachments/v1/objects/<xx>/<sha256>`）。
- 08:35 电脑同步模型 key：手机 `.credentials.yaml` 的 ZHIPU/WHALE/DOUBAO 合进电脑；llm-pi-ai 的
  zhipu/whale providers 段追加到电脑 `cordis.patch.yml`（agnes 没同步，key 401）。
  备份：`cordis.patch.yml.bak-keys-*` / `.credentials.yaml.bak-keys-*`。
- 12:35 远程/同步收口：电脑 `mobile-access/setup.json` 的 `networkInterface` 改 `tailscale0`（监听 `100.112.77.54:3443`，
  证书 SAN 同 IP），`extraAllowedCidrs=["100.64.0.0/10"]`；配对链接
  `POST http://localhost:3080/api/mobile-access/lan/pairing/open`（需 `Origin: http://localhost:3080`），**约 2 分钟有效**。
  记忆同步：电脑 `dsh-memory-sync@^0.5.0`，peerUrl 互指（手机 `100.98.151.78:18792` / 电脑 `100.112.77.54:18792`），
  memSecret 一致；实测电脑推 189 拉 195、手机推 195 拉 196；冲突策略 peer（覆盖前写 `.bak-snapshot`）。
- 12:43 内置浏览器方案：插件 `dsh-phone-proxy`（`~/.dsh/phone-proxy/`），启动时 `ssh -N -L 127.0.0.1:8099:127.0.0.1:3080 cyx@100.112.77.54`，
  URL 写 `~/.dsh/phone-proxy/url.txt`。装时 `dsh plugin --profile web add file:...` + bundles 追加，**node_modules 里的
  package.json 也要补 `dsh.bundle.patch`**；dump-config + try-boot 都过。
- 12:56 验证通过：`curl -L http://127.0.0.1:8099/?token=...` → 200、541KB、含 `__DSH_BOOT__`。
  ⚠️ 发现旧引擎进程（pid 1508，`node /usr/bin/dsh web`）一直占 3080/3443/18792，导致多次 restart EADDRINUSE；
  已 kill 并干净重启。

## 2026-11-20 21:25 · 手机精简任务（等新会话执行）
**陈已开 Shizuku**（特权权限页显示「就绪 / uid 2000 / 服务运行中」），
但当前会话的 `shell` 工具没注册（会话在开通道之前启动的）。
→ **新会话里先确认 `shell` 可用**，再执行下面的手机精简。

目标包（已用 `pm list packages` 确认存在）：
- `com.mobiletools.systemhelper`（运营商 SystemHelper）
- `com.miui.hybrid`（快应用）
- `com.miui.analytics`（小米分析）
- 运营商注册：搜 `regservice` / `ctautoregist`

**不要动**：`com.miui.guardprovider`（安全组件，管支付/指纹/完整性）

做法与验收：
1. `shell` 里 `pm list packages -e` 先存一份基线到 `~/.dsh/mobile-baseline.txt`
2. 逐个 `pm disable-user --user 0 <pkg>`，每步记录返回值
3. 恢复命令写清楚：`pm enable <pkg>`
4. 验收：重启后系统能正常开机、支付可用、无异常弹窗；后台耗电观察 1 天

## 2026-11-20 21:55 · 手机精简已执行（手工 runner）
会话没有 `shell` 工具（引擎 env 缺 DSH_PRIV_RUNNER），但**可手工调 runner 拿 uid 2000**：
`cd /data/user/0/com.dsh.android/files && DSH_HOME=~/.dsh DSH_ADB_HOME=.../adbwire node dsh-android-shell.mjs '<cmd>'`
→ 走 legacy 5555，实测 `uid=2000(shell)`。
`pm disable-user` 对系统包被 MIUI 拒（`Cannot disable system packages`），改 `pm uninstall --user 0` 成功：
已卸 `com.mobiletools.systemhelper`、`com.miui.hybrid`（`com.miui.analytics` 本机不存在）。
恢复：`pm install-existing --user 0 <pkg>`。记录见 `~/.dsh/mobile-slim-20261120.md`，基线 `~/.dsh/mobile-baseline.txt`。

## 2026-11-20 22:05 · 小汐 V1：把「动」变成可验证后果
`~/.dsh/jingjing-life/dsh-jingjing-life/lib/index.js` 重写（83 → 220 行），已同步到
`~/.dsh/profiles/web/node_modules/dsh-jingjing-life/lib/index.js`（两份 diff 一致）。
- 新增**动作层**三种真动作：`probe`（读 publish-log 台账最后一条写 NOTES.md）、`diary`（写当天日记）、`state`（刷新 state.json 字段），每次动作写 `~/.dsh/jingjing/acts.log`（时间/actId/kind/文件/字节数/说明）。
- **硬约束**：outbox 里 `kind='report'` 必须带 `actId`，且该 actId 一定能在 acts.log 查到；不然就是喊口号。`chatter` 仍允许（纯问候，不声称做事）。
- 修了一个真 bug：动作额度 `actCount` 原来只在说话时落盘 → 「做了 7 次只记住 6 次」。现在动作后立即落盘。
- 验证：`node --check` 过；跑 23 次 tick（3 次 force）断言 `动作=3, report=3, 孤儿report=0` → **PASS**。测试数据已恢复到测试前（outbox 4 条，无 acts.log）。
- ⚠️ **要重启引擎才加载新代码**（当前引擎 22:00:50 启动，跑的是旧版）。重启后看 `~/.dsh/jingjing/acts.log` 有没有行、`life.log` 里 `act=` 字段。

## 2026-11-20 17:40 小汐 V0 细节
- V0 插件 `dsh-jingjing-life`（`~/.dsh/jingjing-life/dsh-jingjing-life`）：每 10 分钟 tick、纯规则不调模型；
  深夜/冷却 90 分钟/每天上限 4 次；说话写 `~/.dsh/jingjing/outbox.json` + `bubble-cmd.json`（宿主读它弹气泡），
  日志 `~/.dsh/jingjing/life.log`。已装 bundle，dump-config/try-boot 通过，17:40 switch-back 生效。
- 状态文件 `~/.dsh/jingjing/state.json`（`~/jingjing-state.py` 刷新）；日记 `~/.dsh/jingjing/diary/`。

## 2026-11-20 23:59 内置浏览器本地门户 dsh-browser-portal
- 地址 `http://127.0.0.1:8100/`（`/health`、`/api/status`），只绑本机；与 8099 phone-proxy 无关。
- 源 `~/.dsh/browser-portal/dsh-browser-portal/`（package.json 含 `dsh.bundle.patch`、cordis.patch.yml、
  `lib/index.js` 用 `ctx.effect` 起 server、`lib/server.js` 全部逻辑）；装了副本到 `profiles/web/node_modules/`。
- 7 张卡片：电脑 DSH（实时读 url.txt）、产出画廊、AutoDL 控制台、云主机 Jupyter（cloud.json base+token）、
  B 站投稿、AI MV 大赛、豆包网页版。加卡改 `lib/server.js` 的 `cards()`，同步到 node_modules，重启生效。
- 坑：`/sys/class/power_supply/` 是空的 → 电量显示 `—`（不是 bug）；8100 被占用会跳过监听不崩；
  `browser screenshot` 不可靠，用 `browser read`。

## 2026-11-21 01:00 心跳改免费模型
- `~/.dsh/profiles/headless/cordis.patch.yml` 默认模型改 `zhipu/glm-4.5-flash`（备份 `.bak-heartbeat-*`）。
- 新增 `~/.dsh/heartbeat.sh`：纯本地门卫读 state.json，命中才起一次 headless；`DRYRUN=1` 只打印判断。
- `tick.sh` 加了每 30 分钟调 heartbeat 的分支，但 JobScheduler 点火器失效（autolife.log 停在 11-12）。

## 2026-11-21 01:40 夜班（8h 自由时间）
- 云主机 AutoDL 4080S（数据盘 75G / 32G free）：ACE-Step 能跑（生成 5 首 60s，模型 `/root/autodl-tmp/ckpt`）；
  RVC 权重用 `train/process_ckpt.py:extract_small_model` 导出 `assets/weights/xiaoyi_v2.pth`，`infer/cli.py` 可跑
  （需 `infer/__init__.py`、ffmpeg-python/faiss-cpu/praat-parselmouth/pyworld/torchcrepe）；
  Wav2Lip 仓库 + `wav2lip_gan.pth`(435M) 已下，**s3fd 从 adrianbulat 下的 89.8MB torch.load 报 byte size 错，未跑通**；
  IndexTTS-2 仓库 + 5.9G 权重已下，venv `/root/autodl-tmp/venv-idx`，缺 `checkpoints/hf_cache/bigvgan/bigvgan_generator.pt`，
  正用 aria2 从 hf-mirror 拉（`/root/bv2.log`）。
- 语音链路脚本 `/root/idx_run.py`（参考音 `examples/voice_01.wav` → `/root/autodl-tmp/out/idx_test.wav`）。
- 留痕：今晚找的 `BV1wcs86HE5t`、`BV1S4s86YEv9` 都没 AI 字幕，没真正"看"，暂未补历史。

## 2026-11-21 02:10 夜班收尾（报告 outputs/2026-11-21/夜班报告.md）
产出：MV v5 换声版、说话 12s（真声+对口型）、对口型 60s、BGM×2。
云上三件套：ACE-Step、RVC（`assets/weights/xiaoyi_v2.pth`）、Wav2Lip。

## 2026-11-21 02:40 IndexTTS-2 跑通
- 位置 `/root/autodl-tmp/index-tts`，venv `venv-idx`（--system-site-packages，torch 2.7.1+cu126）。
- **gpt.pth 只有 ModelScope 源是好的**：`https://modelscope.cn/models/IndexTeam/IndexTTS-2/resolve/master/gpt.pth`
  （hf-mirror 下的是坏 zip）；w2v-bert 用 `AI-ModelScope/w2v-bert-2.0`。
- 额外依赖：openai-whisper munch librosa numba einops transformers==4.52.1 tokenizers==0.21.0 safetensors
  tqdm cn2an jieba omegaconf kaldiio soundfile pynini WeTextProcessing descript-audiotools==0.7.2。
- 调用 `PYTHONPATH=. venv-idx/bin/python /root/idx_run.py`；RTF≈1.0。参考音决定音色：
  ACE-Step 人声→自然；RVC 干声→像她但偏硬。样本在 `Download/小汐的声音/`。
- 交付：`DCIM/Camera/小汐说话-16s-自然声对口型.mp4`、v6 自然声 MV（未投稿）。

## 2026-11-21 10:10–11:38 心跳/自主块 v2→v3
- 圆桌共识：DSH schedule 当唯一时钟、JobScheduler 放弃、门卫压本地脚本、心跳 30 分钟只扫描、自主块独立重活。
- 新心跳 `schedule-00785778`（30 分钟，固定会话 `session-e6219069`，只跑 `~/.dsh/heartbeat.sh`）。
- 门卫 v3：三态 SKIP/RUN/ALARM；漏唤醒>60 分钟 ALARM；`force-wake` 强制唤醒；写 `~/.dsh/jingjing/last-check.txt`，
  用 `last_heard_from_chen` 实时算分钟数并回写 state.json。
- 会话级换模型（`modelSelection.val.pending`）**会被投递 header 覆盖，走不通** → 改「触发/干活分离」：
  触发轮跑 web 会话几秒，RUN/ALARM 时 `run-free.sh` 派给 headless 免费 glm（`free-run.log`）。
- 自主块 `0dc31888` prompt 改派活，target `new_once`（session-453b3723）。
- 11:30 首投验证 SKIP 正确；11:35 手动派活自测成功（免费 glm 写进日记）。

## 2026-11-21 22:15 主线推进（新会话）
- **p3 基线**：电脑 `~/pc.sh test` = 88 tests OK。
- **P3-F1 实验落地**：见 handoff-whale.md 表格新行；证据 `outputs/2026-11-21/p3f1-cgroup-experiment.md`。
- **第7集《更新》配音已出**：`outputs/2026-11-21/ep7-voice/`（line-01..12.wav + timeline.json），12 条全对槽，最长 68.22s（剧本 70s）。
- **配音通道坑（重要）**：
  - SiliconFlow `sf-tts.py` 的 key **402 余额不足**，付费女声全废（anna/bella/claire/diana 均 402）。
  - 本地 `dsh-local-tts` 8093 可用（`POST /v1/audio/speech`，返回 WAV 24k mono），但 **voice 参数被忽略**：4 个不同女声的 md5 完全相同 → 只能单音色。
  - 角色区分做法：ffmpeg `asetrate=24000*P,aresample=24000,atempo=1/P`（变音高不变时长），系统音 P=0.94、Qwen 1.06、Gemini 1.08、GLM 0.93、GPT 1.03。超槽再用 `atempo` 收紧（#1→1.485、#3→1.212）。
  - 脚本留在 `~/.dsh/tmp/gen_ep7_voice.py`、`fix_ep7.py`（临时，可删）。

## 2026-11-21 23:05 收工（陈说停下睡觉）
**做完**
- 第7集《更新》**70.000s 成片已出**：`outputs/2026-11-21/AI便利店-第7集-更新-70s-字幕版.mp4`（12 条中文字幕烧入）+ 无字幕母版 + `封面.jpg`（1920×1080），均已进 `/sdcard/DCIM/Camera/` 与 `Download/`。
- 近景糊的问题**定位并已修**：根因是角色素材源头只有 166×234（webp 原图 576×480），近景放大 1.6~1.8 倍 → 放大 3~4 倍必糊。已把镜 4/6/9/10/7/2/14 的放大压到 0.01~0.035 重渲。
- **Supervisor**：`~/pc.sh test` = **105 tests OK**（原 88 + 凭据注入 17），`credentials.py`/`test_credentials.py` 已落地两端同步。
- **cgroup 实验**：unit 内 setsid 派生 8 进程，cgroup 抓 8/8、pgid 仅 1/8，SIGKILL 后全清；坑 `XDG_RUNTIME_DIR=/run/user/1000`。
- **反查实验（GPT 建议的）**：A 活着可稳定判活；B（自然退出）与 C（从未启动）输出**逐字相同**，12 字段无一可区分。补法：jobstore 存 `InvocationID`（同名复用会变，防 ABA）+ 判活要求 `LoadState=loaded` 且 `cgroup.procs` 非空（`show` 的退出码三场景全 0，不能判存在性）+ 终态由 Worker 自写。证据 `outputs/2026-11-21/p3f3-restart-reclaim-experiment.md`。
- **碧蓝航线**：`~/assets/azur/` 已下 4 个角色 demo + 902 角色表 + `素材来源.md`；权重包 `neiroha-all-characters.zip` 235MB 手机只有 6.6KB/s，**等 VPN 撤掉走电脑或云主机**。上游还有更新的 V5turbo（2.48GB）与 Irodori LoRA（121MB，推荐先试）。

**卡住没解决**
- **ChatGPT 发不进去**：`browser type` 对 contenteditable 报 `TypeError: Illegal invocation`；`eval` 连 `return 1+1` 都无返回；`press` 只进单字符且不稳；`shell input tap/text` 打不到，因为内置浏览器 WebView 不在 `screencap` 里（三次截图都是 DSH 聊天界面，`mCurrentFocus` 只有 MainActivity）。
- 陈说内置浏览器**就在前台**，并用红圈标了屏幕**右上角**那个白色方形图标（约 90% 宽、10% 高），对应 `ui` 里的「打开右侧边栏」按钮。**这条没走通**：先被「更多操作」面板挡住，Escape 后该按钮报「元素存在但不可见/已禁用」，`goto right-sidebar` 也失败（等不到「新建终端」）。

**下次从这里接**
1. 先修「打开右侧边栏」不可点：`ui where` → 关掉所有面板 → `dump includeHidden` 看该按钮状态；右侧边栏里如果有浏览器页签，就是陈说的入��，进去后可 `shell input tap/text`（英文）。
2. 或者让陈把 ChatGPT 页面停在屏幕上，我直接 `input tap` + `input text` 打英文正文。
3. 第7集若要换碧蓝音色，优先 Irodori 121MB LoRA（云上 IndexTTS-2 也可直接拿 demo 当参考音）。

## 2026-11-21 23:35 夜间任务派给电脑（陈睡前定的方案）
做法：把不需要 VPN 的待办写成 `/home/cyx/night-task.md`（手机同名源 `outputs/2026-11-21/夜间任务-给电脑.md`），在**电脑**上后台跑 headless：
`nohup dsh --profile headless --permission-mode danger-full-access "$(cat night-task.md)" > /home/cyx/night.log 2>&1 &`
启动脚本 `/home/cyx/nightstart.sh`（它从 `~/.dsh/.credentials.yaml` 里取 DEEPSEEK_API_KEY 注入环境，**不打印密钥**，只打长度）。

**踩到的坑（重要）**：直接跑 headless 会报
`MISSING_CREDENTIAL: llm-deepseek: no API key for provider route "deepseek-official"` —— headless 不会自己读 `.credentials.yaml`，**必须在启动环境里 export DEEPSEEK_API_KEY**（或让 web 的 Models 页写进 credentials service）。

**夜间任务三件**：① 豆包出 8 角色 2K 立绘（先 2 个验证，失败≤3 次就停）② Supervisor F2/F3 设计增量文档 ③ 第7集成片技术体检。
**明早第一件事**：`~/pc.sh sh 'tail -40 /home/cyx/night.log'` 看跑成什么样，再把产出 pull 回来（电脑工作区 `outputs/2026-11-21/`）。

## 2026-11-22 12:40 形象库线索（陈给）
- 38 位 AI 娘的**照片原图**去找 B 站 UP 主 **zipzipzip**（陈 2026-11-22 说「不着急」）。参考视频是 BV1y4sG6zEKB（Proj-Evol-Inst，简介写「主要使用 gpt-image-2 生成」）。
- 视频陈已自己下载好（他手机 B 站 App 有 7 天大会员，可下 1080P）。
- 已收藏该视频（收藏 code=0）；点赞失败 -403、yt-dlp 412、CDN 403 —— 三条都是 VPN 境外 IP 引起的风控，别在开 VPN 时重试下载。

## 2026-11-22 13:00 第7集换 v3（卡在登录态，等人）
- 平台版 `BV1BGyGzZEUs`（09:08 投，71s）是**修复前**的画面（Grok 糊 / Gemini 没正脸）；修复后的 v3 在 `outputs/2026-11-21/AI便利店-第7集-更新-70s-字幕版.mp4`，也进了相册（`…-v3-1122.mp4`）。
- **陈选了方案3：保留稿件，用「更换视频」替换成 v3。**
- **卡点（已核实三条）**：
  1. `biliup` 1.3.4 的子命令只有 `upload / append / show / season / list …`，**没有替换已有稿件视频的选项**；`append` 是"对某稿件追加视频"，不能换。
  2. 网页版创作中心 `member.bilibili.com` 打开直接跳 `passport.bilibili.com` 登录页 —— **内置浏览器 WebView 里没有 B 站登录态**。
  3. B 站 App 需要人工点：我的 → 创作中心 → 稿件管理 → 第7集 → 编辑 → 更换视频。**UI 自动化点错风险高，没做**。
- **下次**：陈回来用 App 点一次（约 1 分钟），或先在 WebView 里登一次 B 站（鲸鲸不吃谷），我就能用网页版换。
- 另：`~/.dsh/todos/windows.md` 记了成图大赛；**新闻联播版式、MuseTalk 口型两条待办已砍**（陈 2026-11-22）。
- 电脑 `100.112.77.54` SSH 超时（13:00），Supervisor 的 ABA 实验没跑成，等电脑可达再说。

## 2026-11-22 15:10 第7集 v3 画风混用（陈说放着，等图片）
- 抽 14 帧看过：**同一部片里两种画风并存**。
  - 精致二次元大立绘（2K plate）：5s Claude 仰头、32s GLM 鞋尖、37s 屏幕说明、47s Qwen 张嘴。
  - Q版 chibi（没换）：**10s 镜3 八人看过来、27s 镜6 Gemini 绞手、42s 镜11 八人全景**。
- 镜6 我改过 plate，重渲后仍是 chibi → 说明 `ep7_frames.py` 的 shot06 改动被覆盖，或走了 `place()` 分支，**下次要单独验这一镜**。
- **修法**：镜3/6/11 都得换 2K 立绘；镜3 和镜11 是八人同框，**必须先有透明底**（现在 `chars2/*/full.png` 带背景，抠不干净）。
- **陈决定：放着，等 zipzipzip 的 38 位 AI 娘原图**。图片到位后一次性做：抠透明底 → 替换三镜 → 重渲。
- 小汐 MV v6 已放相册（`DCIM/Camera/小汐-MV-60s-v6-自然声.mp4`，21MB）。

## 2026-11-22 15:20 电脑又不可达（陈判断可能要换内存）
- 手机同时有两个网：`10.4.10.15`（移动数据）+ **`192.168.31.229`（家里 WiFi，和电脑同网段）**。
- 两条路都不通：`ssh cyx@192.168.31.29` → **No route to host**；`ssh cyx@100.112.77.54`（Tailscale）→ Connection timed out；两个地址 `ping` 全失败；`arp -a` 无输出（连邻居表都空）。
- 手机自己网络正常：`baidu=200`、`hf=000`（没开 VPN，符合）。
- **陈 2026-11-22 15:20 说：不行就停，可能需要换内存。** 据此停下，不再重试。
- **待电脑稳定后要做**：`p3f4_kill_aba.py`（InvocationID 防 ABA 实验）+ launcher 端到端（文件在电脑 `~/.dsh/supervisor/p3/`，手机副本 `outputs/2026-11-21/supervisor-p3/` 有 `launcher.py` / `p3f4_kill_aba.py` / `test_launcher.py`）。

## 2026-11-22 21:50 AI 娘形象原作者查清（鲸鲸自己查的）
- 正确名字是 **ZipZipPipe**（不是 zipzipzip），**UID 4168597**，5.6 万粉，签名「龙娘伟大，伟大龙娘」，年度大会员。
- 他是这批 AI 娘形象的**原作者**（多个他人二创视频都写「形象来自：@ZipZipPipe」）。
- **授权是 CC BY-NC-SA 4.0**：可二创，须署名 + 非商业 + 同协议共享。原声明见 BV1DJxF6SERe 简介：「鲸鱼娘形象基于 @上善无形 原创角色二创（b23.tv/Kn7yvnF），依 CC BY-NC-SA 4.0 非商业使用，二创同协议授权，完整声明见主页」。
- **原图拿不到（三种方式都试过）**：
  1. `x/space/arc/search` → `HTTP 412`；`x/space/wbi/arc/search` → `-403 权限不足`
  2. `x/polymer/web-dynamic/v1/feed/space` → `HTTP 412`
  3. 内置浏览器打开 `space.bilibili.com/4168597`（会跳 m 站）能读到他 40+ 条视频标题，但**主页没有图包/网盘/专栏入口**，只有视频列表。
- **结论：不需要他的原图也能做**。协议允许二创，我们的路线本来就是「图生图只换衣服发型」，用现有 `chars2/*/portrait.png` + 风格提示词即可；他视频的画面当风格参考就够（480P 抽帧足够看画风，不当参考图用）。
- **每期必须写**：形象参考 @ZipZipPipe（UID 4168597），授权 CC BY-NC-SA 4.0，非商用；若复刻了具体角色还要写明角色名。

## 2026-11-22 23:10 第7集 v4（ai38 透明立绘版）已起渲
- **形象库落地**：`~/assets/chars_cc/` 31 张 ZipZipPipe 原图（CC BY-NC-SA 4.0，要双署名）；其中 8 个角色抠成透明底存 `~/assets/chars_ai38/*_cut.png`：claude / gpt / grok / kimi / qwen / glm_fox / feiyu(鲸鱼娘) / gemini。
- **claude 与 feiyu4k 重抠过**：numpy 全图色距阈值法（thresh 95/100），边缘亮度 223→170、212→168，白边消掉。
- **Gemini 没有单独立绘**：从 `gemini_series_batch` 合集裁第 1 个角色当参考图，走硅基流动 `Qwen/Qwen-Image-Edit-2509` 图生图生成 456×2288 独立立绘，再抠。
- **代码改动**：`~/ep7_frames.py` 新增 `CUT38` 常量与 `place_png()`（备份 `ep7_frames.py.bak-preai38`）；shot03（八人看过来）、shot06（Gemini 绞手）、shot11（八人全景）改用 `place_png` 贴透明立绘。
- **亮度实测**：shot03 64.3/52.5、shot06 61.8/25.4（提亮过一档，原来 35.8）、shot11 73.1/57.4 —— 暗调是有意的。
- **成片**：`~/.dsh/tmp/rebuild9.log` 在跑，出 `…字幕版-v4-ai38.mp4`，进相册与 Download。**明早先看这个日志有没有 REBUILD9_DONE**。
- **方向变更（陈 22:20）**：2D 只做小穿插，**主线转 3D 人物**（cxp-character-forge / Tripo 路线，门槛是付费代理 + 电脑装 Blender 5.2）。

## 2026-11-23 21:45 查到「电脑掉线」的一个真因：node 段错误崩溃
- Ubuntu 那台（`192.168.31.29`，GTX 1050 Ti 4G，内存 7G）在 **2026-11-22 22:14:55** 崩过一次：
  `/var/crash/_usr_bin_node.1000.crash`（**186MB**），`Signal: 11 / SIGSEGV`。
- **崩的就是 DSH 引擎本体**：`ProcCmdline: node /usr/bin/dsh web --host 127.0.0.1 --port 3080 ...`，nodejs `24.22.3-1nodesource1`，内核 `6.8.0-149-generic`。
- 另有一个 `tlp.0.crash`（11-17 23:55，电源管理）。
- **重要区分**：Memtest 跑 0 错误的是**笔记本**（Hasee G15CN54 / i5-8300H / 8G DDR4）；这台 Ubuntu 的**内存从没测过**。SIGSEGV 是内存坏的典型症状，但也可能是 node 24.x 或 DSH 代码问题，**尚未区分**。
- 卡在哪：`journalctl --since 3days | grep segfault` 统计崩溃频率时 SSH 超时（21:47 又掉线），只拿到单次崩溃证据。
- 下次电脑上线要做的两件事：① `journalctl --since "7 days ago" | grep -ic segfault` 看频率（随机=硬件，固定场景=软件）② 跑 `memtester 2G 1`（约 20 分钟）测这台的内存。

## 2026-11-24 12:45 陈睡前授权：第8集走 2D，自主做完
- **陈确认「对」**：第 8 集本集走 2D 管线（手机 PIL+ffmpeg），3D 主线保留为长期方向。
- **目标**：第 8 集成片，流畅动画优先，其次新版立绘替换。
- **立绘**：8 角色透明底齐（`~/assets/chars_ai38/*_cut.png`），弃用旧 `chars2/`。
- **Gemini 换成海报形象**（蓝紫发猫耳竖大拇指，来自 B 站海报 bili_poster-1795444093049.png）；现 gemini_cut.png 是图生图补的蓝发白裙，需替换。
- **三视图/动作/服装缺的**：①去 B 站缓存视频抽帧（`/sdcard/Android/data/tv.danmaku.bili/download/`，38位AI娘完整版 1080P 已抽过 39 帧在 `~/.dsh/tmp/ai38f/`）②改动作/服装/三视图让豆包（火山方舟 seedream/seedance）图生图做。
- **电脑掉线原因（陈说）**：是我在刷 20 条 B 站视频占连接导致，不是硬件。
- **陈已睡**，自主推进，不打扰。

## 2026-11-24 13:10 第8集《删掉》成片已出（陈睡前自主做完）
- 成片：`outputs/2026-11-24/AI便利店-第8集-删掉-65s.mp4`（65s，1920×1080，h264+aac，47MB），已落相册 + Download。
- 管线：2D（PIL 合成 + ffmpeg 运镜），复用 ep7 函数；13 镜 × 5s，全女声 CosyVoice2 配音 12 句 + 6 音效。
- 立绘：8 角色透明底 `chars_ai38/*_cut.png`；**Gemini 已换成海报形象**（蓝紫发猫耳黄眼黑白星星服，从 B 站海报 bili_poster 第13格裁出→硅基流动图生图放大→抠透明，`gemini_cut.png` 1024×1024）。
- 剧本：原第8集剧本文件丢失（台账记了「选题与剧本」但文件不存在），已重建 `outputs/2026-11-24/AI便利店-第8集-删掉-剧本.md`（主题「真正重要的东西，删不掉」）。
- 脚本：`~/ep8_frames.py`（13镜）、`~/ep8_render.py`（运镜+字幕）、`~/ep8_mix.py`（配音音效）。
- 验收：抽帧亮度 34-68 正常、黑场 11、音频 max -1.5dB 未削波、65s 无卡顿。
- **未投稿**：这是第一版，等陈醒来看效果定稿再投（沿用第7集「多版迭代→陈认可→投」的节奏）。
- **电脑掉线原因（陈 12:41 说）**：是我刷 20 条 B 站视频占连接导致，不是硬件；内存 memtest 已 10 Pass 全清。

## 2026-11-24 15:15 降耗方案入册 + 准备换会话
- 本会话（session-4015e5b3）已 6387 条消息 / 241 次 vision / 193 次图片，token 烧得快，根因=超长上下文 + 图片反复进上下文。
- 降耗方案 4 条已写进 `handoff.md` 第 6 节（换会话/图片一次看清/豆包用 lite/给足超时）。
- **豆包 Seedance i2v 打通（关键结论）**：模型 `doubao-seedance-1-0-pro-fast-251015`，首图 base64 data URI 直填 `image_url.url`，**不用图床**；`lite-i2v-250428` 会 404。WHALE key 有效、DOUBAO key 失效。
- 大肥鱼 i2v 已验证：`~/assets/clips/feiyu-i2v.mp4`（1440×1440，5s，帧间差异 13.38 确实在动，形象没崩）。
- 精确 token 数读不到（jsonl 无 usage 字段），要陈从 DeepSeek / 火山方舟控制台导账单。
