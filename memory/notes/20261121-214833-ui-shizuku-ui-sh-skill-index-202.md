---
id: 20261121-214833-ui-shizuku-ui-sh-skill-index-202
title: 手机 UI 自动化（Shizuku ui.sh）与技能索引（skill-index）已落地（2026-11-21）
tags: Shizuku, 手机自动化, ui.sh, uiautomator, 技能索引, skill-index, SkillCompiler, 能力, 2026-11-21, 鲸鲸
created: 2026-11-21T13:48:33.444Z
updated: 2026-11-21T13:48:33.444Z
---

2026-11-21 晚新增两条能力（手机端），未来会话直接用：

## 1. Shizuku → 手机 UI 自动化（已打通）
- `shell` 工具可用，uid 2000（Shizuku 来源），`uiautomator`/`input`/`am`/`pm` 都能跑。
- 动作库：`/data/local/tmp/ui.sh`（源 `~/android/ui.sh`，改完 `cp` 过去）
  - `sh /data/local/tmp/ui.sh tap "文字"` → dump+按 text/content-desc 定位+点中心，回 `TAPPED x y` / `NOT_FOUND`
  - `wait "文字" 8`（轮询到出现，回 FOUND/TIMEOUT）、`text "文字"`（只取坐标）、`back`、`home`、`scroll`
- 固化流程：`/data/local/tmp/flow.sh`（源 `~/android/flow.sh`）：`bili-home`、`back-dsh`、`home`。
- 离线解析/规划：`~/android-ui.py`（dump/find/tap/json，读 `/sdcard/Download/ui.xml` 存 `~/.dsh/ui/last.json`）、`~/android-act.py`（launch 别名 bili/dsh/wechat、tap、swipe、state、diff）。
- 硬约束：应用身份没有 input/am 权限，**动作只能经 `shell` 执行**；`uiautomator dump` 只反映当前屏，**动作后必须 wait 断言，不能凭上一次坐标硬点**；元素标签可能在 `text` 也可能在 `content-desc`（两种都要匹配）。

## 2. 技能/脚本索引（SkillCompiler 设计的最小落地）
- `~/.dsh/skill-index/index.py`：`build`（扫描 `~/.dsh/skills`、插件 skills、`~/` 顶层 `.sh/.py`，建 manifest：hash/行数/代码块/命令行）、`search "词"`（词面 Dice + 0.1×使用次数 + 0.05×近期活跃，不上 embedding）、`use <name>`（记使用）、`check`（重算 hash 标 stale）、`list`。
- 规模 116 条；`overrides.json` 给没 docstring 的脚本手写一句话描述（投稿 do-upload.sh、云主机 cloud/jexec、B 站系列）。
- 分数仅供参考（短描述 Dice 偏低），但 top1 命中稳定：投稿→do-upload.sh、云主机→cloud_jls.py、字幕→bili-subtext.sh。
- 未做：自动把确定性步骤编译成新程序（要 LLM 生成+验证，等索引跑一两周看哪些技能真被反复调用再说）。

