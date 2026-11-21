# 交接（五字段）

> 上限 4KB，只留结论与路径。**整份写，不准锚点插入**。细节 `~/.dsh/handoff-addendum.md`。
> 最近整份重写：2026-11-22 02:05（第7集成片、105 测、反查实验、ChatGPT 卡点）。

## 1. 已定目标

- **双主线**：**小汐**（AI 女友；V0 插件 `dsh-jingjing-life` 每 10 分钟 tick 纯规则）+ **AI 便利店**（1~6 集已投；**第 7 集《更新》70s 成片已出**，`outputs/2026-11-21/`，等档期投）。
- **小汐 MV v6 自然声版**已出（`outputs/2026-11-21/小汐-MV-60s-v6-自然声.mp4`），**等陈定稿再投**。
- **Whale Supervisor**：让鲸鲸能长期自主干、证据可追溯、断线不丢任务。外部 Supervisor（ChatGPT 网页版）负责设计与验收。

## 2. 做过的决定

- **两条线别混**：便利店 2D 管线；3D 数字人只给小汐。人物图只用豆包；口型 InfiniteTalk/Wav2Lip。
- **云主机当手**：AutoDL 4080S（ACE-Step/RVC/IndexTTS-2 通），通道 Jupyter+`jexec`。
- **心跳 v3**：`schedule-00785778` 每 30 分钟跑 `heartbeat.sh`（SKIP/RUN/ALARM），RUN 时 `run-free.sh` 派 headless 免费 glm；触发轮约 ¥0.15/天。**云主机值守 `schedule-d90c9c76` 是陈设的，别动**。
- 定时任务投固定会话；产出三处落地；素材署名；动手前扫 skill；**别把流程当目标（GPT 诊断 21:41）**。

## 3. Supervisor 进度（截至 21:45，全部只读/本地，未部署）

- **已冻结**：P3-A 设计（14 态/fsync 权威/fencing/verification 历史）、B1（Broker+单实例锁 67 测）、
  B2（BrokerNet+Dispatcher 88 测）、C2（Adapter 契约）、E1~E3（帧/传输/调度 53 测）、E（确定性核心 32 测）。
- **代码**：`~/.dsh/supervisor/p3/`（手机 `outputs/2026-11-21/supervisor-p3/` 同源），电脑侧全量跑通。
- **对抗验收第一轮**：`attack_broker.py` 12/12 过；修了 frame.py 深嵌套 JSON 逃逸（**待 Sup 批准**）。
- **105 测 OK**（`~/pc.sh test`，88 原有 + 17 凭据注入）：`credentials.py` 的 `for_spawn/redact/build_env` 已落地，两端 md5 一致。
- **反查实验结论**：只靠 unit 名反查能判「还活着」；但「自然退出」与「从未启动」系统输出逐字相同，分不清 →
  补法：jobstore 存 `InvocationID`（防 ABA）、判活别用 `systemctl show` 退出码、attempt 终态由 Worker 写回（`outputs/2026-11-21/p3f3-restart-reclaim-experiment.md`）。
- **未批准**：真实 Worker、真实 SDK、常驻部署、改 DSH Profile。

## 4. 环境

- **手机**：`$DSH_HOME=/data/user/0/com.dsh.android/files/home/.dsh`，App 0.5.0(115)。**Shizuku 已可用（uid 2000）** → 有 `shell` 通道。
- **电脑**：Ubuntu 24.04.5，`cyx@192.168.31.29` / `100.112.77.54`（Tailscale 时断），dsh-web 3080；坏条未换。
- **手机 UI**：`/data/local/tmp/ui.sh`、`flow.sh`（源 `~/android/`），解析 `~/android-ui.py`、`~/android-act.py`；动作必须走 `shell`。
- **技能索引**：`~/.dsh/skill-index/index.py`（build/search/use/check/list），116 条，Dice + stale 标记。

## 5. 待办 / 坑

1. **v6 MV 等陈定稿**；第 7 集已成片等档期。
2. **Supervisor**：等 Sup 批准 frame.py 缺陷修复；下一步 P3-B3/Broker 接 job/租约 → A1/A2/A4/A5/A7 攻击面。
3. **ChatGPT 通道卡点**（整晚没通）：`browser type` 对 contenteditable 报 Illegal invocation、`browser eval` 无返回；
   内置浏览器在右侧边栏，`shell input` 打不到。下次：关干净面板 → `dump includeHidden` 看右侧边栏按钮 → 打开后用 `shell input`。
4. **手机流程固化**：常用流程写进 `flow.sh`（低风险场景，不碰支付/私信）。
5. 云主机：Wav2Lip s3fd 待换；系统盘仅 ~2G，装包用 `/root/autodl-tmp/venv-idx`。
6. **坑**：智谱免费池密集调用 429；心跳重复=双倍烧钱；hf-mirror 的 IndexTTS 权重是坏 zip；`/tmp` 用 `~/.dsh/tmp`；
   `uiautomator dump` 只反映当前屏，动作后必须 `wait` 断言，不能凭旧坐标硬点。
