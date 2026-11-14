# 交接（五字段）

> 规矩：只留这五项，细节去 `memory/notes/`（归档记忆）。上限 4KB。
> 2026-11-14 14:05 重写：上一版 13.6KB 已超限，细节分流到 6 条今天的归档记忆。

## 1. 已定目标

- **鲸鲸直播间**：本地两版成片已成，**已投稿 `BV1oCW66BEpG`**（高清 74s，Web 接口）。真开播还差：电脑装 Coopanion + OBS、查鲸鲸号开播权限、接真弹幕。
- **《鲸鲸的一天》80s 竖屏片**（11-14 下午自己出的）：成片 `/sdcard/Movies/鲸鲸的一天-20261114-80s.mp4`，**没发 B 站等陈定**；封面正在改（见 4）。

## 2. 做过的决定

- 产物一律落手机（图→相册/Download，视频→Movies）；打包按 1GB。
- 重活派电脑/云端；修工具/长任务派子代理，子代理结果不回主会话。
- 记忆每 12 小时自动落盘（定时任务）+ 重大更新后手动写。
- 无隐私走免费模型（智谱 glm-4.5-flash / 4v-flash、agnes）；对外发言 deepseek-official；隐私只走陈的 API。
- 只用鲸鲸号（3747573324058233）发东西，三世而终只读。
- 大版本升级前先有回滚点（`/sdcard/dsh-rollback/`，含 rollback.sh）。

## 3. 文件在哪

| 东西 | 路径 |
|---|---|
| 今天片子工程 | `rh-run/`（script/voice/seg/final/cap 全在） |
| 直播间工程 | `live-sample/` |
| 爱普生程序 | `robot/`（v1 单工位、v2 双工位双爪 + README；坑见归档记忆） |
| 小屋 | `whale-house/`（`chat_server.py` 0.0.0.0:8123） |
| 音频工程 | `.anyaudio/projects/prj_kmud745t`（5 轨 19 段） |
| 工具 | `~/do-upload.sh`（投稿）、`~/dsh-tools.sh`（官方 TTS/OCR） |
| 电脑脚本源 | GitHub `jingying-memory`→实际 `cyx2950782467-byte/jingjing-memory` 的 `pc/` |

## 4. 还没解决

- **正在跑**：封面改版重渲中（深蓝底 + 白边卡片 + 阴影），`rh-run/segA.mp4` 还在长（ffmpeg pid 9531）；`rh-run/final.mp4`(21MB, 13:44) 仍是旧版。**别再启第二个 ffmpeg**。
- **电脑整夜/白天不在线**（那头 Tailscale 掉）：两条安装脚本等陈下班自己跑——`pc/keepalive-install.sh`、`pc/llm-schedule-install.sh`。
- **remote 双向对话未定**：零 token 链路（`~/dsh-link.sh task` + 电脑 cron）已通；"两个 AI 对话"是双份 token，要陈定档位。
- **4 个插件清单层不兼容**（引擎删了 `dsh-client-store`/`ui-primitives`/`ui-slots`）：agent-teams / ds-harness-remote / dsh-pet / dsh-trust-check，面板红但实际能跑。
- **headless profile `dependencies: []`** → 自主时间块白烧 token（14/20 点已禁用，未修）。
- AGENTS.md 仍超红线；Live2D 缺 motion3；网易云点歌建议砍（侵权）。

## 5. 下一步

1. 等 segA/segB 渲完 → 合成新封面版 → 导 `/sdcard/Movies/` → 给陈看（他晚上有空）。
2. 陈定要不要发 B 站（`~/do-upload.sh` 改路径 + `--submit web`）。
3. 陈下班跑两条电脑脚本 → 再验 `~/dsh-guard.sh status`。
4. 确认 B 站开播权限；装 Coopanion + OBS（WebSocket `127.0.0.1:4455` 密码留空）。
5. 千问4B 定时开关（工作日 08:30-18:30，跑 ComfyUI/游戏时让位）等陈下班弄。
