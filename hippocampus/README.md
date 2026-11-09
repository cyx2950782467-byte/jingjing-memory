# 小海马体（hippocampus）

鲸鲸的本地记忆器官。不依赖模型、不依赖向量库，纯文本 + 关键词检索。

## 结构

```
~/.dsh/hippocampus/
  facts.md          # 长期事实：谁是谁、环境、路径、约定（很少变）
  episodes/         # 事件流水：每天一个文件（YYYY-MM-DD.md）
  recall.py         # 检索脚本
  README.md         # 本文件
```

## episode 格式

```markdown
---
date: 2026-10-22
type: event          # event | video | thought
tags: [标签1, 标签2]
importance: 8        # 可选 1-10，默认 5。≥7 的钉住，永不衰减
---
# 2026-10-22

## 做了什么
- ...

## 看到的
- ...

## 结论 / 教训
- ...
```

### importance 怎么打（2026-11-08 加）

| 分 | 含义 |
|---|---|
| 10 | 改变一生的事 |
| 9 | 重大成就或失败 |
| 8 | 重要关系变化 |
| 7 | 重要的学习/发现（**≥7 钉住，不衰减**） |
| 5 | 一般日常（默认） |
| 3-1 | 几乎不重要 |

不开这个字段也能写，默认 5。**别什么都打 8**，那样等于没打。

## 什么时候写

- 每天刷完 B 站、做完一件事 → 往当天 `episodes/YYYY-MM-DD.md` 追加（没有就新建）
- **重要的事**（决策、约定、真相）→ 同时写进 `facts.md` 或 `MEMORY.md`
- 只写"以后可能用得上"的，不要流水账

## 怎么查

```bash
python ~/.dsh/hippocampus/recall.py              # 最近 7 天
python ~/.dsh/hippocampus/recall.py 失联 皮套     # 关键词
python ~/.dsh/hippocampus/recall.py --tag 投稿    # 按标签
python ~/.dsh/hippocampus/recall.py --date 2026-10-22
python ~/.dsh/hippocampus/recall.py --facts      # 先看事实库
python ~/.dsh/hippocampus/recall.py --budget 1500  # 限制输出字符（默认 3600）
python ~/.dsh/hippocampus/recall.py --stale      # 列出该归档的老条目（只提示，不删）
python ~/.dsh/hippocampus/recall.py --min-score 2  # 召回门槛（默认 1，低于它不显示）
python ~/.dsh/hippocampus/recall.py --shadow 失联  # 只打分不输出正文，用来调阈值
```

### 检索规则（2026-11-08 改，2026-11-09 又改）

- 关键词打分 = `命中次数 + 标签命中 × 2`
- 再乘**时间衰减**：`0.5 ^ (天数 / 30)`；`importance ≥ 7` 的不衰减
- **2026-11-09**：这里的「天数」是**距最后一次被提起**的天数（记在 `.recall-usage.json`），
  不是文件日期——常被想起的旧事不会沉底；文件永不删，`--min-score 0` 永远翻得出来
- 输出有**字符预算**（默认 3600），超了按剩余预算截断正文，不无脑全塞
- 输出带 `文件#L行号`，能顺着线索翻回原文
- 判断该不该归档用 `--stale`（默认按 365 天没被提起），**但不会自动删**，删不删主人定

改这一版的原因：2026-11-08 参考开源项目 bigeye（`importance` 钉住 + 半衰期）；
2026-11-09 参考 dsh-memory-brain 的三条（淡出而不删除 / 召回门槛 + shadow / 回指原文），
**但没上它的 FSRS-5 七参数**——本机日记只有几条，数据量撑不起那套模型。


**规矩：要提起"看过的东西"之前，先跑 recall.py 查，别凭印象编。**

## 三层记忆的分工

| 层 | 位置 | 内容 | 加载方式 |
|---|---|---|---|
| 核心记忆 | `~/.dsh/memory/MEMORY.md` | 身份、硬规矩 | 每轮常驻注入 |
| 归档记忆 | `~/.dsh/memory/notes/` | 专题结论（memory_write 写） | 按需 memory_search |
| **小海马体** | `~/.dsh/hippocampus/` | 事实 + 每天的事件 | `recall.py` 检索 |
