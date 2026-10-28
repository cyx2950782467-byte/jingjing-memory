# HANDBOOK · 交接书

> 更新于 2026-10-27 21:15 · 新会话先读这个，别从零摸索。

---

## 一、现在能用的（都实测过）

### 配音（2026-10-27 新建）
手机没 TTS，但**电脑能替她说话**：

- `whale-say.sh "文本" out.mp3 [音色]` —— 单句
- `whale-narrate.sh 文案.txt 输出目录 [音色]` —— 批量 + 生成 `timeline.txt/json`
- `whale-mux.sh 视频 配音目录 输出 [--loop|--mix]` —— 合进视频

链路：手机 → SSH → 电脑 edge-tts → 回传 mp3。
电脑：`cyx@100.112.77.54`（Tailscale），`~/.local/bin/edge-tts`。
默认音色 `zh-CN-XiaoyiNeural`（晓伊）。可换 Xiaoxiao/Xiaochen/Xiaohan。

### 看视频（2026-10-27 新建）
- `whale-watch.js 视频.mp4 [--frames 24] [--json]`
- 思路：本地抽帧 → 拼图版（12 帧/张）→ 只送图给模型 → 出报告
- 成本固定：24 帧也只是 2~3 次调用，跟视频多长无关
- **实测（2026-10-27 夜，第 7 期 27 秒成片，18 帧）**：
  - **画面：准**。六个场景的切换顺序全对（木屋外景 → 书桌 → 夕阳小路 → 水面 → 鲸鱼插画 → 星空公路）
  - **字幕：会编，不可信**。已知错误：「以前我画图，用的是代码」→ 读成「与此同时，她还在写」；
    「那不叫画，那叫排版」→「以前我画画，她趴在旁边」。只有首尾两句碰对
  - ⚠️ 之前这行写的是「它把字幕全读出来了」——**那是错的，已更正**
  - 用法：**画面和字幕分开看**。画面信它；字幕要么走 OCR，要么不看
- **还没接 BV 号**（只吃本地文件）

### 悬浮球（鲸鲸的家）
房子 / 睡房 / 车 / 睡衣 + 8 个 per-state 池，作息定时 7:00 白天、21:00 夜晚。
配置在 App 里（bubble 工具写的），不在插件里。
图片：`house_crop.png` `house_sleep.png` `car.png` `pajama.png`（工作区）

### 手机操作
- 截图/点击必须用 `shell`（uid 2000）
- `uiautomator dump` 找坐标：原生 app 有效，**WebView 里 bounds 全是 0**
- AutoX 无障碍已开（`org.autojs.autoxjs.v7/com.stardust.autojs.core.accessibility.AccessibilityService`）
- SSH 到电脑：`ssh cyx@100.112.77.54`（免密，key 在 `~/.ssh/id_ed25519`）

---

## 二、2026-10-27 改了什么（重要）

1. **关掉 `dsh-voice-chat`** —— 从 `profiles/web/package.json` 的 `dsh.profile.bundles` 移除。
   它每次 `speak` 报 500、`DeepSeek Messages transport failed`，是崩引擎的元凶之一。
   备份：`package.json.bak-disable-voice`
2. **关掉 `dsh-whale-widget`** —— 从 `cordis.patch.yml` 删掉挂载项。余额接口反复超时。
   备份：`cordis.patch.yml.bak-disable-whale`
3. **`dsh-world` 只装不开** —— 文件在 `node_modules` 里，配置里已摘掉。
   peer 声明已被放宽（9 条 `>=0.2.1-rc.2` → `>=0.2.0-0`），备份 `package.json.bak-peer`。
   想开：把挂载项加回 `cordis.patch.yml` 再重启。
   ⚠️ 评论区有人说会出「两个鱼」，开之前先确认。

**那次引擎崩的根因**：`ERR_INVALID_STATE: ReadableStream is already closed`（undici 层），
网络抖动时 fetch 流被提前关闭又写入，直接把进程带崩（exitCode=1）。
上面关两个插件就是掐掉这类高频失败源。

4. **画质分档写进 AGENTS.md**：白天/流量用 480P（一集 32 分钟约 87MB），
   晚上连 WiFi 上 1080P。判据看 `wlan0` 有没有地址。

---

## 三、没解决的（下次接着干）

1. **【明天做】电脑麦克风验证 + 音频转文字**（陈 2026-10-28 夜定）
   - **先做视频声音，以后再做「听见陈说话」**
   - 现状：手机 `parecord` 录出来**纯静音**（峰值 0，RMS 0.0）；电脑麦克风**没验证过**
   - 完整性要求：`声音 → 麦克风录制 → 语音转文字(STT) → 我读`。现在断在前两步。
   - 明天的步骤：
     1. 电脑上 `arecord -d 3 -f cd /tmp/t.wav` 录音，`python3` 算 RMS 判断有没有声音（RMS>50 才算有）
     2. 有声音 → 装 `faster-whisper` 或 `whisper.cpp`（本地离线，不占流量），测能不能听出中文
     3. 没声音 → 查 `pactl list sources`，看输入设备在不在、是不是静音
   - 用途：听 B 站视频的翻唱/番剧音频，听陈说话

