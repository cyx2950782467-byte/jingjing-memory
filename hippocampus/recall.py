#!/usr/bin/env python3
"""小海马体 · 检索

用法:
  python recall.py                    # 最近 7 天
  python recall.py 关键词 [关键词...]   # 全文 + 标签检索
  python recall.py --tag 标签           # 按标签
  python recall.py --date 2026-10-22    # 某天
  python recall.py --limit 10           # 条数上限（默认 15）
  python recall.py --budget 2000        # 输出字符预算（默认 3600）
  python recall.py --facts              # 打事实库
  python recall.py --stale              # 列出该归档的老条目（不改文件）
  python recall.py --min-score 2        # 召回门槛：分数低于它不显示（默认 1）
  python recall.py --shadow 关键词       # 只打分不输出正文（调阈值用，不记 usage）

2026-11-08 改（陈「好，改吧」；参考 bigeye 的记忆衰减设计）：
  · 每条日记的 front matter 可写 `importance: 1-10`（默认 5）
  · importance >= 7 的条目**钉住不衰减**
  · 其余按 30 天半衰期衰减：0.5 ** (天数/30)
  · 输出有字符预算，按分数从高到低塞，塞满即停（不再无脑全塞）
  · --stale 只提示该归档的，**不自动删**，删不删由主人定

2026-11-09 改（陈「借鉴吧，自己改」；借鉴 dsh-memory-brain 的三条，但不上 FSRS-5 七参数，
本机数据量撑不起那套模型）：
  1. **淡出而不删除**：衰减基准从「文件日期」改成「最后一次被提起的日期」
     （`.recall-usage.json` 记），常被想起的旧事不会沉底；文件永不删，显式查永远查得到。
  2. **召回门槛 + shadow**：分数低于 `--min-score`（默认 1）不显示；
     `--shadow` 只打分不输出正文、不写 usage，用来先观察再决定阈值。
  3. **回指原文**：输出带上 `文件#L行号, 正文起于第 N 行`，方便顺着线索翻回去。

只读文本，不依赖任何模型或向量库。
"""
import json
import os, re, sys
from glob import glob
from datetime import date

HOME = os.path.expanduser("~")
BASE = os.path.join(HOME, ".dsh", "hippocampus")
EPISODES = os.path.join(BASE, "episodes")
FACTS = os.path.join(BASE, "facts.md")
USAGE = os.path.join(BASE, ".recall-usage.json")

IMPORTANCE_PIN = 7.0        # ≥ 这个分就不衰减
HALF_LIFE_DAYS = 30.0       # 半衰期
DEFAULT_BUDGET = 3600       # 输出字符硬顶
STALE_DAYS = 365            # 多少天没被提起算「老」（2026-11-09 从 30 改宽：有 usage 后按提起算）
DEFAULT_MIN_SCORE = 1.0     # 召回门槛


def load_usage():
    """{文件名: 最后被提起的 YYYY-MM-DD}，文件不存在就当空。"""
    try:
        with open(USAGE, encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return {}


def save_usage(usage):
    try:
        with open(USAGE, "w", encoding="utf-8") as f:
            json.dump(usage, f, ensure_ascii=False, indent=0, sort_keys=True)
    except Exception:
        pass


def parse_front_matter(text):
    meta = {}
    body = text
    body_start_line = 1
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.S)
    if m:
        for line in m.group(1).splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                v = v.strip()
                if v.startswith("[") and v.endswith("]"):
                    v = [x.strip() for x in v[1:-1].split(",") if x.strip()]
                meta[k.strip()] = v
        body = text[m.end():]
        body_start_line = m.group(0).count("\n") + 1
    return meta, body, body_start_line


def days_ago(datestr):
    """从 YYYY-MM-DD 算到今天。算不出来就当 0（不衰减，宁可不罚）。"""
    try:
        d = date.fromisoformat(str(datestr)[:10])
        return max(0, (date.today() - d).days)
    except Exception:
        return 0


def decay_factor(days, importance):
    """钉住的永不衰减；其余 30 天减一半。days 传的是「距最后一次被提起」的天数。"""
    if importance >= IMPORTANCE_PIN:
        return 1.0
    return 0.5 ** (days / HALF_LIFE_DAYS)


def load_all(usage=None):
    if usage is None:
        usage = load_usage()
    items = []
    for path in sorted(glob(os.path.join(EPISODES, "*.md")), reverse=True):
        try:
            text = open(path, encoding="utf-8").read()
        except Exception:
            continue
        meta, body, body_start_line = parse_front_matter(text)
        try:
            imp = float(meta.get("importance", 5))
        except (TypeError, ValueError):
            imp = 5.0
        name = os.path.basename(path)
        d = meta.get("date") or name[:-3]
        # 关键改动：衰减基准优先用「最后一次被提起」，没有才退回文件日期
        last = usage.get(name) or d
        items.append({
            "file": name,
            "date": d,
            "last": last,
            "type": meta.get("type", "event"),
            "tags": meta.get("tags") or [],
            "importance": imp,
            "days": days_ago(last),
            "file_days": days_ago(d),
            "score": 0.0,
            "body": body,
            "body_line": body_start_line,
            "text": text,
        })
    return items


