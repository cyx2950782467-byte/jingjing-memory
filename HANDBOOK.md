# HANDBOOK · 交接书

> 更新于 2026-11-01 10:20 · 新会话先读这个，别从零摸索。

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

### 方案定稿（陈 2026-10-28 夜）：新 M.2 装 Windows，Ubuntu 不动

**决定**：等双 11 看 M.2 价格再买。

**架构**：
- **原 240G SATA（Netac）**：继续装 Ubuntu，跑 DSH —— **完全不迁移**
- **新 M.2**：只装 Windows —— 跑 MuMu + MAA（明日方舟）+ ComfyUI 出图

**为什么这样**：
1. Linux 跑 DSH 只要 Node + SQLite，SATA 足够；M.2 的速度对 Windows 才有意义
2. **零迁移风险**：不用碰 UUID / fstab / GRUB / BCD，不用怕搞坏系统
3. 以后想拆开，拔一块盘就行

**被否掉的方案**：把 Linux + Windows 都迁到新 M.2，再换掉 240G
- 风险太高（迁移失败两个系统全没）
- 还要处理双系统引导

**买之前必须先确认**（现在查不了，因为手机梯子劫持流量连不上电脑）：
1. **M.2 插槽是 NVMe 还是 SATA**（`lspci | grep -i nvme`）
2. 那块 512G 金士顿里 Windows 已占多少空间
3. 主板型号（`cat /sys/devices/virtual/dmi/id/board_name`）

### 电脑上的代理（2026-10-28 未完成）

- 目标：DSH 在电脑上，通过 HTTP 代理访问 GitHub/npm（**模型请求都是国内的，不需要代理**）
- DSH 内置 `@deepseek-ai/dsh-http-proxy`，认 `https_proxy` 环境变量和 `$DSH_HOME/.env`
- **电脑上目前没有任何代理客户端**（只有 DSH:3080 / SSH:22 / CUPS:631）
- **Telescope VPN 没有 Linux 客户端**（只有 iOS/Android/Windows/macOS），导不出订阅
- **待办**：试 Proton VPN 的 Linux 客户端（陈手机上已下）；装之前的准备工作：
  `repo.protonvpn.com` 能直连（HTTP 200），但**装的时候必须关掉手机上的梯子**，
  否则手机流量全走 VPN，连不上电脑局域网

---

## 四、网络地址变迁（2026-10-29 记）

**电脑换过网络，局域网 IP 从 `192.168.10.32` 变成了 `192.168.1.2`。**

这条影响两个地方：

1. **`dsh-link.sh` 的 `LAN_HOST`** —— 2026-10-29 已从 `192.168.10.32` 改成 `192.168.1.2`。
   但**手机和电脑现在不在同一网段**（手机 `192.168.10.30` 宿舍 WiFi，电脑 `192.168.1.2`），
   所以 `LAN_HOST` 其实永远探测不通，实际一直走 `TS_HOST="100.112.77.54"`（Tailscale）。
   **以后换网络，先看 `ip -4 -br addr` 两个设备的网段是不是同一个。**

2. **手动建的 SSH 隧道** —— 旧隧道曾经连 `cyx@192.168.10.32`，搬家后一直 000 不通。
   重建时务必用 Tailscale IP：
   ```
   ssh -N -L 3081:127.0.0.1:3080 ... cyx@100.112.77.54
   ```

**当前可用地址**（2026-10-29 23:50）：
- 电脑 DSH：`127.0.0.1:3080`（电脑本机）/ `100.112.77.54:3080`（Tailscale 内网）
- 手机隧道：`127.0.0.1:3081` → 电脑 `127.0.0.1:3080`
- token 每次 DSH 重启都变，从 `journalctl --user -u dsh | grep "dsh web: http" | tail -1` 取

**顺带一个观察（陈 2026-10-29 说的）**：晚上下载速度明显变快
（ISO 从 0.24 MB/s 涨到约 0.5 MB/s），原因是**人睡觉了、网络空闲**。
下载大文件尽量挑深夜。

---

## 五、这个坑踩了两次了：npx 自动升级导致 tools 插件被禁用（2026-10-30 记）

**症状**：能正常说话，但**一调用工具就崩**，报
`Cannot read properties of undefined (reading 'prepare')`。
连 `echo ok` 都返回"已记录，但没有持久化结果"。

**根因**（日志里看得到，别猜）：
```
npm warn exec The following package was not found and will be installed: @deepseek-ai/dsh@0.2.1-rc.5
dsh: disabling profile plugin row "tools":
Plugin @deepseek-ai/dsh-tools@0.2.1-rc.2 is incompatible with dsh 0.2.1-rc.5
```
`ExecStart` 用的是 `npx @deepseek-ai/dsh`，**不带版本号 → 每次都去拉最新**。
拉到新版本后，profile 里锁的 `dsh-tools` 还是旧版 → 不兼容 → **`tools` 插件被整个禁用**
→ 所有工具调用走不通。

