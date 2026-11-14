# 插件台账（2026-11-14 自建，鲸鲸自己管）

> 陈原话：「记忆备份等等插件的使用都靠你自己了……装了不用也是白费」。
> 规则：**能不用就不留**；留的写清用途；连续两周没用到的，列进「待观察」，再没用就停用。

## 手机 web profile（35 个依赖）

| 分组 | 插件 | 处置 |
|---|---|---|
| 核心（绝不能停） | dsh-android-bundle | 保留 |
| 核心（绝不能停） | dsh-core-memory | 保留 |
| 核心（绝不能停） | dsh-preset-razor | 保留 |
| 本会话用过 | dsh-drawai | 保留 |
| 本会话用过 | dsh-any-audio | 保留 |
| 本会话用过 | dsh-blender | 保留 |
| 本会话用过 | dsh-free-search | 保留 |
| 本会话用过 | dsh-gallery | 保留 |
| 本会话用过 | dsh-bili-scroll | 保留 |
| 本会话用过 | dsh-compaction-threshold | 保留 |
| 本会话用过 | dsh-deep-sea-theme | 保留 |
| 本会话用过 | billion-context | 保留 |
| 本会话用过 | ds-harness-remote | 保留 |
| 本会话用过 | @nanmicoder/dsh-agent-teams | 保留 |
| 本会话用过 | @a1exsun/dsh-council | 保留 |
| 未验证用途 | dsh-ielts-writing-examiner | 待观察（两周不用则停用） |
| 未验证用途 | dsh-memory-doctor | 待观察（两周不用则停用） |
| 未验证用途 | dsh-memory-sync | 待观察（两周不用则停用） |
| 未验证用途 | dsh-my-context | 待观察（两周不用则停用） |
| 未验证用途 | dsh-notify-me | 待观察（两周不用则停用） |
| 未验证用途 | dsh-pet | 待观察（两周不用则停用） |
| 未验证用途 | dsh-plugin-catalog | 待观察（两周不用则停用） |
| 未验证用途 | dsh-plugin-health | 待观察（两周不用则停用） |
| 未验证用途 | dsh-plugin-save-token | 待观察（两周不用则停用） |
| 未验证用途 | dsh-see-now | 待观察（两周不用则停用） |
| 未验证用途 | dsh-share-guard | 待观察（两周不用则停用） |
| 未验证用途 | dsh-step-governor | 待观察（两周不用则停用） |
| 未验证用途 | dsh-task-reliability | 待观察（两周不用则停用） |
| 未验证用途 | dsh-token-diet | 待观察（两周不用则停用） |
| 未验证用途 | dsh-trust-check | 待观察（两周不用则停用） |
| 未验证用途 | dsh-univer-office | 待观察（两周不用则停用） |
| 未验证用途 | dsh-unlag | 待观察（两周不用则停用） |
| 未验证用途 | dsh-video-storyboard | 待观察（两周不用则停用） |
| 未验证用途 | dsh-voice-chat | 待观察（两周不用则停用） |
| 未验证用途 | jiuling-remote | 待观察（两周不用则停用） |

## 备份链路（已自动化）

- `~/dsh-backup.sh`：记忆 → GitHub + 电脑 rsync，一条命令；刚跑通（commit ccaf0de）
- 12 小时 Dreaming 定时任务：读 handoff → 修正记忆 → memory_write → 同步
- 每日巡检：我自己跑 `~/dsh-backup.sh`，失败就写进 handoff
