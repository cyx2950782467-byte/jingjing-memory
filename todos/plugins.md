# 插件台账（2026-11-15 21:50 更新：陈问「这些插件我不是让你全部用过一遍吗」）

> 诚实结论：**35 个里真用过的 12 个，被动生效 5 个，从没打开过的 18 个。**
> 「全部用一遍」这条之前不在我记的规矩里，所以我没做。现在补上：**每次自主时段至少试一个没碰过的插件**，结论写这里。

## 用法审计

| 插件 | 干什么 | 我用过没 |
|---|---|---|
| `dsh-core-memory` | 跨会话核心记忆注入 | 用过·天天用 |
| `dsh-memory-doctor` | 记忆体检/瘦身/记忆包 | 用过（memory 工具） |
| `dsh-memory-sync` | 两机记忆同步 | 用过 |
| `dsh-any-audio` | 配乐/配音/音效/混音 | 用过·每集都靠它 |
| `dsh-free-search` | 37 个免费搜索源 | 用过·天天用 |
| `dsh-bili-scroll` | 每天刷 B 站+写日报 | 用过 |
| `dsh-blender` | Blender 建模/渲染/校验 | 用过（早几天） |
| `dsh-drawai` | 可编辑画布 .drawio | 用过（画分镜） |
| `dsh-plugin-save-token` | 省 token 压缩 | 用过（save_token_expand） |
| `dsh-video-storyboard` | 视频分镜网格 | 浅用过（定风波） |
| `dsh-univer-office` | Office 文档/表格/PPT | 浅用过 |
| `dsh-voice-chat` | 语音对话（麦克风+朗读） | 没试成（麦克风不可用） |
| `dsh-gallery` | 产出画廊：实时看/校验/打标签 | **从没用过 → 今天才补** |
| `dsh-my-context` | token 用量可视化+预算 | 用过（11-15 面板读数 + 11-16 落盘数据拆解） |
| `dsh-token-diet` | 用量汇总+预算停止 | 没用过 |
| `dsh-notify-me` | 离开页面也能收到提醒 | 没用过 |
| `dsh-see-now` | 看屏幕/摄像头 | 没用过 |
| `dsh-pet` | 桌面宠物大肥鱼 | 没用过 |
| `dsh-council` | 多模型圆桌 | 没用过（我用 workflow 代替） |
| `dsh-agent-teams` | 多智能体团队 | 没用过 |
| `dsh-task-reliability` | 超时重试/任务恢复 | 没用过 |
| `dsh-step-governor` | 步数熔断 | 被动生效（今天还拦过我一次） |
| `dsh-compaction-threshold` | 调自动压缩阈值 | 被动生效 |
| `billion-context` | 长上下文压缩 | 被动生效 |
| `dsh-plugin-health` | 插件健康诊断 | 用过一次 |
| `dsh-plugin-catalog` | 插件目录 10365 条 | 没用过 |
| `dsh-trust-check` | 插件能力披露 | 没用过 |
| `dsh-unlag` | 桌面端刷新按钮 | 没用过（手机端） |
| `dsh-preset-razor` | Fast 模式预设 | 没用过 |
| `dsh-deep-sea-theme` | 深海主题 | 在用（界面） |
| `ds-harness-remote` | P2P 远程接入 | 没用过 |
| `jiuling-remote` | 电脑会话搬到手机 | 没用过 |
| `dsh-share-guard` | 拉起 8899 分享服务 | 被动生效 |
| `dsh-ielts-writing-examiner` | 雅思写作批改 | 没用过 |
| `dsh-android-bundle` | Android 内置能力 | 核心，必须在 |
| `dsh-my-context` | 这次不看面板，直接读 `~/.dsh/context/context.json` 拆构成 | ✅ 得出 11-15 没看出来的三条 |


## 2026-11-16：`dsh-my-context` 再挖一层（不是首次，11-15 只看过面板）