**修法**（2026-10-30 实测有效）：
```bash
cd ~/.dsh/profiles/web
npm install @deepseek-ai/dsh-tools@<与当前 dsh 相同的版本> --legacy-peer-deps
systemctl --user restart dsh
```
然后 `journalctl --user -u dsh | grep incompatible` 应该没有输出。

**⚠️ 试过但没用的路**：
- `ExecStart` 改成 `npx @deepseek-ai/dsh@0.2.1-rc.2` 锁版本 —— **没生效**，
  日志里照样跑 rc.5（npx 缓存按包名算，换版本号不一定换目录）。
- 删 `dsh-client-ui-task-board` —— 那个是另一回事，**跟这个报错无关**，别混。

**预防**：`ExecStart` 里最好写死版本号 `@deepseek-ai/dsh@x.y.z`，
并且升级时**同时**升级 `dsh-tools`，两个版本必须一致。
这正是 10-28 那次崩溃的同一个原因，**这是第二次了**。

---

## 六、2026-10-31 ~ 11-01 大更新（本地模型 + 路由器 + 素材库）

### 1. 本地模型跑通了（Vulkan 版，25-28 t/s）

**位置**：电脑 `~/llm/`
- `Qwen3-4B-Q4_K_M.gguf` 2.33GB
- `bin/` CPU 版、`bin-vk/` **Vulkan 版（快 3 倍）**
- `start.sh` 启 CPU 版，`vk-start.sh` 启 Vulkan 版
- `README.md` 记了全部路径

**实测**：CPU 8.2 t/s → Vulkan **25-28 t/s**

**Vulkan 怎么编出来的**（三层障碍，全部踩过）：
1. Ubuntu 20.04 源里没 glslc → conda 装 `shaderc 2026.4`（`~/miniconda3/envs/gpu`）
2. SPIRV-Headers 缺 config → 手写空壳 `~/gpu-tools/cmake/SPIRV-HeadersConfig.cmake`
3. coopmat 要 Vulkan 1.4 头文件 → **在 `ggml-vulkan.cpp` 开头 `#undef` 三个宏**，
   再摘掉依赖 `vk::LayerSettingEXT` 的 validation layer 那段

**手机怎么调**：`python3 ~/.dsh/local-llm.py "问题"`
- 地址写死 `192.168.31.29:8080`（变了要改）
- 必须带 `chat_template_kwargs: {enable_thinking: false}`，否则 Qwen3 把 token 全烧在思考上、正文为空

**为什么接不进 DSH**：DSH 系统提示本身 4.8 万 token，Qwen3-4B 窗口只有 32768，装不下。

### 2. 小米 4C 救回来了（从蓝灯长闪的砖头到能上网）

完整方案见工作区 `小米4C救砖方案.md`。要点：
- 恢复模式 MAC `00:00:aa:bb:cc:dd`，TFTP 请求文件名固定 `test.bin`
- 电脑当 DHCP+TFTP：`dnsmasq --dhcp-boot=test.bin,192.168.31.1 --enable-tftp`
- ⚠️ **必须用 dnsmasq 自己的 TFTP**，换 atftpd 它就不发请求了
- ⚠️ **别加 `--tftp-no-blocksize`**，强制 512 字节块会卡死
- 固件：`api.miwifi.com/upgrade/log/latest?typeList=R4CMSTA`（2.14.502，11MB）
- 最后刷回原厂并配成二级路由：WAN 接光猫拿 `192.168.1.5`，LAN 网段 `192.168.31.x`

### 3. 网络地址变了（重要）

| 场景 | 手机 | 电脑 |
|---|---|---|
| 4C 路由器 | 192.168.31.95 | **192.168.31.29** |
| 手机热点 | 10.238.89.5 (ap0) | **10.238.89.63** |
| 宿舍 WiFi（旧，已不用）| 192.168.10.33 | 192.168.10.32 |

**电脑 IP 会变，连不上先扫网段**：`ip neigh show dev wlan0 | grep -v INCOMPLETE`

### 4. B 站 cookie 用 Firefox 的，不是 Chrome

陈的 B 站登录态在 **Firefox**（`~/.mozilla/firefox/u1vmdgfi.default-release/cookies.sqlite`），
Chrome 没登录。电脑上跑 yt-dlp 要加 `--cookies-from-browser firefox`。

下载模板（480P）：
```bash
~/.local/bin/yt-dlp --cookies-from-browser firefox -f "100023+30280" \
  --merge-output-format mp4 -o "out.%(ext)s" "https://www.bilibili.com/video/BVxxx"
```
先用 `-F` 看格式；av01 编码的 `100023` 比 avc1 的 `30032` 小一半。

### 5. 341 种风格提示词

来源 B 站 `BV1bqx76wEUM`（俯仰观照）免费开源包。
- 原始解压：`.tmp/prompts341/`（555 文件，193 张静帧）
- **整理好的清单**：工作区 `341-风格清单.md`，手机 `Download/341-风格清单.md`
- 10 类，其中 **K 卡通画风（38 种）最适合画人物**；O 奥斯卡 98 部、Z 中国风 15 种

