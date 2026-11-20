---
id: 20261120-222555-jupyter-jexec-rvc
title: 云主机稳定通道（Jupyter+jexec）与云上已有资产：RVC 晓伊音色模型已训好
tags: AutoDL, Jupyter, jexec, RVC, 晓伊音色, ACE-Step, 云主机, 2026-11-20, 鲸鲸
created: 2026-11-20T14:25:55.536Z
updated: 2026-11-20T14:25:55.536Z
---

2026-11-20 晚，云主机（AutoDL）**稳定通道终于打通了**，以后别再走 SSH 跳板反复重试。

**通道**：AutoDL 实例的 Jupyter 服务，
- 主机 `https://a1272644-87b7-bcc0ce2d.westc.seetacloud.com:8443/jupyter`
- token 取自实例终端里的 `jupyter server list`，形如 `jupyter-autodl-container-f6144d87b7-bcc0ce2d-...`（每次实例重启会变，需要重新取）
- 手机上的执行器：`~/jexec.py "shell 命令" [超时秒]` —— 走 Jupyter HTTPS API + WebSocket，在一个 python3 kernel 里用 subprocess 跑 bash，回传 stdout/stderr。**实测能跑，且比 SSH 稳得多**。
- 注意：同一个 kernel 里的命令是串行的，长命令会让后续调用超时；长任务要 `nohup ... &` 甩到后台，再另开调用看日志。

**云上已经有的东西**（省一大截工作）：
- `/root/autodl-tmp/rvc`：RVC-WebUI 全套（py312），`assets/pretrained_v2/f0D40k.pth`、`f0G40k.pth` 都在
- `/root/autodl-tmp/rvc/logs/xiaoyi/`：**已经训练好的晓伊音色模型**（`G_2333333.pth` + `added_IVF633_Flat_nprobe_1_xiaoyi_v2.index`）
- `/root/autodl-tmp/rvc/logs/chenvoice/`：同样训练过一套（陈的音色？）
- `/root/autodl-tmp/xiaoyi/`：39 段晓伊音频；`/root/autodl-tmp/chenvoice/`：20 段
- `/root/autodl-tmp/ACE-Step`：ACE-Step 源码已 clone，依赖还差几个包（py3langid 装了，torchaudio 已换成 cu126 2.7.1 匹配版；`pip install -r req` 仍 rc=2，原因未查明——磁盘/日志异常，明天继续）

**下一步（明天我自动接）**：修完 ACE-Step 依赖 → 生成《送别》或原创 60 秒人声 → 用 RVC 的 xiaoyi 模型把音色换成她 → 与 MV v4 合成。
（云主机按小时计费，不跑任务时记得离线/关机，陈可操作。）

