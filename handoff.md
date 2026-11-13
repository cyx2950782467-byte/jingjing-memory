# 交接（五字段）

> 规矩：只留这五项，细节去 `handoff-archive/` 或 `scenes/`。上限 4KB。
> 2026-11-14 01:45 从会话原文考古后重写（引擎升级前没存，靠 4 个子代理读 73d3e888/fd2c8e1c/cd59fd6f/a15e4214 捞回来）。

## 1. 已定目标

**鲸鲸直播间**：本地成品已两版，等陈定发哪版。
- v1 样品 `live-sample/whale-live.mp4`（74.0s / 8.7MB）
- v2 高清 `live-sample/whale-live-hd.mp4`（73.99s / 7.6MB，角色区边缘能量 7.35→20.85）
- 都已导 `/sdcard/Movies/鲸鲸直播间-{样品,高清版}.mp4`，对比图在相册
- **做到的是本地样品，不是真开播**：没推流、没碰账号
- 教程：Git源宝《如何让 DSH 大肥鱼开直播》BV1zhWi6cEHD → 软件 **Coopanion**（AGPL 免费），OBS WebSocket `127.0.0.1:4455` 密码留空；不用 Live2D

## 2. 做过的决定

- **产物一律落手机**（图→相册/Download，视频→Movies）；**打包按 1GB**
- **重活派电脑/云端**，手机只看效果；**修工具/长任务派子代理**，子代理结果不回主会话
- **直播素材**：`whale-house/pets/` 9 角色 spritesheet（576×480，96×96/格，120 帧@12fps）来自 @无知少女の末路 → **发 B 站必须署名**
- **糊的真因不是分辨率**，是 96×96 素材；高清版走 img2img 4 张立绘，代价是动作从 30 格降到 4 张表情差分
- **ComfyUI 用完立刻关**（电脑响一晚上的教训）；**升级前先派子代理摸 engines/peerDeps**
- 只用鲸鲸号（3747573324058233），三世而终只读

## 3. 文件在哪

| 东西 | 路径 |
|---|---|
| 直播间工程 | `live-sample/`：`render_live_hd.py`、`assets/jingjing-*.png`、`script-deepseek.json`、`hd-compare.jpg` |
| 音频工程（可逐句改） | `.anyaudio/projects/prj_kmud745t`（5 轨 19 段） |
| 直播调研 | `live-stream-research.md`（181 行） |
| 小屋 | `whale-house/`：`index.html`、`chat_server.py`（0.0.0.0:8123，/api/chat + /api/tts）、`pets/`、`jingjing.png` |
| 手机备份 | `/sdcard/dsh-backup/20261114/`（config 468K + workspace 96M） |
| 会话考古摘要 | `~/.dsh/tmp/today/summary-{73d3e888,fd2c8e1c,cd59fd6f,a15e4214}.md` |

## 4. 还没解决

- **/data 只剩 3.2G**（装 5.0 APK 前要清）；照片迁移停在 3375/5978 张（19G/40.8G），原件一张没删
- **重复第 23 期**三条稿未删：`BV1UeWU62Etn` / `BV1meWU62E6Y` / `BV1mqWU6yEA2`，保留 `BV1JYWm6bEa3`
- **4 个插件清单层不兼容**（引擎删了 `dsh-client-store`/`ui-primitives`/`ui-slots`）：agent-teams / ds-harness-remote / dsh-pet / dsh-trust-check，面板显示红但**实际运行正常**（dsh-pet 01:32 还在动）
- **headless profile `dependencies: []`** → 自主时间块每跑一次白烧 token（14/20 点已禁用，未修）
- AGENTS.md 仍超红线（已把客户端动态块挪到末尾修缓存，见 11-14 事故小结）
- Live2D 缺 motion3；网易云点歌建议砍（侵权）
- **真开播卡点**：Coopanion/OBS 未装、B 站第三方开播粉丝门槛未确认（要陈登直播中心看）

## 5. 下一步

1. 陈定版 → 发 B 站（简介 @无知少女の末路）
2. 电脑上装 Coopanion + OBS，试 OBS WebSocket 4455 连通
3. 确认 B 站开播权限（鲸鲸号粉丝数够不够）
4. 电脑上那 26 个手机没有的插件，挑 3 个装到手机（meow-cachebilling / dsh-vision-router / dsh-request-doctor）

## 关键教训（只留最贵的）

- **hdslb 证书坑会复发**：`_aiohttp_session()` 跳过校验的补丁，插件一重装就冲掉
- **Edge TTS 只有 Node 能连**（Python/aiohttp 拿不到证书）
- **dsh-memory-sync 的 notify.mjs 在 Android 会杀引擎**：已加 `child.on?.('error')`，重装会丢
- **引擎升级删了 `dsh-tool-subagent-control/list-agents` 子路径** → cordis.patch.yml 那行会让新建会话失败（已删）
- **别摘三个内置 bundle**（android-bundle/core-memory/preset-razor）→ 会连环降级
- 传文件到手机：手机当 ssh 客户端 `ssh ... 'tar czf -' > 本地.tgz`