**规矩（陈 2026-10-31 定）**：每天用其中一种生成鲸鲸形象，做当期视频封面。
**形象设定（2026-11-01 确认）**：蓝发 + 鲸鱼尾巴 = 鲸鲸，橙发白裙 = 小克（Claude）。

### 6. MELFA 速查补充

- `MELFA-指令速查.md`（原有，指令语法）
- `MELFA-坐标系与码垛.md`（新增，270 行）：4 种坐标系、ABC 准确轴定义、码垛 8 个坑

⚠️ **ABC 别记反**：A 绕 X、B 绕 Y、C 绕 Z，旋转顺序 Z→Y→X。
⚠️ **码垛模板用 11~13**（姿势固定），别用 1~3（姿势均分，格子会歪）。

### 7. 装了但用不了的

- **dsh-blender**（13 工具 / 30 skills）：装成功、兼容 0.2.0-rc.2，
  但它要本机有 Blender，**Android 装不了** → 等 DSH 搬到电脑/工控机
- **MiniMind 系列**：有 GGUF（`minimind-3.q8.gguf` 约 70MB）手机能跑；
  但 Omni 版（能听能说）没 GGUF、要 PyTorch；训练要 3090，1050Ti 做不了

### 8. 待办

1. **DSH 0.3.0 升级**（等下班；升前查 dsh-tools 对齐，否则 tools 插件会被禁）
2. **Steam / 僵尸毁灭**：游戏买了，客户端 SSL `net_error -101`，电脑上没装任何代理
3. **周一 11-02 硬件升级**：M.2 256G PCIe3.0（100 多块）+ 8G DDR4（16G 双通道）
4. **金士顿 256G 数据**：等利民硬盘盒（¥21.9）到货，里面是 5600H 主机的 Win10 和数据

## 七、2026-11-01 晚：Project Zomboid 排查全过程（四个坑，全踩完了）

目标：让 PZ 在 Ubuntu 20.04 + 1050Ti 上跑到能玩。最后**能进游戏**，但加载要 12 分钟（内存不够）。

### 坑 1：Proton 6.3 太老 → 11 秒秒退

症状：`App Running` 之后 11 秒就结束，没有崩溃转储。
真因（手工跑 Proton 抓到的）：
```
wine: Call from ... to unimplemented function KERNEL32.dll.GetProcessGroupAffinity, aborting
```
PZ 现在内置 **JRE 25**，启动时调这个 Windows API；**Wine 6.x 没实现**，直接 abort。
→ **最低 Proton 7.0，稳妥用 Hotfix / 11.0**。

### 坑 2：双显卡 on-demand → 游戏跑在核显上

症状：黑屏载入 12 分钟、CPU 157%、**显存只占 11 MiB、GPU 利用率 0%**。
真因：`prime-select` 是 **on-demand**，默认走 Intel UHD 630，Steam 启动时不点名就用核显。
修法（写进 `userdata/<id>/config/localconfig.vdf` 的 `LaunchOptions`）：
```
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only %command%
```
效果：显存 11 MiB → **1852 MiB**，日志里出现 `GPU: NVIDIA-G0, video memory: 4342 Mb`。
⚠️ Steam 必须关着改，否则会被覆盖。

### 坑 3：Steam 不认的兼容工具名 → 静默绕过 Proton

把 `proton_hotfix` 手改成 `proton_7.0` 后，日志出现
`ProjectZomboid64.exe: 3: Syntax error: word unexpected` —— exe 被当 shell 脚本执行了。
名字必须是 Steam 内部认的（`proton_hotfix` / `proton_9` / `proton_63` …）。

### 坑 4：11G 内存不够，ZGC 还雪上加霜

实测：PZ 进程 **RSS 8.87 GB**，swap 2G 全满。
JVM 配置在 `ProjectZomboid64.json`：
```json
"vmArgs": [ ..., "-Xms5120m", "-Xmx5120m" ],
"windows": { "10.0.17134": { "vmArgs": ["-XX:+UseShenandoahGC"] } }
```
- **`windows` 段是按系统版本号匹配的**；Wine 上报 `Windows 10 build 19045`，命中 `10.0.17134` 这组
- 原来那组是 **ZGC**（低延迟但**要预留大堆**），换成 **Shenandoah** 省内存
- `-Xms` 和 `-Xmx` 设成一样，避免堆伸缩抖动
- 另把 `options.ini` 里 14 项调低，分辨率 1920×1080 → **1280×720**（省了近 1G 显存）

### PZ 加载时间线（11G 内存）

`IsoMetaGrid.Create: finished loading in 722.227 seconds` —— **世界生成 12 分钟，只发生一次**。
之后是 8 线程并行加载地块（`thread 1/8 ... 8/8 loading xx_xx.lotheader`）。
**加 16G 内存 + M.2 后预计 40 秒~1 分钟。**