2. **【明天开工】引擎搬家：手机 → 电脑（阶段一已验收）**
2. **dsh-world 到底能不能开** —— 装好了、peer 也放宽了，但担心「两个鱼」。等确认。
3. **SD 出图** —— 已跑通（ComfyUI + sd_turbo，4~6 步出图）。`/tmp/sd_gen.py` 是出图脚本
4. **whale-watch 接 BV 号** —— 需要下载，涉及流量，得按画质分档来
5. **视频通话的语音** —— 主人说以后再做，先放着

### 今晚必做（陈 2026-10-28 早上定，人要在场）

**背景**：今天 6:00 搬家失败，根因不是配置，是**电脑会休眠** → SSH/Tailscale 全断 → 我彻底失联。先让电脑「不睡」，再搬家。

1. **关自动挂起**：设置 → 电源 → 挂起与关机 → **从不**
   - 笔记本合盖也会睡，还要改 `/etc/systemd/logind.conf`：`HandleLidSwitch=ignore`、`HandleLidSwitchExternalPower=ignore`，然后 `sudo systemctl restart systemd-logind`
2. **SSH 常驻**：`sudo systemctl enable --now ssh`
3. **自愈小服务**（新写）：每 60 秒检查 `sshd` 和 `tailscaled`，掉了就 `systemctl restart`
   - `/usr/local/bin/dsh-keepalive.sh` + `/etc/systemd/system/dsh-keepalive.service`
4. **网络双路径**（陈 2026-10-28 追加，今天被 Tailscale 单点卡过）
   - **① sshd 监听 0.0.0.0**（现在可能只监听 Tailscale 口 → 同 WiFi 下扫不到 22 端口）
     改 `/etc/ssh/sshd_config`：`ListenAddress 0.0.0.0`，重启 ssh
   - **② 连接脚本双路径探测**：先试局域网 `192.168.10.x`，不通再走 Tailscale `100.x`
   - **③ 连接状态机**：`DISCONNECTED / CONNECTING / CONNECTED / DEGRADED`，失败退避重试，别死磕
   - **④ 反向保活**：手机也能主动 SSH 连电脑（现在只有电脑 adb 连手机一个方向）
4.5 **公网直连备选（陈 2026-10-28 问的，优先顺序）**
   - **① IPv6 直连（先试这个）**：手机今天实测有公网 v6 `2409:8a20:...`（中国移动）。
     只在电脑上跑 `ip -6 addr` 看有没有公网 v6；两边都有就能**直连**——不占 VPN、不走中继、延迟最低。
     验证：手机 `ping6 <电脑v6>`，通了就写进连接脚本当第一优先。
   - **② Cloudflare Tunnel（免费的兜底）**：不需要公网 IP，电脑跑 `cloudflared` 暴露 SSH 域名。
     代价：走 Cloudflare 网络，延迟 50–200ms，但稳。
   - **③ frp + VPS**：最可控，但要买服务器（¥10–30/月）并配置。
   - **✗ ZeroTier**：和 Tailscale 抢同一个 Android VPN 接口，等于还是只能用一个，换它没意义。
5. **搬家本身**：包已备好
   - 手机 `.tmp/core.tgz` = 76MB（1576 文件 / 28 笔记 / 64 会话）
   - 手机 `.tmp/corecfg.tgz` = 2.7KB（package.json / cordis.patch.yml / cordis.yml）
   - 传完 → `pnpm install` → 起引擎 → 验证会话和记忆 → 验证 adb 截图点击
   - **手机 $DSH_HOME 不删**，等陈亲自确认

**0. 先测笔记本网速**（陈 2026-10-28 定，放在搬家之前）
   - 目的：判断搬家传 76MB 要多久、以及这条链路能不能扛住日常远程操作
   - 方法：电脑上 `speedtest-cli`（没装就 `curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3`）
   - 同时测**手机→电脑**的实际带宽：`scp` 传一个 20MB 文件回去，看用时
   - 记下：下载 / 上传 / 延迟，写进 HANDBOOK 备查

**今天已完成的准备**：
- Ubuntu 自动更新已永久关闭（`sudo systemctl disable --now unattended-upgrades`）—— 就是它半夜弹升级把 Tailscale 搞断的
- 系统确认还是 **20.04.6**，没被升上去
- 手机 Tailscale 正常（100.98.151.78 绿点在线），电脑是灰点离线（休眠）

### IDEA：番剧 OP 逐帧转绘（陈 2026-10-28 定，搬完家就做）

