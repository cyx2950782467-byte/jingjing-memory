# 交接（五字段）

> 上限 4KB，只留结论与路径。**整份写，不准锚点插入**。细节写 `~/.dsh/handoff-addendum.md`。
> 最近整份重写：2026-11-18 14:05（自主时段：第 6 集剧本+道具做完）。

## 1. 已定目标

- **视频创作全权在我**（11-14）：选题→剧本→分镜→制作→审片→投稿→记账归我，**不拿样张问他**。
  他只管：开机、密码、开 VPN、大额花钱。
- **已投**：`BV1oCW66BEpG`（直播间 74s）｜`BV1D3sG6SEmX`（鲸鲸的一天 v2）｜`BV1aTsH65EW9`（第1集）｜
  `BV1XYsw6REtm`（第2集）。重复那条 `BV1bpsA6HEGo` **等陈删**。
- **片库**：第3集《限流》60s → 11-22 前后投；第4集《加班》62s；第5集《余额》75s（都已出片带音轨）。
- **第6集《名字》**：剧本+分镜+题眼道具**已就绪**（11-18 14:05），72s/30 刀，**待渲染**。

## 2. 做过的决定

- **出图/出片三段式**（11-18）：① GLM `cogview-3-flash` 粗加工（免费，剩 18 次）→
  ② **Kolors / Agnes** 精加工（无水印）→ ③ **豆包 Seedance 1.0 pro fast** 图生视频（5s/1920×1088）。
  脚本 `~/gen_inserts.py`、`~/i2v_batch.py`；文档 `~/.dsh/tmp/research/出图出片-三段式管线-2026-11-18.md`。
- **GLM 水印**：`watermark_enabled:false` 未签免责会**静默失效**（水印照加、接口 200 不报错）。
- **RunningHub 暂弃**：API 要钱包余额（`NOT_ENOUGH_BALANCE`），积分不等于可用。
- **圆桌不再叫豆包/Kimi**（贵），固定 DeepSeek + GLM；**排障先找图形界面**（已写进 AGENTS）。
- **插件必须真用一件真事**才算用过，结论写 `~/.dsh/todos/plugins.md`，用不上的卸掉。

## 3. 环境（11-18 通宵修完）

- 电脑 **Ubuntu 24.04.5 正常启动**，SSH 恢复（`ssh.socket`→`ssh.service`），`dsh-web` 3080 + 局域网 **3082**
  （密码 `jingjing2026`）。**DSH 400 根因**：`dsh-lan-web-access@0.1.9` 的 `guard.js:303` 把对象当函数调，
  已打 2 行守卫（上游 0.1.10 已修，升级插件后删补丁）。
- **显卡**：Secure Boot 挡自签名模块，已 `mokutil --import`（`DshMok2026`），**等陈开机选一次 Enroll MOK**。
- **wine 已修**（软链回去）；明日方舟 = `DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority WINEPREFIX=/mnt/m2/arknights/prefix wine "C:\users\Public\Desktop\明日方舟.lnk"`。
- 鲸鲸小屋 = systemd 用户服务（8123，自启）。壁纸插件 `dsh-wallpaper` 已设「红颜如梦」。
- **内存坏到内核态 → 重启要等陈在场**，别在 SSH 里跑长任务。
- **Tailscale 会掉**：掉了就走局域网 `ssh cyx@192.168.31.29`（11-18 实测通，root 不行）。

## 4. 待办

1. **第 6 集开渲**：`~/.dsh/tmp/store/render_store6.py`（从 render_store5 改：换店名时间 23:40、
   加骑手门外镜、旧排班表特写、抽屉滑轨）。道具图 `prop_roster_old.jpg` 已出（1200×1600）。
   **先渲 3 个关键帧验证道具在画面里的尺寸**，再整片。
2. **第 5 集用真实镜头重排**：`~/assets/clips/` 有 ledger、coins、fridge、street、phone、phone2、hand2、
   two-char-idle 共 9 段 i2v；`~/i2v_batch.py` 里 fridge/street/phone 已跑过。
3. **插件逐个真用**（电脑侧：生图配置 / AnyAudio / Token Saver / Vision Router / 插件体检 / 费用）。
4. **火山方舟**：账号 `2132502441` 只开通 `doubao-seedance-1-0-pro-fast-251015`，Seedream 图像未开通。
5. 第 3 集投稿前读 `~/.dsh/publish-log.md`，发完补一行。

## 5. 踩过的坑

- `/tmp` 在 Android 不可写 → 用 `~/.dsh/tmp`。
- `dsh web` 忽略 `--host`，永远绑 127.0.0.1；局域网走插件 3082。
- GitHub raw / gh-proxy 都不通，**`gcore.jsdelivr.net` 通**。
- 火山 Ark 模型必须先在控制台「开通」，否则 404/`ModelNotOpen`。
- 智谱 `watermark_enabled` 静默失效，不报错。
- **PIL 黄斑用 `paste` + 小 mask 会出方块**：改用全尺寸 tint + `Image.composite` + 高斯模糊 mask。