def show(item, limit_chars=600):
    tags = " ".join("#" + t for t in item["tags"])
    pin = " ★" if item["importance"] >= IMPORTANCE_PIN else ""
    body = item["body"].strip()
    if len(body) > limit_chars:
        body = body[:limit_chars] + "\n…（截断，看全文: " + item["file"] + "）"
    fresh = "" if item["last"] == item["date"] else f"  最后提起 {item['last']}"
    print(f"── {item['date']} [{item['type']}] {tags}{pin}{fresh}")
    print(f"   ↳ {item['file']}#L{item['body_line']}")
    print(body)
    print()
    return len(body) + len(tags) + 80


def main():
    args = sys.argv[1:]
    usage = load_usage()
    items = load_all(usage)

    if "--facts" in args:
        print(open(FACTS, encoding="utf-8").read() if os.path.exists(FACTS) else "(无 facts.md)")
        return

    if "--stale" in args:
        cand = [x for x in items
                if x["days"] >= STALE_DAYS and x["importance"] < IMPORTANCE_PIN]
        if not cand:
            print(f"没有超过 {STALE_DAYS} 天没被提起、且未被钉住的条目。（很好，不用归档）")
            return
        print(f"以下 {len(cand)} 条超过 {STALE_DAYS} 天没被提起且 importance<{IMPORTANCE_PIN:.0f}，"
              f"可以考虑移进 archive/：\n")
        for x in cand:
            print(f"  {x['date']}  importance={x['importance']:.0f}  {x['file']}  "
                  f"{' '.join('#'+t for t in x['tags'])}")
        print("\n（只是提示，没有动任何文件。）")
        return

    limit = 15
    if "--limit" in args:
        i = args.index("--limit")
        try:
            limit = int(args[i + 1]); del args[i:i + 2]
        except Exception:
            pass

    budget = DEFAULT_BUDGET
    if "--budget" in args:
        i = args.index("--budget")
        try:
            budget = int(args[i + 1]); del args[i:i + 2]
        except Exception:
            pass

    min_score = DEFAULT_MIN_SCORE
    if "--min-score" in args:
        i = args.index("--min-score")
        try:
            min_score = float(args[i + 1]); del args[i:i + 2]
        except Exception:
            pass

    shadow = "--shadow" in args
    if shadow:
        args.remove("--shadow")

    if "--date" in args:
        i = args.index("--date")
        d = args[i + 1] if i + 1 < len(args) else ""
        del args[i:i + 2]
        items = [x for x in items if d in x["date"]]

    if "--tag" in args:
        i = args.index("--tag")
        t = args[i + 1] if i + 1 < len(args) else ""
        del args[i:i + 2]
        items = [x for x in items if t in (x["tags"] or [])]

    kws = [a for a in args if not a.startswith("--")]
    if kws:
        scored = []
        for it in items:
            hay = it["text"].lower()
            hit = sum(hay.count(k.lower()) for k in kws)
            taghit = sum(1 for k in kws for t in it["tags"] if k.lower() in t.lower())
            if hit or taghit:
                raw = hit + taghit * 2
                it["score"] = raw * decay_factor(it["days"], it["importance"])
                if it["score"] >= min_score:
                    scored.append(it)
        scored.sort(key=lambda x: (-x["score"], x["date"]))
        items = scored
    else:
        items = items[:7]

    if shadow:
        print(f"（shadow 模式：只打分，不输出正文，不记 usage；门槛 min-score={min_score}）")
        for it in items[:limit]:
            print(f"  {it['score']:6.2f}  {it['date']}  {it['file']}  "
                  f"离上次提起 {it['days']} 天  {' '.join('#'+t for t in it['tags'])}")
        if not items:
            print("  （没有命中）")
        return

    if not items:
        print(f"没找到。试试别的词，或 python recall.py --facts"
              + (f"（当前门槛 min-score={min_score}，可能被筛掉了，加 --min-score 0 看看）"
                 if kws else ""))
        return

    today = date.today().isoformat()
    used, shown = 0, 0
    for it in items:
        if shown >= limit:
            break
        remaining = budget - used
        if remaining < 120:
            print(f"…（预算 {budget} 字符用完，还有 {len(items) - shown} 条没列；"
                  f"要看得加 --budget）")
            break
        # 按剩余预算动态截断正文：预算再小也至少能看到第一条的开头，不空手而归
        used += show(it, limit_chars=max(80, min(600, remaining - 70)))
        shown += 1
        # 被检索到并输出 = 被「提起」一次，刷新它的淡出基准
        usage[it["file"]] = today

    if shown:
        save_usage(usage)


if __name__ == "__main__":
    main()