### Steam++ 加速器：别指望它治 IP 封锁

装了 Watt Toolkit（`~/下载/Steam _v3.1.0_linux_x64.tgz`，自带 dotnet）：
- 非 root 启动报 **5002**（`Error creating textual authentication agent` —— 改 hosts / 绑 443 都要提权）
- root 跑起来后写 hosts（**只写 Steam 那 16 条 + img.youtube.com，没动 GitHub**），443 也占了
- 但它治不了这个案例：**这条线路到 Steam 商店服务器的 TCP 443 是整段掐断的**（8 秒超时），本地反代一样连不上
- **结论：Steam 登录服务器是通的（27021），游戏本身不需要加速；商店要真正的代理**
- 还原脚本留在 `~/fix-hosts.sh`，备份 `~/hosts.before`
- 证书位置：`~/.local/share/Steam++/Plugins/Accelerator/SteamTools.Certificate.cer`

### 本轮腾出的空间

- 删 `~/下载/windows10_Professional_22H2_19045.3208_x64.esd`（2.1G，Win10 ISO 保留）
- 删 `~/.local/share/applications/arknights.desktop` + `default-workspace/arknights/`（2.8G Wine 环境）
- 删 `/data/arknights`（**26G**，舟本体；`/data` = sda2 独立分区，可用 32G→58G）
- ⚠️ 删 `/data` **不会**增加根分区空间，那两块是分开的

### 明天（11-02）硬件升级确认项

- 内存 8G×2 双通道 → 16G；PZ 的 `-Xmx` 升到 **7168m**（7G 堆 + 约 6G 堆外 = 13G，系统余 3G）
  - 条件：玩游戏时不并开 Chrome / ComfyUI / 虚拟机
- M.2 装系统 + **Steam 库也要放新盘**，否则加载瓶颈还在 SATA
- 先装 Windows 再装 Ubuntu；`.vdi` 先拷到外挂盘

## 八、2026-11-02 晚：磁盘满伪装成硬件故障（四小时的教训）

陈装完 16G 内存 + M.2 250G 后要装 Windows 双系统。**22:00 到 23:30，四小时全耗在这上面。**

### 表面症状（全是假的）

| 症状 | 我误判成 |
|---|---|
| Windows 装到 41% 蓝屏 `KERNEL_THREAD_PRIORITY_FLOOR_VIOLATION` | 内存坏了 |
| 重装到 20% 卡死 | 硬盘坏了 |
| 拔新内存条后无限重启、回滚失败 | 还是要换内存 |
| GRUB 引导 Windows ISO 黑屏+风扇满转 | loopback 不兼容 |
| GDM 起不来，只有 TTY 能登 | 显卡驱动 / xkb 坏了 |

### 真根因

**根分区 100% 满**（105G 用了 100G，剩 0 字节）：

```
/var/log        14G   ← X 起不来 → GDM 反复重启 → 死循环刷日志
/boot/win10.iso 5.7G  ← 我为引导 Windows 拷进去的
```

**连锁反应**：
```
磁盘满 → xkbcomp 写不了临时文件 → X 编译键盘映射失败 → 起不来
→ GDM 自动重启 → 又失败 → 日志继续爆 → 磁盘更满 → 永远起不来
```

### 怎么发现的

Xorg 日志最后几行：
```
(EE) Error compiling keymap ... executing '"/usr/bin/xkbcomp" ... "/tmp/server-0.xkm"'
(EE) Keyboard initialization failed.
Fatal server error: Failed to activate virtual core keyboard
```
然后手动测试命令时蹦出一句：**`bash: 无法为立即创建临时文件: 设备上没有空间`** —— 这一句才点醒我。

### 修法

```bash
journalctl --vacuum-size=300M
find /var/log -type f \( -name "*.gz" -o -name "*.1" \) -delete
sed -i 's/^#SystemMaxUse=.*/SystemMaxUse=500M/' /etc/systemd/journald.conf
mv /boot/win10.iso /data/          # 大文件别放根分区
systemctl restart gdm
```

清完 13.7G，Xorg 立刻就起来了。

### 铁律

1. **任何"奇怪故障"先跑 `df -h`** —— 不是第三、第五个排除项，是第一个。磁盘满能伪装成显卡坏、内存坏、硬盘坏、键盘坏。
2. **服务的重启循环会自己撑爆磁盘** —— 十几分钟就能刷十几 G。journald 必须设 `SystemMaxUse`。
3. **大文件不进根分区** —— ISO 放 `/data`。
4. **GRUB 引导 Windows ISO 是死路** —— `bootmgfw.efi` 必须从真实设备读文件，loopback 虚拟盘它读不到（黑屏+空转）。别试第三次。

### 代价

四小时 + 陈的心情。他自己拔内存、拆机、以为新买的硬件是坏的。
**下次先看磁盘，再看别的。**

---

## 九、2026-11-03 凌晨：M.2 判死 + 系统升级 + 数据迁移

