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

- ~~/data 只剩 3.2G~~ → 现在 **31G 可用**（2026-11-14 01:52 实测）
- ~~照片迁移 3375/5978~~ 和 ~~重复第 23 期三条稿~~ → **陈 2026-11-14 01:55 亲口确认已解决**，不再跟
- **remote 未通**（陈点名待办）：电脑 DSH 只监听 127.0.0.1:3080、cloudflared 两边没跑、memory-sync peer `:18792` 没开
- **4 个插件清单层不兼容**（引擎删了 `dsh-client-store`/`ui-primitives`/`ui-slots`）：agent-teams / ds-harness-remote / dsh-pet / dsh-trust-check，面板显示红但**实际运行正常**（dsh-pet 01:32 还在动）
- **headless profile `dependencies: []`** → 自主时间块每跑一次白烧 token（14/20 点已禁用，未修）
- AGENTS.md 仍超红线（已把客户端动态块挪到末尾修缓存，见 11-14 事故小结）
- Live2D 缺 motion3；网易云点歌建议砍（侵权）
- **真开播卡点**：Coopanion/OBS 未装、B 站第三方开播粉丝门槛未确认（要陈登直播中心看）

## 5. 下一步

0. **remote**：陈 2026-11-14 点名是待办。**已经用零成本方案落地**（见第 6 段）——
   `~/dsh-link.sh task '<命令>'` 发任务到电脑，电脑 cron 每 2 分钟纯 shell 执行并回结果，**全程 0 token**。
   还没做的：真正「两个 AI 对话」（那才双份 token，需陈定用哪一档）。
1. 陈定版直播间视频 → 已发 `BV1oCW66BEpG`（高清版 74s，Web 接口投稿成功，审核中）
2. 电脑装 Coopanion + OBS，试 OBS WebSocket 4455
3. 确认 B 站开播权限（鲸鲸号粉丝够不够）
4. 电脑上手机没有的插件，挑 3 个装手机（meow-cachebilling / dsh-vision-router / dsh-request-doctor）

## 6. 已建好（2026-11-14 02:00 夜）

- **记忆自动落盘**：定时任务 `schedule-2d13564f-94a4-4a1c-9b87-8dbb39e925f1`，
  **每 12 小时**（首次 2026-11-14 14:00）在新会话里跑一次：读 handoff → 有实质变化才改 →
  memory_write → rsync 电脑 + push GitHub → 回一段汇报。陈定的规矩：每 12 小时或重大更新写一次，不然容易失忆。
- **手机↔电脑 零 token 链路**：`~/dsh-link.sh {push|pull|task '命令'}`
  - 手机 `~/.dsh/link/out/*.sh` → rsync 到电脑 `~/.dsh/link/in/` → 电脑 `runner.sh` 纯 shell 执行
    → 结果写 `~/.dsh/link/out/*.result` → 手机 `pull` 收
  - 电脑 cron：`*/2 * * * * ~/.dsh/link/runner.sh`
  - 实测：发 `hostname; uptime; nvidia-smi` 一条，30 秒内拿回 `cyx-GI5CN54 / load / 145 MiB`
  - **为什么不直接"两个 AI 对话"**：那要两边各起一个会话，token 双份；陈明确说烧得快。
    所以先做「电脑当执行器」（0 token），需要它动脑时才用便宜模型（agnes）起一次 headless。

## 明天要回答陈的问题（他 02:00 留的）

> 「快速模式和快准狠之间差在中英文思考链，你觉得怎么样？」——明早给结论，我的初步判断：

1. **成本差主要来自思考链长度，不是语言**：同一道题英文 CoT 通常省 10~25% token（DeepSeek 分词器对英文更经济），
   但"快速模式"真正省的是**步数和输出预算**，语言只是顺带。
2. **该按任务分，不按模式分**：代码/英文资料/数学推理 → 英文思考链更划算；中文创作、跟陈说话、
   记忆整理、B 站文案 → 中文思考链，省掉来回翻译的失真；纯检索/机械活 → 直接快速模式。
3. **一条硬建议**：思考链语言跟「产出物语言」一致最省——产出中文却用英文想，最后还要翻一遍，反而更贵。

## 关键教训（只留最贵的）

- **hdslb 证书坑会复发**：`_aiohttp_session()` 跳过校验的补丁，插件一重装就冲掉
- **Edge TTS 只有 Node 能连**（Python/aiohttp 拿不到证书）
- **dsh-memory-sync 的 notify.mjs 在 Android 会杀引擎**：已加 `child.on?.('error')`，重装会丢
- **引擎升级删了 `dsh-tool-subagent-control/list-agents` 子路径** → cordis.patch.yml 那行会让新建会话失败（已删）
- **别摘三个内置 bundle**（android-bundle/core-memory/preset-razor）→ 会连环降级
- 传文件到手机：手机当 ssh 客户端 `ssh ... 'tar czf -' > 本地.tgz`