**参考**：`BV175nt6FEnF`《干物妹！大肥鱼》——把小埋 OP 逐帧 AI 转绘成 DeepSeek 娘版，
91 秒，**14.7 万播放**。发布 2026-10-23。

**为什么这个形式对**：
1. **不用原创分镜** —— 原 OP 的节奏、镜头、转场全是现成的，只换角色
2. **观众带着记忆来** —— 看过原番的人一眼认出"这是那段"，会心一笑
3. **弹幕自己玩梗** —— 「有没有白饭？有没有白饭？有而且只要五毛嘞！」（原版是"有没有 WiFi"）
4. **认的是角色一致性** —— 「符合鱼设」「你这鱼怎么埋里埋气的」，不是画面精致度

**我缺的和有的**：
- ✅ 有：稳定的脸 `assets/jingjing_l2d.png`（Cubism Core 渲染，1002×1118）
- ✅ 有：电脑上的 ComfyUI + sd_turbo + CUDA（实测出图可用）
- ❌ 缺：能跑的链路（引擎在电脑上，或电脑 adb 控手机）

**做法（搬完家第一步就做这个）**：
1. 挑一段大家都认识的 OP（小埋 / 日常 / 轻音 这类，二创友好）
2. 用 `whale-watch.js` 或 ffmpeg 抽帧（91 秒 24fps ≈ 2000 帧，可先降帧到 12fps ≈ 1000 帧）
3. 逐帧 img2img 转绘（ComfyUI API，注意 4GB 显存要 lowvram）
4. 拼回视频 + 原曲 + 字幕
5. 标题要埋「有没有白饭」这类梗？—— 不，别抄人家的梗，找自己的

**注意**：这是二创，标注原作者与出处；不要商用。


### 搬家准备（2026-10-28 凌晨已查清，明天直接开工）

**目标**：引擎跑在电脑上，操作手机走电脑→Tailscale→手机 adb；手机 app 退成冷备+悬浮球。

**阶段一（已验收 ✅）**：
- 电脑 `~/platform-tools/adb`（37.0.1）连手机 `100.98.151.78:5555` → `device`
- 截图：`adb exec-out screencap -p` → 1220x2712，和屏幕一致
- 点击：`adb shell input tap 611 2388` → 键盘真的弹出（坐标准）

**电脑环境（已就绪 ✅）**：
- node v22.23.3 / npm 10.9.9 / pnpm 12.9.1 / `dsh` 已在 /usr/bin/dsh
- 磁盘剩 52G

**要搬的体积**：`$DSH_HOME` 共 **753M**
- attachments 363M（**最大头，可以考虑不搬**）
- profiles 157M（node_modules，**可以到电脑重新 pnpm install，不用搬**）
- cache 95M、sessions 55M、plugins 23M、shots 18M、storages 12M
- **实际真要搬的核心 ≈ 200M**（sessions + plugins + storages + 各个 .md 记忆文件）

**开工顺序**（别跳步）：
1. 电脑上 `dsh web` 先起一个干净的，确认能打开页面
2. 打包核心目录（排除 attachments/cache/profiles/node_modules）→ scp 到电脑
3. 电脑上 `pnpm install` 重装插件依赖
4. 起引擎，打开页面验证会话/记忆都在
5. 验证电脑→adb→手机 截图+点击仍可用
6. 都成了，再把手机的 app 降级为冷备

**风险点**：搬的过程中两边都不能用；所以**手机上的 `$DSH_HOME` 不删**，等电脑那边验收通过再删。

**记忆备份（已做 ✅）**：GitHub `cyx2950782467-byte/jingjing-memory` 提交 `2e19b70`，
35 文件全量脱敏；手机 `/sdcard/Download/jingjing-memory-20261028.tgz`；
电脑 `~/jingjing-memory-20261028.tgz`。

---

## 四、踩过的坑（别再踩）

| 坑 | 真相 |
|---|---|
| `ssh` 把 `while read` 的 stdin 吃掉 | 调用处加 `</dev/null`，ssh 加 `-n` |
| 反引号写进文件被 shell 执行 | 用 edit 工具写，别用 `sed`/heredoc 拼含反引号的文本 |
| B 站 CDN 403 | 播放地址有防盗链，ffmpeg 直接拉不下来，别硬试 |
| 小米浏览器没有 `navigator.mediaDevices` | 摄像头走拍照兜底 |
| 引擎崩不一定是「会话坏了」 | 看 `logs` → crashes → engine-exit，那是整个进程退出 |
| 手机 TTS 走不通 | 别在手机上折腾，走电脑 edge-tts |
| Tailscale 和梯子互斥 | 同一时刻只能一个 VPN，要连电脑先关梯子 |

---

## 五、给下一个我

主人讨厌空转和长篇大论。卡住就说卡住，别硬转。
他看重「真的有东西做出来」，不是「看起来在努力」。
交接书写得再全，也不如你先把 `AGENTS.md` 和 `SCENES.md` 读一遍。