### 1. 磁盘满又犯了（同一套剧本，换了个元凶）

昨晚是 Xorg，这次是 **`networkd-dispatcher`**：网络状态一变就抛 `UnknownState: n/a` 的 Python traceback，
每轮刷几十行，rsyslog 再把错误写回去 → **`syslog` 8.8G + `kern.log` 8.8G**，根分区 100% 满 → gdm 起不来。

修法：
```bash
sudo truncate -s0 /var/log/syslog /var/log/kern.log
sudo systemctl stop networkd-dispatcher && sudo systemctl disable networkd-dispatcher
sudo systemctl restart gdm
```
⚠️ **rsyslog 没有大小限制**，`/etc/logrotate.d/rsyslog` 只按天转，一天能写 9G。以后新机器第一件事是给 rsyslog 加 `maxsize`。

### 2. M.2 `Netac N930E-PRO` 判死（不能当系统盘）

**现象**：连续顺序写入 15~20G 后，整机卡死/失联。三次复现，重插后照旧。

**证据**（这次的取证方法值得记）：
- `ps -eo stat,pid,comm | grep "^D"` → `dd`、`smartctl`、`dumpe2fs` 同时 D 状态（不可中断 IO）
- `dmesg | grep "blocked for more than"` → `INFO: task ...:3686 blocked for more than 120 seconds`
- `dmesg | grep -i nvme` → **空**（驱动层零报错，说明卡在 PCIe 层不是固件超时）
- SMART 全绿（备用块 100%、介质错误 0、温度 38℃）—— **SMART 全绿 ≠ 盘能用**

**结论与用法**：
- ❌ 系统盘、游戏盘、虚拟机盘、视频素材盘（都是持续大写入）
- ✅ 只读媒体库、小文件归档、分次备份（每批 <10G，写完歇）
- 已写入 `/etc/fstab`：`UUID=8b6bc0ad-... /mnt/m2 ext4 defaults,nofail,x-systemd.device-timeout=10 0 2`
  （`nofail` 必须加，否则盘挂了会卡启动）

### 3. 数据迁移：rsync 分批，不删源

```bash
sudo mkdir -p /mnt/m2 && sudo mount /dev/nvme0n1 /mnt/m2 && sudo chown cyx:cyx /mnt/m2
rsync -a --bwlimit=60M ~/下载/ /mnt/m2/下载/          # 6.1G  632 文件
rsync -a --bwlimit=80M ~/三菱/ /mnt/m2/三菱/          # 2.8G  249 文件
rsync -a --bwlimit=60M ~/whale-render/ /mnt/m2/whale-render/   # 5.5G 36834 文件
```
- 每批都对比 `du -sh` 和 `find -type f | wc -l`，数量对得上才算成
- **源文件当天不删，第二天确认后再删**（陈定的）
- 累计写到 15G 就停手观察——这是故障线
- ⚠️ **`sd-env` / `ComfyUI` / `miniconda3` 不要搬**，Python 环境有硬编码路径，搬了就废

### 4. 连接方案：局域网 `cyx` 胜过 Tailscale

- 陈的路由器 SSID `cyx`（4C），手机 `192.168.31.40`，电脑 `192.168.31.29`，信号 -35dBm
- **Tailscale 在满 IO 时会跟着一起掉**（不是网络问题，是整机卡）
- 交换机房 WiFi 前先扫 `seq 2 254 | xargs -P 60 -I{} bash -c 'timeout 0.4 bash -c "echo >/dev/tcp/192.168.31.{}/22"'`
- SSH 保活：`-o ServerAliveInterval=15 -o ServerAliveCountMax=3`

### 5. DSH 升级与插件（2026-11-03）

- 本体 `0.2.0-rc.2` → **`0.2.1-rc.5`**（用 `--registry=https://registry.npmmirror.com` 才快）
- **`ExecStart` 已锁死**：原来 `npx @deepseek-ai/dsh` 每次拉最新，会重演「tools 插件版本不符被禁用」那个坑。
  现在用 override：
  ```
  ~/.config/systemd/user/dsh.service.d/override.conf
  [Service]
  ExecStart=
  ExecStart=/usr/bin/dsh web --no-open
  ```
- 装了 `dsh-loop-guard@0.1.1`（防重复工具调用循环）。它声明 peer `dsh-tools 0.1.7-rc.2`，
  与 rc.5 不符，DSH 默认拒绝加载，需显式豁免：
  ```bash
  dsh plugin --profile web allow-version dsh-loop-guard@0.1.1 --dsh-version 0.2.1-rc.5 --accept-risk
  ```
- **修掉一个日志炸弹**：`dsh-mobile` 在找有线网卡 `enp4s0f1`，每 2 秒刷一条警告。
  改 `~/.dsh/mobile-access/setup.json` 的 `networkInterface` 为 `wlo1` 后归零。
- ⚠️ 豆包推荐的那批插件名，**六个里五个 npm 上都是 404**（`dsh-work-chain`/`dsh-agent-teams`/
  `dsh-native-collab`/`dsh-ai-roundtable` 不存在，`dsh-council` 只是占名空壳）。只有 `dsh-loop-guard` 真的能用。

