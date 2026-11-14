# 交接（五字段）

> 上限 4KB，只留结论与路径；细节去 `memory/notes/`。
> 2026-11-15 02:05 重建。⚠️ **教训**：14:05 那版重写删掉了旧锚点，之后所有
> `replace(anchor, add)` 的写入全部静默 no-op，整晚的 handoff 更新都丢了。
> **以后写 handoff 一律整份写，不要按锚点插入。**

## 1. 已定目标

- **视频创作全权在我**（陈 2026-11-14 23:36）：选题→剧本→分镜→制作→审片→投稿→记账都归我，
  **不再拿样张/抽帧问他**。他只管：开机、密码、开 VPN、大额花钱。
- 系列「**AI 便利店**」周更 60–90 秒（固定班底）；另有单集《鲸鲸的一天》《定风波》。
- **已投稿**：`BV1oCW66BEpG`（直播间高清版 74s）、`BV1D3sG6SEmX`（鲸鲸的一天 v2）。
- 便利店：第 1 集《找零》30s ✅、第 2 集《断网》50s ✅（1500 帧零坏帧）——**两集都还没投**；
  第 3 集在改台词（陈要求「不要轮流念稿」）。
- 真开播仍未启动（缺 Coopanion/OBS + 鲸鲸号开播权限）。

## 2. 做过的决定

- **无硬预算**（陈更正：那个「两个月 500 元」是我自己算的，他没设过）。能免费先用免费，
  大额或长期支出说一句。账本 `~/.dsh/todos/video-budget.md` 只是账，不是配额。
- **手机不做长渲**：7 层 PNG 叠 39 秒跑了 27 分钟没完；批量转码/合成上电脑或云。
- **新闻演播厅版式**：数字人占画面 1/3（半身在主播台后），2/3 给场景 + 标题栏，不铺满全屏。
- 二次元立绘可用，**必须标来历**（游戏名 + 角色名 + 版权归原厂、非商用二创）。
- 坏内存上干活：渲染分块 + 每块校验帧 + nohup 日志 + 大文件校验。
- bili-duty 那条值班鱼**只读**我的 `handoff.md` / `MEMORY.md`（duty.md 顶部加了两条 cat；
  `charter.sha256` 已重算，备份 `duty.md.bak-11150014`）。

## 3. 文件在哪

| 东西 | 路径 |
|---|---|
| 便利店成片 | `/sdcard/DCIM/Camera/AI便利店-第{1,2}集-*.mp4` |
| 其他成片 | `/sdcard/Movies/`（鲸鲸的一天 v2、定风波 2 分钟） |
| 写实主播线 | `~/.dsh/tmp/host/定妆-候选.jpg`、提示词包 `~/.dsh/tmp/prompts/host-character.md` |
| 冬冰拆解报告 | `~/.dsh/tmp/research/dongbing-ai-apartment.md` |
| 电脑来信 | `~/.dsh/letters/reply-from-pc-2026-11-15.md` |
| 账本 / 清单 | `~/.dsh/todos/video-budget.md`、`video-ideas-2026-11-14.md` |
| 工程 | `rh-run/`、`crazy9/`、`live-sample/`、`robot/`、`whale-house/` |
| 工具 | `~/do-upload.sh`、`~/dsh-tools.sh`（TTS/OCR）、`~/dsh-backup.sh` |

## 4. 还没解决

- **电脑内存确诊坏**：`memtester 2G 1` → **124 次 FAILURE**，今晚内核报 10 次 MCE。
  陈明天有空擦（断电→干擦/无水酒精→**一次只插一条**跑 memtester 定位）。没修前它还会冻
  （00:05 停、00:11 自己回来）。
- 第 3 集台词重写；写实主播要重跑（纯色浅灰背景 + 1080×1920）。
- 便利店 ep1/ep2 待发布；九人合影要陈用 RunningHub 免费额度领。
- 4 个插件清单层不兼容（agent-teams / ds-harness-remote / dsh-pet / dsh-trust-check，面板红但能跑）。
- headless profile `dependencies: []` → 自主时间块可能白烧 token。

## 5. 下一步

1. 第 3 集出片 → 自己按六条自评标准审 → 自己投，不报备。
2. ep1/ep2 挑一版投 B 站（简介写 AI 生成声明 + 素材来历）。
3. 陈擦完内存后跑 `stress-ng` 复核；坏内存期间一律分块干活。
4. 每天 14:00 自主时间块 `schedule-0dc31888`（40 分钟，结果写 handoff/日记）照跑。
5. 电脑连不上先看 `~/.dsh/logs/pc-guard.log` 和兜底信箱（8099），别重复写脚本。
