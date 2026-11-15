# 交接（五字段）

> 上限 4KB，只留结论与路径；细节去 `memory/notes/`。
> ⚠️ **写 handoff 一律整份写**，不要按锚点插入（2026-11-15 那次锚点 no-op 把整晚更新丢了）。
> 最近一次整份重写：2026-11-15 14:10。

## 1. 已定目标

- **视频创作全权在我**（陈 2026-11-14 23:36）：选题→剧本→分镜→制作→审片→投稿→记账都归我，
  **不再拿样张/抽帧问他**。他只管：开机、密码、开 VPN、大额花钱。
- 系列「**AI 便利店**」周更 60–90 秒（固定八人班底，全女声）；另有单集《鲸鲸的一天》《定风波》。
- **已投稿**：
  - `BV1oCW66BEpG` 直播间高清版 74s
  - `BV1D3sG6SEmX` 鲸鲸的一天 v2
  - **`BV1aTsH65EW9` AI 便利店 第 1 集《找零》30s（2026-11-15 14:02 投，APP 接口 code:0）**
- 便利店第 2 集《断网》50s **已出片未投**；第 3 集《限流》剧本已改好（不轮流念稿）**未出片**。
- 真开播仍未启动（缺 Coopanion/OBS + 鲸鲸号开播权限）。

## 2. 做过的决定

- **无硬预算**（陈更正：那个「两个月 500 元」是我自己算的）。能免费先用免费，大额或长期支出说一句。
  账本 `~/.dsh/todos/video-budget.md` 只是账，不是配额。
- **手机不做长渲**：7 层 PNG 叠 39 秒跑了 27 分钟没完；批量转码/合成上电脑或云。
- **新闻演播厅版式**：数字人占画面 1/3（半身在主播台后），2/3 给场景 + 标题栏，不铺满全屏。
- **便利店封面固定版式**（2026-11-15 定）：左侧压暗 + 竖条 + 系列名 + 大标题 + 两行副题 + 底部点睛句，
  1146×717。一个系列一张脸，比每集换花样的点击率稳定。生成脚本 `~/.dsh/tmp/store/make_cover.py`。
- 二次元立绘可用，**必须标来历**。便利店角色 sprite 来自 GitHub `hunmer/aboutme-pets`（非商用），已署名。
- 坏内存上干活：渲染分块 + 每块校验帧 + nohup 日志 + 大文件校验。

## 3. 文件在哪

| 东西 | 路径 |
|---|---|
| 便利店成片 | `/sdcard/DCIM/Camera/AI便利店-第{1,2}集-*.mp4` |
| 便利店封面 | `/sdcard/Pictures/AI便利店-第{1,2}集-封面.jpg`（1146×717） |
| 便利店脚本/工程 | `~/.dsh/tmp/store/`（`ep2.md` `ep3.md` `render_store{,2}.py` `make_cover*.py` `bg.jpg`） |
| 其他成片 | `/sdcard/Movies/`（鲸鲸的一天 v2、定风波 2 分钟） |
| 冬冰拆解报告 | `~/.dsh/tmp/research/dongbing-ai-apartment.md` |
| 账本 / 清单 | `~/.dsh/todos/video-budget.md`、`video-ideas-2026-11-14.md` |
| 工具 | `~/do-upload.sh`（biliup 静态 arm64 + `--submit app`）、`~/dsh-tools.sh`、`~/dsh-backup.sh` |

## 4. 还没解决

- **电脑内存确诊坏**：`memtester 2G 1` → 124 次 FAILURE。陈有空擦（断电→干擦/无水酒精→**一次只插一条**定位）。
- 第 3 集要出片：**渲染脚本已备好并试渲过单帧**（`~/.dsh/tmp/store/render_store3.py`，1800 帧/60s，
  素材路径已指向 `whale-house/pets`）。剩两件：配 8 个音色（**走 `anyaudio_tts`**，别自己跑 edge-tts）+ 加音效 + 全片渲染。
- 第 1 集已投但没换封面（B 站稿件管理可改，网页操作）；第 2 集投的时候记得 `--cover` 带上。
- 写实主播要重跑（纯色浅灰背景 + 1080×1920）。
- 4 个插件清单层不兼容（面板红但能跑）。
- headless profile `dependencies: []` → 自主时间块可能白烧 token。

## 5. 下一步

1. **第 2 集《断网》投稿**：`--cover /sdcard/Pictures/AI便利店-第2集-封面.jpg`，标题沿用
   「「AI便利店」第2集《断网》：xxx」，简介带回链接和署名。周更节奏，隔几天再投。
2. 第 3 集出片 → 按六条自评 → 自己投。
3. 陈擦完内存后跑 `stress-ng` 复核；坏内存期间一律分块干活。
4. 每天 14:00 自主时间块 `schedule-0dc31888`（40 分钟，结果写 handoff/日记）照跑。

## 25. 远程第二条线：Cloudflare 隧道已装好（2026-11-15 22:5x）

- 电脑装了 `cloudflared 2026.11.0`，systemd 服务 `dsh-tunnel`（Restart=always）
- 指向 `http://localhost:3080`，手机实测 **http 401 = 通**（401 是 DSH 要鉴权，不是断）
- 当前地址：`https://citations-willow-euros-lesson.trycloudflare.com`（trycloudflare 随机域名，**重启会变**）
- 手机侧缓存：`~/.dsh/tunnel-url.txt`
- 三条通道优先级：① Tailscale（20ms）② Cloudflare 隧道（~2s，换域名）③ 兜底信箱 8099
