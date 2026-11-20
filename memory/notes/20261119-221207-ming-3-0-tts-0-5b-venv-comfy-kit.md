---
id: 20261119-221207-ming-3-0-tts-0-5b-venv-comfy-kit
title: Ming-3.0-tts 在电脑上跑通：0.5B + 隔离 venv + comfy-kitchen 0.2.26 垫片（2026-11-19）
tags: Ming-3.0-tts, TTS, ComfyUI, 电脑, 模型下载, ModelScope, comfy-kitchen, 环境隔离, 2026-11-19, 鲸鲸
created: 2026-11-19T14:12:07.398Z
updated: 2026-11-19T14:12:07.398Z
---

## 结论
2026-11-19 晚在 `cyx@192.168.31.29` 上跑通 Ming-3.0-tts（ComfyUI 节点 `ComfyUI-Ming-3-tts`，模型 0.5B），CPU 出了一句中文试听 3.50 s。
产出：`~/.dsh/tmp/ming-tts-test.wav`（44.1 kHz 单声道）。复现说明写在 `~/ming-tts-test/README.md`。

## 关键事实（下次别再趟）
1. **原来那个「已装好」的节点其实是空克隆**：`~/ComfyUI/custom_nodes/ComfyUI-Ming-3-tts` 只有 `.git`，`git branch` 显示「尚无任何提交」。要 `git fetch --depth=1 origin main`（默认分支是 **main**，不是 master），gh-proxy 可通（但可能很慢，要后台跑）。
2. **模型只认 HF 仓库 `drbaph/Ming-3.0-tts-ComfyUI`**。`hf-mirror.com` 单线程 ~0.3 MB/s 且 **Range 请求一律 502**（不能续传/多线程）；**ModelScope 同名仓库存在**且 ~13 MB/s、支持 206 续传 → 永远优先走 ModelScope：
   `https://modelscope.cn/models/drbaph/Ming-3.0-tts-ComfyUI/resolve/master/checkpoints/...`
   0.5B 合并权重 `model.safetensors` = 2,959,055,504 B（2.76 GiB），放到 `~/ComfyUI/models/checkpoints/Ming-3.0-tts-0.5b/`；config/tokenizer/campplus.onnx 节点自带在 `assets/`。Tiny 9B 是 16.7 GiB，4G 显卡别想。
3. **ComfyUI 环境本身是残缺的**：`comfy` conda 环境缺 `comfy-aimdo`、`comfy-kitchen`、scipy、av、blake3 等，torchaudio 还是 ABI 坏的（undefined symbol），而且 `~/ComfyUI` 是较新的树（要 comfy-kitchen 0.2.40）。**别动这个环境**。
4. **新树要的 comfy-kitchen 0.2.40 在 torch 2.4.1 上 import 就炸**（custom-op 注解用 `list[int]`）。0.2.26 是可用的最高版本，且已带 `apply_rope` / `apply_rope_split_half`。中间版本分界：0.2.26 可 import，0.2.28+ 不可。
5. **做法**：`python -m venv --system-site-packages ~/ming-tts-test/venv`（基于 comfy 环境的 python），往里装 `comfy-kitchen==0.2.26`、`comfy-aimdo==0.6.0`、`torchaudio==2.4.1+cu121`、scipy/av/blake3 等，再把缺的 API 用 `compat.py` 打垫片（int8_decode 假模块、int8/fp8 探测返回 False、`torch.cuda.mem_get_info` 兜底）。comfy 环境一个包都没动。
6. **不能让它认 GPU**：`~/llm` 的 llama-server 常驻占 3.6G/4G 显存，而 ComfyUI 的 `model_management` 在 import 时就查显存，直接抛 CUDA OOM。脚本里 `sys.argv=[..., "--cpu"]` + compat 里兜住 mem_get_info。CPU bf16：加载 1.9 s，3.5 s 音频花了 292 s（45 步，约 6.5 s/步，约 80 倍实时）。

## 命令
```
cd ~/ming-tts-test
env MING_PRECISION=bf16 MING_DEVICE=cpu MING_VOICE=灵小安 MING_TEXT="……" ./venv/bin/python gen.py
```
`gen.py` 不走 ComfyUI 服务，直接 import 节点的 `loader`/`runtime`：把节点目录注册成包（`types.ModuleType` + `__path__`，别执行它的 `__init__.py`，那会拉 comfy_api→av）。

## 风险
第一次尝试跑到一半**电脑自己在 21:52 硬重启了**（journal 直接断掉，两 boot 之间空 10 分钟），符合已知的内存故障。长任务得陈在场。

