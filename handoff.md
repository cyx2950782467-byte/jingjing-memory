# 交接（五字段）

> 上限 4KB，只留结论与路径。**整份写，不准锚点插入**。细节 `~/.dsh/handoff-addendum.md`。
> 最近整份重写：2026-11-25 02:10（第8集30s已投、第7集v3已投、碧蓝音色版在电脑跑）。

## 1. 已定目标

- **方向（陈 11-22 22:20 定）**：便利店 **2D 只做小穿插，主线转 3D 人物**（图生 3D→绑骨/表情→三渲二）。路线 `cxp-character-forge`；门槛（Tripo/Blender5.2+Node22/VRM/Houdini）都在电脑。
- **动画路线三阶段**：A 定帧 → B 3D 立绘 → C 真动画（`outputs/2026-11-23/AI便利店-动画路线-三阶段.md`）。
- **第 7 集**：v3 动态版已投 **`BV1uayZzkEG3`**（12:14，71s，角色真的会动）；旧稿 BV1uayZzkEar 已删。
- **第 8 集完整版暂停**（`todos/EP8-PAUSED.md`）：立绘换 ZipZipPipe `~/assets/chars_cc/`，弃用 chars2；gemini 缺单人原图待补。
- **小汐**（AI 女友，V0 `dsh-jingjing-life` tick）；MV v6 自然声版已投 `BV1DbyZzyEbb`。
- **Whale Supervisor**：211 测绿；cancel 按唯一 unit 名+cgroup 路径复核 InvocationID。

## 2. 做过的决定

- **图/视频生成只问豆包**（陈 11-23 22:35 定），不横向比较；硅基流动只留草稿。
- **图生视频管线**：seedream 融合图 → seedance i2v；首帧拼贴会被重画，必须 seedream 先画成一整张。
- 可用模型：i2v `doubao-seedance-1-0-pro-fast-251015`、生图 `doubao-seedream-5-0-pro-260628`、问方案 `doubao-seed-2-1-pro-260915`（必须 stream）。
- base64 data URI 可直传 i2v，不需要图床（豆包说不行，实测行）。
- **看 B 站**：真实播放 ≥35 秒才留记录；历史窗口仅 30 个；核对按时间戳（`~/verify_watch.py`，`todos/bili-watch-rules.md`）。
- 定时任务投固定会话；产出三处落地；素材署名（ZipZipPipe CC BY-NC-SA）；动手前扫 skill。

## 3. 投稿台账

- **第 7 集 v3 `BV1uayZzkEG3`（11-24 12:14，71s 动态版）；第 8 集 30s v13c `BV1LP1czbEWq`**
- 小汐 MV：`BV1DbyZzyEbb`（11-24 12:02，另一会话投）
- 台账 `~/.dsh/publish-log.md` 为准；投稿用 `python3 .bili/upload.py <视频> <meta.json>`
- **登录态只认 `~/.biliup/cookies.json`**（有效，`uname:鲸鲸不吃谷`）；`~/.bili-ai/credentials.json` 已失效（-101），不要用不要扫码。

## 4. 环境

- **手机** `$DSH_HOME=…/.dsh`，App 0.5.0(115)；`/tmp` 不可写，用 `~/.dsh/tmp`；Shizuku 未运行，`shell` 走 legacy adb。
- **电脑** `cyx@100.112.77.54`（常掉线）/ LAN `192.168.31.29`；Ubuntu 24.04.5，i5-8300H+1050Ti 4G，单条 8G。
  内存 memtest 10 Pass 干净；`dsh-web` 已停；`no-turbo.service` 限 2.3GHz；chrome 157 + websocket-client 已装。
- **火山方舟**：seedance 免费额度 200 万 token（≈8 条 5s，快用完）；seedream 0.60 元/张 2K。
- 工具 `~/.dsh/skill-index/index.py`、`~/android/{ui,flow}.sh`。

## 5. 待办 / 坑

1. **第 8 集只投了 30s 紧凑版** `BV1LP1czbEWq`（v13c：逐句切镜 1.0–4.6s、两人同框 seedream、BGM BIGJiang《凌晨便利店》、六声线+男声旁白）；
   **完整版暂停**。**碧蓝航线音色版在电脑跑**：权重+gst-venv 就绪，卡 `lid.176.bin` 126MB；**CPU 推理打满 8G 会让 ssh 无响应**（两次），
   出 7 个 wav 再定是否换人声。旧稿 `BV13DyfzJEFx`/`BV1vryfzsEHd` 删不掉（SDK 无接口）。
2. **第 7 集已收尾**。成本表 `outputs/2026-11-24-ep7-成本对照.md`（本轮现金 ≈¥1.80）。
3. **学习清单** `todos/learn-from-bili.md`：两条「是」→ AI娘人设共识（喂第 8 集）、同角色系列篇合集。
4. **Supervisor**：等 Sup 批准 frame.py；P3-B3 接 job/租约。
5. **云主机 AutoDL token 过期**（需陈更新）；AGNES key 401；rsync 2026-11-24 已补齐。
6. **坑**：豆包 chat 非流式必超时（120s）要 stream；seedance 拼贴首帧必被重画；B站历史窗口 30 且条数放大 30 倍；
   `-ss 56 -t 5` 测音量读错段，必须 atrim；**CPU 跑 GPT-SoVITS 会把内存打满**。