用插件自己的落盘数据（`$DSH_HOME/context/context.json`，按会话分桶）统计 2026-11-16 全天：

| 指标 | 数值 |
|---|---|
| prompt 累计 | 57,844,474 |
| **其中 KV 缓存命中** | **56,872,576（98.3%）** |
| output | 131,365 |
| 总 token | 57,975,839 |

**上下文构成（占比从大到小）：assistant 51.5% ｜ tool 结果 18.9% ｜ tools schema 15.2% ｜ inject 13.7% ｜ user 0.7% ｜ system 0%**

### 这张表说了三件我一直猜错的事

1. **人说的话只占 0.7%。** 我以为「少说话省 token」，其实对话内容根本不是大头。
   省 token 该动的是另外 99%：工具结果、工具定义、系统注入。
2. **tools schema 每次请求固定吃掉 15.2%。** 这是 100 多个工具的定义，跟聊什么内容无关，
   每轮都重发一遍。真要省，减工具比减字数有效一个数量级。
3. **KV 缓存命中 98.3%，缓存是救命的那一层。** 所以「换新会话」这个建议要重新想：
   换会话会把缓存全部作废，下一轮所有 prompt 都按新价算。**长会话反而便宜。**
   （之前 handoff 里写「超过 10 轮就换会话省上下文」，这条得改 —— 省钱靠不换会话，省窗口才靠换。）

### 一个具体可动的点
`assistant` 占 51.5% —— 我自己写的东西（工具调用、说明）在上下文里滚雪球。
工具调用能少就少、一次调用多带信息，比省字更实在。

## 现在我确实缺的（按价值排序）

1. **`dsh-gallery`（产出画廊）** —— 我所有成片都写进 `/sdcard`，工作区外，所以画廊一直是空的。
   已改：以后每份产出一份进 `工作区/outputs/<日期>/`，画廊才看得见、能打「素材/过程稿/定稿」标签。
2. **`dsh-my-context` / `dsh-token-diet`** —— 我天天烧 token 却看不到花在哪，这两个正好补上。
3. **`dsh-notify-me`** —— 长任务跑完能主动弹通知，不用陈守着。
4. **`dsh-video-storyboard`** —— 我还在手写分镜表，它有现成分镜网格。

## 试用记录（2026-11-15 22:2x，陈说「一个一个用过去」）

| 插件 | 怎么试的 | 结果 |
|---|---|---|
| `dsh-unlag` | 调 `unlag_refresh` | ✅ 通，返回「刷新 · 在右键菜单里打开 Agent 可以自己刷新」 |
| `dsh-see-now` | `see_now status` | ✅ 通。未采集、/seenow 已注册、节奏 normal、收工线 8 次叫醒/3 分钟静默 |
| `dsh-gallery` | 写 `~/.dsh/dsh-gallery.json`（5 个 roots 全部存在）+ 拉右侧面板 | ⚠️ 面板能开、接口活（401 鉴权），但点标签没看到缩略图；需要陈在面板里刷新确认 |
| `dsh-my-context` | 读右侧状态栏 + 预算输入框 | ✅ 数据有效：本会话 ¥1.40、484M tok、缓存命中 99%、117 轮 1046 步、上下文 42% |
| `dsh-plugin-save-token` | 读状态栏 | ✅ 已节省 ~127.9k tok、压缩 2 次（1 次无损）、137 次请求 |
| `dsh-y`（表格待续） | | |

### 顺手发现
- 右侧栏有的面板：AI 浏览器 / 工作区文件 / **产出画廊** / DrawAI 画布 / **上下文透镜** / **任务可靠性** / 桌宠对话 / 更多工具
- 对话底部状态条：`¥1.40`、`token-saver 已节省 ~127.9k tok，压缩 2 次(1 无损)，137 次请求`
- 顶部按钮：`117 轮 1046 步 · 210 tok/s`、`484M tok · 缓存命中 99%`、`上下文已用 42%`
