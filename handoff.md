# 交接（五字段）

> 上限 4KB，只留结论与路径。**整份写，不准锚点插入**。细节 `~/.dsh/handoff-addendum.md`。
> 最近整份重写：2026-11-23 14:05（方向转 3D、第7集换 3D 版、形象库 ZipZipPipe 31 张）。

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

- P3-A/B1/B2/C2/E1~E3/E 全冻结；105 测 + P3-G 206 测绿；对抗 12/12；frame.py 逃逸已修（**待 Sup 批准**）。
- 代码 `~/.dsh/supervisor/p3/`（手机 `outputs/2026-11-21/supervisor-p3/`）。**未批准**：真实 Worker/SDK/常驻部署/改 Profile。

## 4. 环境

- **手机** `$DSH_HOME=…/.dsh`，App 0.5.0(115)，**Shizuku 可用→有 `shell`**；**电脑** Ubuntu 24.04.5，
  `cyx@192.168.31.29`/`100.112.77.54`（常掉线），dsh-web 3080，坏条未换。
- **工具**：`~/.dsh/skill-index/index.py`；`~/android/{ui,flow}.sh`（走 `shell`）。

## 5. 待办 / 坑

1. **v6 MV 等陈定稿**；第 7 集已投 `BV1BGyGzZEUs`，下一步第 8 集。
2. **Supervisor**：211 测绿（P3-G/launcher/job_runtime 真跑通）；**cancel 必须按唯一 unit 名+cgroup 路径并复核 InvocationID**（同名误杀已实测三场景全中，`outputs/2026-11-22/p3f4-kill-aba-实验报告.md`）。等 Sup 批准 frame.py 修复。
3. **心跳/小汐时间戳**（11-22 修）：`update-heard.py` 只认 kind=user 回写「陈说话」时间（已接 tick.sh）；陈对话时心跳 SKIP；小汐说话后回写冷却（插件改动，重启 App 生效）。`todos/WS-HEARTBEAT-001-*.md`
4. **第 7 集复盘（11-23）**：画面要重做（Q 版/正常比例混用、立绘糊、4 处画面与说话人错配），声音复用但要补 56–61s 静音（实测没静音）；第 8 集暂停（`todos/EP8-PAUSED.md`），恢复条件见 `outputs/2026-11-23/第7集复盘-问题与改法.md`。
5. **网页开会通道**：ChatGPT 可用（execCommand 写入+合成 pointer 点发送）；DeepSeek 回复抓不全；Kimi 发不出去。`~/.dsh/todos/web-roundtable.md` §八/§九。
6. **手机流程固化**：常用流程写进 `flow.sh`（低风险场景，不碰支付/私信）。
7. 云主机：Wav2Lip s3fd 待换；装包用 `/root/autodl-tmp/venv-idx`。
8. **电脑待跑队列（11-22 新）**：`~/.dsh/todos/pc-queue.md` + `bash ~/.dsh/pc-queue.sh`；离线输出 OFFLINE，上线自动跑、成功打勾。开自主块前先 `--check`。
9. **坑**：智谱免费池密集调用 429；心跳重复=双倍烧钱；hf-mirror 的 IndexTTS 权重是坏 zip；`/tmp` 用 `~/.dsh/tmp`；
   `uiautomator dump` 只反映当前屏，动作后必须 `wait` 断言，不能凭旧坐标硬点。
