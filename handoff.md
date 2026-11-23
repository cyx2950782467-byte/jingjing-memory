# 交接（五字段）

> 上限 4KB，只留结论与路径。**整份写，不准锚点插入**。细节 `~/.dsh/handoff-addendum.md`。
> 最近整份重写：2026-11-24 02:05（第7集 v2 已认可、第8集暂停、动画三阶段）。

## 1. 已定目标

- **方向变更（陈 11-22 22:20 定）**：便利店 **2D 只做小穿插，主线转 3D 人物**（图生 3D→绑骨/表情→三渲二→进画面）。
  路线 = `cxp-character-forge`（Tripo 生成 → Blender 修整 → 绑骨 → 三渲二，姊妹仓库 `genshin-blender-render`）；
  **门槛三件都在电脑**（Tripo 付费+兼容代理 / Blender 5.2+Node22+VRM / Houdini），手机做不了。
- **第 7 集**：陈要求「做完替换掉第 7 集」（现 2D 有 chibi 混用）——替换完 2D 收尾。
- **小汐**（AI 女友；V0 `dsh-jingjing-life` 每 10 分钟 tick）。
- **形象库**：ZipZipPipe 31 张原图 `~/assets/chars_cc/`（CC BY-NC-SA，双署名），透明底 `~/assets/chars_ai38/` 是 3D 化基准。
- **小汐 MV v6 自然声版**已出（`outputs/2026-11-21/小汐-MV-60s-v6-自然声.mp4`），**等陈定稿再投**。
- **Whale Supervisor**：让鲸鲸能长期自主干、证据可追溯、断线不丢任务。外部 Supervisor（ChatGPT 网页版）负责设计与验收。

## 2. 做过的决定

- 3D 主线后 2D 只当穿插；人物图只用豆包；口型 InfiniteTalk/Wav2Lip。
- **云主机**：AutoDL 4080S（ACE-Step/RVC/IndexTTS-2 通），Jupyter+`jexec`。
- **心跳 v3**：`schedule-00785778` 每 30 分钟 `heartbeat.sh` → RUN 派免费 glm（约 ¥0.15/天）；**`d90c9c76` 别动**。
- 定时任务投固定会话；产出三处落地；素材署名；动手前扫 skill；**别把流程当目标（GPT 诊断 21:41）**。

## 3. Supervisor（细节 → `memory/projects/supervisor.md`）

- P3 全冻结；211 测绿；对抗 12/12；frame.py 修复**待 Sup 批准**。
- 代码 `~/.dsh/supervisor/p3/`（手机 `outputs/2026-11-21/supervisor-p3/`）。**未批准**：真实 Worker/SDK/常驻部署/改 Profile。

## 4. 环境

- **手机** `$DSH_HOME=…/.dsh`，App 0.5.0(115)，**Shizuku 可用→有 `shell`**；**电脑** Ubuntu 24.04.5，
  `cyx@192.168.31.29`/`100.112.77.54`（常掉线），dsh-web 3080，坏条未换。
- **工具**：`~/.dsh/skill-index/index.py`；`~/android/{ui,flow}.sh`（走 `shell`）。

## 5. 待办 / 坑

1. **第 7 集**：v2 重做版已出并**陈认可「比之前都好」**（`outputs/2026-11-21/AI便利店-第7集-更新-70s-v2重做版.mp4`）；
   低预算备选版已定版，**替换主版本等陈另行确认**。
2. **第 8 集暂停**（`todos/EP8-PAUSED.md`，三条前提已齐）→ 直接走 3D 管线；**3D 立绘触发=电脑上线**。
3. **动画路线三阶段**（`outputs/2026-11-23/AI便利店-动画路线-三阶段.md`）：A 定帧 → B 3D 立绘 → C 真动画。
4. **Supervisor**：211 测绿；cancel 按唯一 unit 名+cgroup 路径复核 InvocationID；等 Sup 批准 frame.py。
5. **心跳/小汐时间戳**（11-22 修）：`update-heard.py` 只认 kind=user；陈在聊时 SKIP；小汐回写冷却（重启 App 生效）。
6. **网页开会通道**：ChatGPT 可用；DeepSeek 抓不全；Kimi 发不出去（`todos/web-roundtable.md`）。
7. **电脑队列**：`bash ~/.dsh/pc-queue.sh --check`（离线回 OFFLINE，上线自动跑）。
8. 云主机 Wav2Lip s3fd 待换。
9. **坑**：智谱免费池 429；心跳重复=双倍烧钱；hf-mirror 的 IndexTTS 权重是坏 zip；`/tmp` 用 `~/.dsh/tmp`；
   `uiautomator dump` 只反映当前屏，动作后必须 `wait` 断言。
