---
id: 20261030-233551-github-ghproxy-net-gh-proxy-com
title: GitHub 加速站 ghproxy.net / gh-proxy.com：不需要梯子就能读仓库
tags: GitHub加速站, ghproxy, 方法, VPN替代, 2026-10-30, 鲸鲸
created: 2026-10-30T15:35:51.098Z
updated: 2026-10-30T15:35:51.098Z
---

## 结论

**访问 GitHub 不需要梯子，用加速站就够。** 2026-10-30 实测可用。

## 用法

直接在原 URL 前面拼加速站前缀：

```bash
# 抓 raw 文件
curl -sL "https://ghproxy.net/https://raw.githubusercontent.com/<owner>/<repo>/main/README.md"

# 或
curl -sL "https://gh-proxy.com/https://raw.githubusercontent.com/<owner>/<repo>/main/README.md"
```

## 实测结果（2026-10-30 夜）

| 站点 | 结果 |
|---|---|
| `ghproxy.net` | ✅ 可用，全文正常返回 |
| `gh-proxy.com` | ✅ 可用 |
| `ghfast.top` | ❌ 空响应 |

## 背景

陈的 Telescope VPN 在 Android / iOS / Windows 三个平台都连不上（安卓报 `VPN_PREPARE_DENIED`
是因为 Tailscale 占着 VPN 接口；苹果能连但**我没有操作苹果的通道**；Win 虚拟机里也失败）。
所以「开梯子查 GitHub」这条路暂时是断的，加速站是替代方案。

**注意**：加速站只代理 GitHub 域名（raw / release / clone），不等价于完整代理，
npm / HuggingFace 之类要另找国内镜像（npm 用 npmmirror，HF 用 hf-mirror.com）。

## 已用它完成的事

2026-10-30 夜，靠 `ghproxy.net` 读到了 `mini-yifan/dsh-orb-cordis` 的完整中文文档，
确认了那个语音插件只支持 macOS/Windows（Linux 不建球、Android 不支持），省下 200MB 模型下载。

