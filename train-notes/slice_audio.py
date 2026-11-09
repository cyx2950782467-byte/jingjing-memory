#!/usr/bin/env python3
"""把一段录音按静音切成 3~10 秒的小块，供 RVC 训练用。
思路：用 ffmpeg silencedetect 拿到静音区间 → 在静音中点切 → 过滤过短/过长。
"""
import subprocess, os, re, sys

SRC = sys.argv[1] if len(sys.argv) > 1 else \
    "/data/user/0/com.dsh.android/files/workspace/deepseek-harness/default-workspace/rvc-data/rec0922/raw48k.wav"
OUT = sys.argv[2] if len(sys.argv) > 2 else \
    "/data/user/0/com.dsh.android/files/workspace/deepseek-harness/default-workspace/rvc-data/rec0922/slices"

os.makedirs(OUT, exist_ok=True)
for f in os.listdir(OUT):
    os.remove(os.path.join(OUT, f))

# 1) 静音检测
p = subprocess.run(["ffmpeg", "-i", SRC, "-af", "silencedetect=noise=-35dB:d=0.4", "-f", "null", "-"],
                   capture_output=True, text=True)
log = p.stderr
dur = float(subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration",
                            "-of", "csv=p=0", SRC], capture_output=True, text=True).stdout.strip())

starts = [float(x) for x in re.findall(r"silence_start: ([\d.]+)", log)]
ends = [float(x) for x in re.findall(r"silence_end: ([\d.]+)", log)]

# 2) 切点 = 每个静音段的中点
cuts = [0.0]
for s, e in zip(starts, ends):
    if e <= s:
        continue
    cuts.append((s + e) / 2)
cuts.append(dur)
cuts = sorted(set(cuts))

# 3) 按切点生成片段，合并过短的、拆分过长的
segs = []
i = 0
while i < len(cuts) - 1:
    a = cuts[i]
    b = cuts[i + 1]
    if b - a < 2.0 and i + 2 < len(cuts):      # 太短就并到下一段
        i += 1
        continue
    if b - a > 10.0:                            # 太长就切两半
        mid = a + (b - a) / 2
        segs.append((a, mid)); segs.append((mid, b))
    else:
        segs.append((a, b))
    i += 1

n = 0
total = 0.0
for a, b in segs:
    d = b - a
    if d < 1.5:
        continue
    n += 1
    out = os.path.join(OUT, "s%03d.wav" % n)
    subprocess.run(["ffmpeg", "-y", "-ss", "%.3f" % a, "-to", "%.3f" % b, "-i", SRC,
                    "-ar", "48000", "-ac", "1", out], capture_output=True)
    total += d

print(f"原始 {dur:.1f}s -> 切成 {n} 段，有效语音合计 {total:.1f}s（{total/60:.2f} 分钟）")
print("输出目录:", OUT)
