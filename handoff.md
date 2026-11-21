# 交接（五字段）

> 上限 4KB，只留结论与路径。**整份写，不准锚点插入**。细节 `~/.dsh/handoff-addendum.md`。
> 最近整份重写：2026-11-21 14:05（心跳 v3 / IndexTTS 细节已挪 addendum）。

## 1. 已定目标

- **双主线**：**小汐**（AI 女友；宿主手机、通知/位置开；V0 插件 `dsh-jingjing-life` 每 10 分钟 tick 纯规则）
  + **AI 便利店**（第 1~6 集全投；第 7 集《更新》剧本已写，等数据再开工）。
- **小汐 MV**：v4 已投 `BV1RFyszsEtp`（带【AI MV大赛】）；**v6 自然声版已出**
  （`outputs/2026-11-21/小汐-MV-60s-v6-自然声.mp4`，IndexTTS-2 8 句 + 伴奏，peak −1.5dB）——
  **未投稿，等陈听完定稿再发**。满月 MV 已发 `BV1NSy8z4EdW`。

## 2. 做过的决定

- **两条线别混**：便利店走 2D 管线；3D 数字人（定妆照+idle+口型）只给小汐。
- **口型**：InfiniteTalk（LongCat 要 Hopper，MuseTalk 备选）；**云上已能跑 Wav2Lip**。
- **云主机当手**（AutoDL 4080S）：ACE-Step 歌/伴奏、RVC 晓伊音色（`xiaoyi_v2.pth`）、
  **IndexTTS-2 已跑通**（自然女声，RTF≈1.0；参考音用 ACE-Step 人声最自然）。
- **心跳 v3（11:03 落地）**：`schedule-00785778` 每 30 分钟只跑 `~/.dsh/heartbeat.sh`（三态 SKIP/RUN/ALARM，
  几秒返回）；RUN/ALARM 时用 `run-free.sh` 把活派给 **headless 免费 glm**。
  旧心跳 `c87706e7`、每日四次 `616142ff` 已暂停；自主块 `0dc31888` 也改成派活。
  **成本**：触发轮约 ¥0.003/轮，48 轮/天 ≈ ¥0.15，干活全免费。
- **视频成本**：豆包 1.0 fast 量产、RunningHub 抽卡、2.0 Fast 只关键镜；**人物图只用豆包**（CogView 脸不一致）。
- 定时任务投固定会话；产出三处落地；素材署名；扫 skill 再动手。

## 3. 环境

- **电脑** Ubuntu 24.04.5，`ssh cyx@100.112.77.54` / `192.168.31.29`，dsh-web 3080。
  **内存坏条还在**（等陈换 8+4=12G）；AGNES key 401 待换。
- **云主机**：Jupyter + `jexec` 通道（token `~/.dsh/cloud.json`，重启变）；SSH 跳板约 50% 超时。
  系统盘只剩 ~2G，装包用 `/root/autodl-tmp/venv-idx`。**云主机值守 `schedule-d90c9c76`（20 分钟）别动**（陈设的）。
- **手机**：TTS 8093；识图 zhipu；门户 `http://127.0.0.1:8100/`；phone-proxy 8099→3080。
- **心跳触发源已修**：`tick.sh` 的 JobScheduler 点火器坏了没人用，现在靠 DSH schedule。

## 4. 待办

1. **v6 自然声 MV 等陈定稿**（他听完再发）。
2. **小汐 V0 收尾**：「动」要可验证（写文件/发消息/改 state），只喊口号不算。
3. **云主机**：Wav2Lip 的 s3fd 换正确文件；IndexTTS 已通可复用。
4. **陈换完 12G 内存** → `memtester` → 按 InfiniteTalk 计划动手。
5. Ming-TTS 试听（`conda env mingtts`，28 个中文女声）选 2-3 个音色。
6. 「idea 视频没声音」仍待陈指认文件；第 7 集等档期。

## 5. 踩过的坑

- **智谱免费池密集调用会 429**（RATE_LIMIT 1302）→ `run-free.sh` 别并发。
- **心跳重复会双倍烧钱**：建新立刻停旧的；会话级换模型（`modelSelection.val.pending`）**会被投递 header 覆盖，走不通**。
- **hf-mirror 的 IndexTTS 权重是坏 zip**（gpt.pth / w2v-bert 都得走 ModelScope）。
- **别往 ComfyUI env 装东西**（升坏 torch）；hf 镜像单线程 0.5MB/s，大文件用 aria2。
- `browser screenshot` 这台机不可靠（空白）→ 用 `browser read`。
- `/tmp` 不可写用 `~/.dsh/tmp`；`dsh web` 只绑 127.0.0.1；旧引擎进程占 3080/3443/18792 会让 restart EADDRINUSE。
- 长回复撞单回合上限 → 长清单写文件。