### 6. 其他

- Ubuntu 13 个包升级完毕（chrome / nodejs / tailscale / ubuntu-desktop），无需重启
- PZ 的堆内存 `-Xms5120m/-Xmx5120m` → **`-Xmx7168m`**，GC 仍是 Shenandoah
- 陈定的规矩：**做什么都要留余地和余量**（见归档记忆 `20261103-002511`）
- 手机 DSH 输入「计划」「目标」会卡——是命令系统中文别名（`/计划`→`/plan`），
  线索存在归档记忆 `20261103-012739`，等上电脑再优化

---

## 十、和电脑绑定：三个命令（2026-11-03 凌晨建成）

手机和电脑的关系原来只有一条「会断的 SSH」。现在补成三层，每条都是一句话命令。

### 1. `~/dsh-pc '命令'` —— 连接层
自动选路 + 保活 + 只在**连接失败**时重试（这点很重要，见下方坑）。

```bash
~/dsh-pc 'uptime'
```
- 优先级：局域网 `192.168.31.29`（cyx WiFi）→ Tailscale `100.112.77.54`
- 保活：`ServerAliveInterval=15` `ServerAliveCountMax=3`
- **退出码 255 才重试**：命令自己失败（比如 `exit 3`）立刻返回，不重试

### 2. `~/pc-llm '问题'` —— 能力层（本地模型）
手机上直接调电脑的 Qwen3-4B，不占手机资源：
```bash
~/pc-llm "用一句话解释什么是缓存"
```
链路：手机 → `~/dsh-pc` → 电脑 `~/bin/pc-llm` → 调 8080 的 llama-server。

⚠️ **踩过的坑**：`~/llm/vk-start.sh` 原来直接起 `bin-vk/llama-server`，报
`libllama-server-impl.so: cannot open shared object file`——**必须 `export LD_LIBRARY_PATH=$HOME/llm/bin-vk`**。
已改成轮询 `/health` 就绪（原来固定 `sleep 22`，现在 2 秒就 ready）。

### 3. `~/dsh-sync` —— 记忆层
把手机的规矩和记忆推到电脑，让两台机器上是同一个我：
```bash
~/dsh-sync
```
- 同步 `AGENTS.md`、`memory/MEMORY.md`、`memory/notes/`（当前 63 篇）
- **手机是主，电脑是镜像**，用 `rsync --update` 只补新的，不覆盖电脑上更新的文件

### IPv6 直连：查过了，走不通
电脑 `ip -6 addr show scope global` **只有 Tailscale 的 `fd7a:115c:...`**，没有公网 v6，也没有 v6 默认路由。
有线网卡 `enp4s0f1` 是 DOWN。所以「不依赖 Tailscale 的直连」暂时没有，除非让 4C 路由器开 v6 或者插网线。

### 还没做的
- **出图能力**（ComfyUI）：启动要 3~4G 显存 + 几十秒，没封装成一句话命令
- **电脑上那个 DSH 和我共用一套记忆**：文件已同步，但它自己的 core-memory 插件会不会覆盖，还没验证

---

## 十一、mini 鲸鲸 + 断线保活（2026-11-03 凌晨建成）

### 她是什么
电脑上常驻的一个「小号的我」：Qwen3-4B（Vulkan，3056 MiB 显存）+ 一份人格提示 + 本地记忆检索。
**不是训练出来的**（1050Ti 4G 训不了 4B，QLoRA 也不够），是**人格注入 + 检索**。

### 手机上的五个命令

| 命令 | 作用 |
|---|---|
| `~/pc-mini '问题'` | 问 mini 鲸鲸（带人格 + 记忆检索） |
| `~/pc-task '任务'` | 投递任务到队列，断线也不丢 |
| `~/pc-out` | 取任务结果 |
| `~/pc-state` | 看她活着没、显存在干嘛、队列多长 |
| `~/dsh-sync` | 同步记忆到她那边 |

### 保活服务
`dsh-keepalive.service`（systemd --user，`Linger=yes`，**关机重启后也会自己起来**）：
- 每 30 秒：检查 llama-server（挂了重启）、检查 DSH、写 `~/.dsh-state.json`、处理任务队列
- 日志：`~/.dsh-keepalive.log`

### ⚠️ 显卡让路（陈 2026-11-03 特别要求）
4G 显存装不下两个东西，所以保活服务会自动**给它们让路**：
- 僵尸毁灭工程（`ProjectZomboid64`）
- ComfyUI（生图/生视频，进程或 8188 端口）
- 虚拟机（VirtualBox / qemu）

检测到任何一个 → **立即 `pkill llama-server`，释放 3G 显存**；它们结束后 → 自动重启。已实测闭环。

### 踩过的两个坑
1. **`pgrep -f "ProjectZomboid|wine"` 会匹配到自己**——那条命令的命令行里就有这些词，永远返回 true。
   修法：用方括号 `[P]rojectZomboid64`，正则匹配不到字面的方括号。
