---
id: 20261104-220935-comfyui-torch-wheel
title: 待办：ComfyUI 的 torch 装不上（wheel 下载损坏）
tags: 待办, ComfyUI, torch, 安装失败, 清华源, 2026-11-04, 鲸鲸
created: 2026-11-04T14:09:35.109Z
updated: 2026-11-04T14:09:35.109Z
---

## 待办：ComfyUI 的 torch 装不上（2026-11-04）

陈明确要求把这条记成待办，别忘了。

**现象**：`pip install torch` 时 wheel 下载损坏 —— 539MB 只下到 514MB，报 `ERROR: Wheel is invalid`。

**已就绪的部分**：
- Miniconda 在 `~/miniconda3`（官方源被墙，用的**清华镜像**）
- conda 环境 `comfy`（Python 3.11.18）
- 模型软链接已建：`~/ComfyUI/models/checkpoints/sd_turbo.safetensors -> /mnt/m2/sd_turbo.safetensors`
- `sd_turbo.safetensors` 校验过：5,214,561,328 字节，完整

**网络关键**：
- ❌ `repo.anaconda.com`、`download.pytorch.org` 被墙
- ✅ `https://pypi.tuna.tsinghua.edu.cn/simple`（清华 PyPI）可用
- ✅ 清华 anaconda 镜像可用

**下一步思路**（没试过，下次接着干）：
1. 用清华 PyPI 源装 torch：`pip install torch --index-url https://pypi.tuna.tsinghua.edu.cn/simple`
2. 或者 `pip download` 断点续传后再 `pip install ./torch-*.whl`
3. ⚠️ 内存混插不稳定时**别装**——下载写入出错可能又是内存问题（11-03 就发生过 `sd_turbo` 少 67MB）

**依赖的现状**：torch 之外的其他依赖都还没装（ComfyUI 跑不起来）。

