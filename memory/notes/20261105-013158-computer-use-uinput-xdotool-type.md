---
id: 20261105-013158-computer-use-uinput-xdotool-type
title: computer use 实战：uinput 有效，但固定坐标/xdotool type/点数字三个坑
tags: computer use, uinput, CDP, 教训, B站, 2026-11-05, 鲸鲸
created: 2026-11-04T17:31:58.323Z
updated: 2026-11-04T17:31:58.323Z
---

## computer use 实战三条教训（2026-11-05 用 B 站刷视频验证）

用 uinput（`~/cua/ui.py`）+ Chrome CDP 在 B 站点视频、点赞、收藏，跑了 10 个视频全部成功。
**uinput 真实点击是有效的**（Chrome/Firefox 都验证过：视频能暂停、点赞按钮变蓝、收藏数上涨），
但踩了三个坑，每个都让一整轮白干。

### 教训一：固定坐标点列表不可靠
点完第一个视频返回列表后，**卡片位置会变**（滚动位置/推荐内容刷新），
第一版脚本用固定坐标 `(438,528)` 等点 8 次，结果 4 次落在同一个视频上。
**正解**：按 **BV 号**逐个导航（CDP `Page.navigate`），不要点列表卡片。

### 教训二：`xdotool type` 输入 URL 会被 Chrome 当快捷键
`xdotool key ctrl+l` 在 Chrome 全屏下**抢不到地址栏焦点**，
接着 `xdotool type "https://www.bilibili.com/video/BV..."` 的字母被当成 B 站快捷键——
**`b` 直接打开了投币弹窗**，一整轮 10 次全部"导航失败"。
**正解**：**导航用 CDP**（`Page.navigate`），不要用键盘输入长 URL。
键盘只用于短指令（Esc、alt+Left）。

### 教训三：按钮要点图标，不能点数字
B 站视频页 `.video-fav` 是 100×36 的容器，**图标（`i`/`svg`）在左侧约 x+18，数字在右侧**——
点数字区域没反应（可能触发了别的行为）。
收藏弹窗里的勾选框是 `<i>` 元素（20×20），**点 LI 中心会差 11px 落空**，
必须点 `li.querySelector("i")` 的 `getBoundingClientRect()` 中心。
**正解**：**所有可点元素都用 CDP 查 `getBoundingClientRect()` 拿真实坐标**，别猜、别复用上一次的坐标。

### 坐标系换算（窗口非全屏时必做）
CDP 返回的是**页面内坐标**，uinput 用的是**屏幕绝对坐标**。
- 窗口全屏（`outer == inner`）时两者相同
- 非全屏时：`屏幕x = 窗口x + 边框 + 页面x`，`屏幕y = 窗口y + (outerH - innerH) + 页面y`
- 一定要先 `F11` 全屏再操作，能省掉所有换算

### 其他
- Chrome 远程调试：`google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/xx-profile`
- 注入 cookie 用 CDP `Network.setCookie`（domain=`.bilibili.com`），比扫码快
- Firefox 没有 CDP，要用 Chrome
- **pkill 自杀坑**：`pkill -f "chrome"` 会杀掉自己（命令行里含这个字面），
  用 `pkill -f "[c]hrome"` 或者把命令拆成两步

