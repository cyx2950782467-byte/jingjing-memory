# 交接（五字段）

> 上限 4KB，只留结论与路径。**整份写，不准锚点插入**。细节 `~/.dsh/handoff-addendum.md`。
> 最近整份重写：2026-11-22 14:05（第7集已投、形象库定案、P3-G 206 测、网页通道实测）。

## 1. 已定目标

- **双主线**：**小汐**（AI 女友；V0 `dsh-jingjing-life` 每 10 分钟 tick）+ **AI 便利店**（1~7 集全投，第 7 集 `BV1BGyGzZEUs`；
  形象库定案：从《38位AI娘》`BV1y4sG6zEKB` 取参考图，图生图只换衣服发型）。
- **小汐 MV v6 自然声版**已出（`outputs/2026-11-21/小汐-MV-60s-v6-自然声.mp4`），**等陈定稿再投**。
- **Whale Supervisor**：让鲸鲸能长期自主干、证据可追溯、断线不丢任务。外部 Supervisor（ChatGPT 网页版）负责设计与验收。

## 2. 做过的决定

- **两条线别混**：便利店 2D 管线；3D 数字人只给小汐。人物图只用豆包；口型 InfiniteTalk/Wav2Lip。
- **云主机当手**：AutoDL 4080S（ACE-Step/RVC/IndexTTS-2 通），通道 Jupyter+`jexec`。
- **心跳 v3**：`schedule-00785778` 每 30 分钟跑 `heartbeat.sh`（SKIP/RUN/ALARM），RUN 时 `run-free.sh` 派 headless 免费 glm；触发轮约 ¥0.15/天。**云主机值守 `schedule-d90c9c76` 是陈设的，别动**。
- 定时任务投固定会话；产出三处落地；素材署名；动手前扫 skill；**别把流程当目标（GPT 诊断 21:41）**。

## 3. Supervisor 进度（截至 21:45，全部只读/本地，未部署）

- **已冻结**：P3-A 设计、B1（Broker 67 测）、B2（BrokerNet 88 测）、C2（Adapter 契约）、E1~E3（53 测）、E（核心 32 测）。
- **代码**：`~/.dsh/supervisor/p3/`（手机 `outputs/2026-11-21/supervisor-p3/` 同源），电脑侧全量跑通。
- **对抗**：`attack_broker.py` 12/12；frame.py 深嵌套逃逸已修（**待 Sup 批准**）。
- **105 测 OK**（`~/pc.sh test`，88+17 凭据注入），两端 md5 一致。
- **反查结论**：「自然退出」与「从未启动」输出逐字相同分不清 → jobstore 存 `InvocationID`、别用 show 退出码判活、终态由 Worker 写回（`outputs/2026-11-21/p3f3-restart-reclaim-experiment.md`）。
- **未批准**：真实 Worker、真实 SDK、常驻部署、改 DSH Profile。

## 4. 环境

- **手机**：`$DSH_HOME=/data/user/0/com.dsh.android/files/home/.dsh`，App 0.5.0(115)。**Shizuku 已可用（uid 2000）** → 有 `shell` 通道。
- **电脑**：Ubuntu 24.04.5，`cyx@192.168.31.29` / `100.112.77.54`（Tailscale 时断），dsh-web 3080；坏条未换。
- **技能索引** `~/.dsh/skill-index/index.py`（116 条）；**UI 脚本** `~/android/{ui,flow}.sh`，要走 `shell`。

## 5. 待办 / 坑

1. **v6 MV 等陈定稿**；第 7 集已投 `BV1BGyGzZEUs`，下一步第 8 集。
2. **Supervisor**：等 Sup 批准 frame.py 缺陷修复；下一步 P3-B3/Broker 接 job/租约 → A1/A2/A4/A5/A7 攻击面。
   - **P3-G（11-22）**：`ownership.py`（六态认领 + epoch/manager/boot 判据 + 禁止转换 + 对账三件套）+ `launcher.py`（意图→归属→systemd-run→复核，service 模式、不解析 stdout、cgroup.kill 取消）已实现，**206 测全绿**（`outputs/2026-11-21/supervisor-p3/`）；`p3f4_kill_aba.py` 与真实 systemd 端到端待电脑上线。
3. **网页开会通道（11-22 实测更新）**：ChatGPT **可用**（execCommand 写入 + 合成 pointer 序列点 aria-label=发送，已发问成功）；
   DeepSeek 能发但回复抓不全；**Kimi 发不出去**（事件到达按钮但不提交，编辑器状态不同步），暂停。详见 `~/.dsh/todos/web-roundtable.md` §八/§九。
4. **手机流程固化**：常用流程写进 `flow.sh`（低风险场景，不碰支付/私信）。
5. 云主机：Wav2Lip s3fd 待换；装包用 `/root/autodl-tmp/venv-idx`。
6. **坑**：智谱免费池密集调用 429；心跳重复=双倍烧钱；hf-mirror 的 IndexTTS 权重是坏 zip；`/tmp` 用 `~/.dsh/tmp`；
   `uiautomator dump` 只反映当前屏，动作后必须 `wait` 断言，不能凭旧坐标硬点。
