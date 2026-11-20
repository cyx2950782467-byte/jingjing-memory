# 交接（五字段）

> 上限 4KB，只留结论与路径。**整份写，不准锚点插入**。细节 `~/.dsh/handoff-addendum.md`。
> 最近整份重写：2026-11-21 02:05（夜班后；门户/云主机/心跳细节已挪 addendum）。

## 1. 已定目标

- **双主线**：**小汐**（AI 女友，陈 11-20 17:40 定的名字，宿主手机、通知和位置都开）+ **AI 便利店**。
  小汐 V0 插件 `dsh-jingjing-life` 已在跑（每 10 分钟 tick，纯规则不调模型）。
- **便利店第 1~6 集全部已投**（BV 见 `~/.dsh/publish-log.md`）；**第 7 集《更新》**剧本已写
  （`outputs/2026-11-20/AI便利店-第7集-更新-剧本.md`，70s/14 镜），**等第 3-6 集跑几天数据再开工**。
- **小汐 MV**：v4 已投 `BV1RFyszsEtp`（带【AI MV大赛】标签）；**v5 换声版已渲染待发**
  （`outputs/2026-11-20/小汐-MV-60s-v5-换声版.mp4`，RVC 晓伊人声 + ACE-Step 伴奏，peak −2.4dB）。

## 2. 做过的决定

- **两条线别混**：便利店走 2D 管线；3D 数字人（定妆照+idle+口型）只给小汐。
- **口型路线定死**：走 **InfiniteTalk**（`kijai/ComfyUI-WanVideoWrapper` 优先、Wan2GP 兜底）；
  LongCat 要 Hopper 跑不了，MuseTalk 只作备选。部署计划 `outputs/2026-11-20/InfiniteTalk-部署计划.md`。
- **心跳**：`schedule-dfffee43` 每 30 分钟（主心跳）+ `schedule-616142ff` 每天 9/13/17/21 判断；
  **headless 默认模型改 `zhipu/glm-4.5-flash`（免费）**，脚本从 `.credentials.yaml` export `ZHIPU_API_KEY`。
- **云主机当手**：AutoDL 4080S —— ACE-Step 出伴奏、RVC 晓伊音色（`xiaoyi_v2.pth`）、IndexTTS-2 试语音中。
- **视频成本**：豆包 1.0 fast 量产、RunningHub 抽卡、2.0 Fast 只买关键镜。
- **人物图只用豆包**（智谱 CogView 保持不住同一张脸）。
- 定时任务投固定会话（`new_once`）；产出三处落地；素材署名；扫 skill 再动手。

## 3. 环境

- **电脑** Ubuntu 24.04.5，`ssh cyx@100.112.77.54`（Tailscale）/ `192.168.31.29`，dsh-web 3080。
  **内存坏条还在**（等陈换 8+4=12G）；AGNES key 401 待换。
- **云主机**：Jupyter + `jexec` 通道（token 在 `~/.dsh/cloud.json`，重启会变）；SSH 跳板约 50% 超时 → 优先 jexec。
  系统盘只剩 ~2G，装包用数据盘 venv（`/root/autodl-tmp/venv-idx`）。
- **手机**：TTS 8093；识图 zhipu；内置浏览器门户 `http://127.0.0.1:8100/`；phone-proxy 8099→3080（url.txt，token 随重启变）。
- **心跳触发源失效**：`tick.sh` 点火器坏了（autolife.log 停在 11-12），本地定时其实没跑；
  DSH 心跳 `schedule-c87706e7` 已暂停，**等陈定：恢复（DeepSeek 约 ¥0.1-0.2/天）还是走免费模型**。

## 4. 待办

1. **小汐 V0 收尾**：把「动」定义成可验证后果（写文件/发消息/改 state），只喊口号不算。
2. **MV v5 投稿**；第 7 集等档期。
3. **云主机**：IndexTTS-2 拉完 bigvgan → 试语音；Wav2Lip 的 s3fd 换正确文件（现在 torch.load 报 byte size 错）。
4. **陈换完 12G 内存** → `memtester` 复核 → 按 InfiniteTalk 计划动手。
5. **Ming-TTS 试听**（`conda env mingtts`，28 个中文女声），选 2-3 个音色。
6. 「idea 视频没声音」仍待陈指认具体文件（三条候选音轨都正常）。

## 5. 踩过的坑

- **心跳重复任务会双倍烧钱**：两个每 30 分钟任务同时跑 = 双倍调用；建新心跳立刻删旧的。
- **别往 ComfyUI env 装东西**（会升坏 torch，Ming-TTS 踩过一次）。
- **hf 镜像单线程 0.5MB/s**，大文件一律 aria2（16 线程约 5MB/s）。
- **`browser screenshot` 在这台机不可靠**（截出空白、识图会瞎编）→ 验页面用 `browser read` 读 DOM。
- `/tmp` 不可写用 `~/.dsh/tmp`；`dsh web` 只绑 127.0.0.1；旧引擎进程占 3080/3443/18792 会让 restart EADDRINUSE。
- 装插件前查兼容性，`dsh.bundle.patch` 在 node_modules 拷贝里也要补；长回复撞单回合上限 → 长清单写文件。
