---
id: 20261020-235828-dsh-zen-free-opencode-zen-2026-1
title: dsh-zen-free（OpenCode Zen 免费池）2026-10-20 起被上游封禁
tags: dsh-zen-free, opencode-zen, 免费池, 403, FreeTierError, 插件, 模型路由, 已排除
created: 2026-10-20T15:58:28.274Z
updated: 2026-10-20T15:58:28.274Z
---

## 结论
`dsh-zen-free` 插件的请求全部被 opencode.ai 拒绝，无法再用。不是插件版本问题，是上游准入变了。

## 实测（2026-10-20 23:57，本机 Android）
- 插件本体活着：本地转发口 `http://127.0.0.1:18793/zen/v1/models` 返回 200，能列出模型（deepseek-v4.1-flash-free / glm-5.3-flash-free / minimax-m3.1-flash-free / mimo-v2.6-flash-free 等）。
- 但 `POST /zen/v1/chat/completions` 一律返回：
  `403 {"type":"error","error":{"type":"FreeTierError","message":"OpenCode's free tier can only be used from within OpenCode..."}}`
- 已排除的变量（13 次请求全部 403）：
  - UA 版本：opencode/1.18.31、/1.19.3（npm 最新）、/1.20.0、/1.25.0、/2.0.0
  - 请求体带 `tools`（含 name=read，插件注释说是必需的）
  - 额外头：x-opencode-client、x-opencode-version、referer、origin、accept: text/event-stream
  - 无 x-opencode-session 的对照组
- npm 上 `dsh-zen-free` 最新版本 = 2.1.2，与本地已装版本相同 → **没有可更新的版本**。

## 含义 / 别再做的事
- 不要再试「更新插件」或「重启 App 让 zen 生效」——重启不会有任何变化，白打断会话。
- 不要再逐个试 UA 版本或头组合，已穷举过。
- 若将来要救：需要逆向 opencode 客户端的新准入（可能到 TLS 指纹/客户端签名层面），收益不稳定，对方随时再改。除非插件作者发新版，否则不建议投入。
- 当前实际可用的模型路由只有：`deepseek-official`（deepseek-flash / deepseek-v4-pro）、`agnes`（agnes-3.0-flash 等）。这两条都花主人自己的钱。

## 另一个已知坑（顺手记下）
profile 层 `~/.dsh/profiles/web/cordis.patch.yml` 里的 `llm-pi-ai.config.providers` 是**整体覆盖**语义，会把 dsh-zen-free 在 bundle 层声明的 opencode-zen 路由整个盖掉。所以即使插件恢复，也需要把 opencode-zen 那段手工合并进 profile 的 providers 才会出现在模型列表里。