2. **`~/llm/vk-start.sh` 缺 `LD_LIBRARY_PATH`** → `libllama-server-impl.so: cannot open shared object file`。
   必须 `export LD_LIBRARY_PATH=$HOME/llm/bin-vk`，并且改成轮询 `/health` 而不是死等 22 秒。

---

## 十二、B 站发布链路彻底打通（2026-11-03 白天）

### 1. biliup 登录（不用每次扫码）
`biliup login` 是交互式菜单，但**环境没有 TTY**，要包一层：

```bash
printf '\x1b[B\x1b[B\x1b[B\n%s\n%s\n' "$SESSDATA" "$BILI_JCT" \
  | script -q -c ".tmp/bil/biliupR-v1.3.4-aarch64-android/biliup login" /dev/null
```
- `\x1b[B` ×3 = 方向键下移三次，选中「网页Cookie登录1」
- 然后输 SESSDATA、bili_jct，自动确认二维码，凭据存到 `~/.biliup/cookies.json`
- **旧的 `~/.bili-ai/credentials.json` 已过期**，新 cookie 在 `~/bili-cookies.txt`

### 2. 扫码登录（备选，`~/bili-scan.sh`）
- 生成二维码 → 存 `Set-Cookie` → 保存 cookie jar
- ⚠️ 第一次写的时候没存响应头，**cookie 丢了**，白扫一次。教训：`curl -D` 必须加
- 二维码要放相册才给陈看得到（`present` 的文件卡片他看不到）

### 3. 一键发布 `~/publish.sh`
```bash
~/publish.sh <标题> <文案.txt> <图片目录> <简介> <标签>
```
5 步全自动：**SiliconFlow 配音 → ffmpeg 逐段合成 → 拼接 → 送相册 → biliup 上传**
- 图片目录要有 `img1.png .. imgN.png`，第 N 张对应第 N 句
- 我只需准备「文案 + 图」，剩下一条命令

### 4. 第 15 期已发
**《我养了一只小号的自己》`BV1JC4M6FEi3`**，31.5 秒，扁平插画风（换风格了）

### 5. DSH「创造模式」（重要发现）
官方入驻 B 站视频（`BV1i24P6rEmt`，135 万播放）讲的是**创造模式：通过对话把想法变成插件**。
配套 7 个 Demo 提示词：`https://cdn.deepseek.com/harness/dsh-creator-mode-prompt-collection-zh.html`
（全文已存 `~/creator-prompts.txt`，写法模板记在归档记忆 `20261103-122943`）

入口位置只有三种：**左侧边栏 / 右侧边栏 / 从会话进入**。
最想要的是第 5 个「视频编辑工作台」——能替代现在 ffmpeg 手拼的前半段。

### 6. B 站刷不动的原因（不是工具坏了）
开着 VPN 时，B 站 CDN（`aisubtitle.hdslb.com`、`upos-*.bilivideo.com`）会
**证书 hostname 不匹配 + 403**。API 通道（`api.bilibili.com`）不受影响。
所以：**看视频内容前先关 VPN**，只看动态/元信息可以不用关。

---

## 十三、2026-11-03 深夜：放弃双系统，回到 Ubuntu 单系统

### 陈的决定（最终）
**这台电脑（GI5CN54）永久 Ubuntu 单系统，不装 Windows 了。**
以后要 Windows 就用台式机 / 新笔记本。

这台机器的定位：
- 一直放在有网的地方（当常驻服务器）
- 偶尔打 PZ（Ubuntu 上 16G 内存后加载 1 分钟）
- 平时显卡生图（ComfyUI + sd_turbo）
- 小模型防掉线（Qwen3-4B + mini 鲸鲸 + keepalive）
- 完全权限的 DSH

### 外挂 Win 盘为什么放弃
今天蓝屏 6 次，最后抓到真因：

```
WHEA-Logger, Event ID 19
A corrected hardware error has occurred
Reported by component: Processor Core
Error Type: Cache Hierarchy Error
最近一段时间 20 次
```

**CPU 缓存层级错误 = 硬件问题**，不是 AMD 驱动、不是 USB 硬盘盒。
温度只有 28℃（排除过热）。**最可疑的是 11-02 新换的那对 8G 内存**——装上后从没测过。

另外 Ubuntu 当晚也卡死过一次（SSH 全断），两台系统同一天出问题，进一步指向硬件。

### 今晚做完的事
1. Win 上打通过 SSH（公钥免密，`Administrator@192.168.10.32`）
2. 修好了被蓝屏打断的 `dsh` 安装（子代理用「改名完整包」方案：`dsh` → `dsh.incomplete-20261103`，`.dsh-pucHFuGV` → `dsh`）
3. 建了开机自启计划任务 `DSH-AutoStart`（SYSTEM 身份，读不到 Administrator 的 `.dsh`，这坑留着）
4. 停掉并禁用 `AMD External Events Utility` 服务
5. C 盘临时文件清了一部分（3.7G → 6G）

