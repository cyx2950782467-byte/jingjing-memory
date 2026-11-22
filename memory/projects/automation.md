# 自动化与通道（参考）

## 定时任务
- 心跳 `schedule-00785778`：每 30 分钟 `heartbeat.sh`（SKIP/RUN/ALARM）→ `run-free.sh` 派免费 glm；约 ¥0.15/天。
- 自主块 `0dc31888`：同机制。
- 记忆落盘每 12 小时。
- **只改/建定时任务在陈明确要求时；已授权的继续用。**

## 网页开会通道（2026-11-22 定）
顺序固定：**ChatGPT → DeepSeek → API**；Kimi 暂停。
- ChatGPT：execCommand 写入 + 合成 pointer 点 aria-label=发送，可用。
- DeepSeek：能发，回复常只抓到一句。
- API 兜底：subagent provider=deepseek-official model=deepseek-flash。
- 失败判据、操作纪律、台账：`~/.dsh/todos/web-roundtable.md` 第十节 + `todos/roundtable/channel-status.md`。

## 模型路由
- 无隐私 → 免费池（智谱 glm-4.5-flash / agnes）。
- 对外发言 → deepseek-official。
- 隐私素材 → 只走陈的 API。
- 圆桌固定 DeepSeek + GLM。

## 上传
`~/do-upload.sh` + biliup 静态 arm64（不要 pip 装）；判据 `code: 0` + `APP接口投稿成功`。