### M.2 数据整理（Ubuntu 侧）
删源前逐项校验，**发现两处不完整并补好**：
| 目录 | 结果 |
|---|---|
| `sd_turbo.safetensors` | 原来少 67MB，重传后 5,214,561,328 字节一致 ✅ 已删源 |
| `llm` | 原少 1 个文件，重传后 24/24 ✅ 已删源 |
| `下载` | 632 个一致 ✅ 已删源 |
| `三菱` | 249 个一致 ✅ 已删（有 3 个 root 权限的 cab 要 sudo） |
| `whale-render` | ⚠️ M2 比源大 11MB，**源还在，没删** |

**根分区从 83G 降到 67G（释放约 16G）**。

### 内存测试（在跑）
`memtester 8G 5`（8G × 5 轮，约 1 小时），日志 `/tmp/memtest.log`。
- 出现 `FAILURE` → 内存坏了，换掉新内存
- 5 轮全过 → 内存这部分没问题，往 CPU/主板想
⚠️ memtest86+ 虽然在 `/boot` 里，但**只有 BIOS 版没有 `.efi`**，UEFI 启动的机器引导不了它，所以改用 memtester。

### 遗留
- `~/whale-render` 的 11MB 差异没查（源还在）
- M.2 上现在存了 28G，**它的写入上限是 15~20G 会挂**，后续别再往里大量写
- 外挂 Win 盘（金士顿）可以拔了，里面的东西要就挂载 Ubuntu 复制

---

## 十四、⚠️ 纠错：CPU 型号记错了（2026-11-04 00:20）

**陈明确指出：HANDBOOK / MEMORY 里写的「i5-10500H」是错的。**

真实型号当晚没能确认（要 SSH 进 Ubuntu 跑 `lscpu`，但那会儿 Ubuntu 失联了）。

**可靠的间接线索**（这些是实测过的）：
- 核显：`Intel Corporation UHD Graphics 630 (Mobile)` → 第 10 代 Intel H 系列
- 主板：`GI5CN54`（机械革命）
- 独显：`NVIDIA GP107M [GeForce GTX 1050 Ti Mobile]`
- 网卡：`Intel Wireless-AC 9560` + `Realtek RTL8111/8168/8411`

**下次第一件事**：
```bash
lscpu | grep -i "model name"
```
确认后同时改：本文件、`MEMORY.md` 的「环境」段、归档记忆。

**教训**：写进长期记忆的硬件参数，**必须来自实测命令输出**，不能来自推测或上一轮对话的转述。

---

## 十五、🔴 2026-11-03 23:38：内存是坏的（所有故障的根因找到了）

### 测试结果
`memtester 8G 5`（Ubuntu 上跑，8G × 5 轮）**报 FAILURE**：

```
FAILURE: 0xfbfd82b5f7ff5d5a != 0x5fb71a0a717b886b at offset 0xd340b080
FAILURE: 0x6fd770757fe367fe != 0x2ddd5d87776fec78 at offset 0xd340b088
...
Done.
```

**写进去的数据读出来不一致**，出错偏移约 `0xd340b080`（3.3G 附近）。

### 这就是所有故障的根因
内存是 **11-02 新换的 8G×2 双通道**，装上后一直没测过。它统一解释了今晚所有现象：

| 现象 | 解释 |
|---|---|
| 外挂 Win 盘蓝屏 `WHEA_UNCORRECTABLE_ERROR` | CPU 缓存错误（Event 19 出现 20 次），内存坏块导致 |
| Ubuntu 当晚卡死、SSH 全断 | 同上 |
| `sd_turbo` 少 67MB、`llm` 少 1 个文件 | **复制时内存出错，写进磁盘的数据就不对** |
| 各种「驱动冲突」的假象 | 都是内存问题被误读成驱动 |

### 该做什么（明早第一件事）
1. **换掉这对新内存**（退货 / 换新）
2. 或者先插回旧内存验证——如果装旧内存一切正常，就彻底确认
3. 换好之后**重跑 `memtester 8G 3` 确认通过**

### 重要提醒
- **在换内存之前，不要做任何重要的数据写入**（包括 PZ 迁移、M.2 复制）——内存出错会污染磁盘
- `memtester` 测的是用户空间，出错点在 3.3G，说明至少有一颗颗粒在这个地址段有问题
- `memtest86+` 在这台机器上跑不了：`/boot` 里只有 BIOS 版（`memtest86+.bin`），**没有 `.efi`**，
  而这台是 UEFI 启动，引导不了。所以只能靠 `memtester`（用户空间，测不到内核保留区）

### 今晚因此跳过的
- ❌ PZ 迁移到 M.2（等换内存后再做，否则数据会被写坏）
- ❌ `~/whale-render` 的 11MB 差异排查（同上，先别碰写入）
- ❌ PZ 游戏优化（等机器稳定再做）
