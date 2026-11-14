# DeepSeek 官方全家桶 API（2026-11-14 接入并实测）

> 起因：陈 08:26 发了《DeepSeek 开放全家桶 API》那条片。官方文档：`https://api-docs.deepseek.com/guides/build_a_chatbot`
> 全部用主人自己的 `DEEPSEEK_API_KEY`（`~/.dsh/.credentials.yaml`），不走第三方。
> **隐私内容也走这条**（这是主人自己的 API，符合 AGENTS 的隐私规矩）。

## 一、已经实测通的（手机端直接可用）

| 能力 | 端点 | 实测 | 封装 |
|---|---|---|---|
| **TTS 语音合成** | `POST https://api.deepseek.com/v1/tools/tts` | ✅ 200，`audio/wav` 24kHz 16bit 单声道，257KB/5.4s | `~/dsh-tools.sh tts "文本"` |
| **OCR** | `POST https://api.deepseek.com/v1/tools/ocr` | ✅ 200，逐页返回文本（截图里的字数、花括号、→ 都对） | `~/dsh-tools.sh ocr <文件>` |
| 聊天 + 搜索/读链接 | `POST /chat/completions`、`/responses`、`/anthropic/v1/messages` | 未测（要在会话里开工具参数，不是独立接口） | — |
| ASR 语音转文字 | `POST /v1/tools/asr` | 未测（手机麦克风本来就不可用） | — |

### TTS 关键参数（官方文档原样）
- 音色：`stella`（女，默认）/ `tide`（男）
- 语言不用传，**从文本自动判断**：zh / yue / en / ja / ko / ms / ar / id / th / vi 十种
- `format`：`wav`（默认，`audio/wav`）或 `pcm`（24kHz 16bit 单声道裸流）
- `filter_markdown` 默认 true
- 限制：单次 ≤ **1 万计费字符**、body ≤ 64KiB、单次最长 30 分钟；**语速控制和中断续传不支持**
- WebSocket 版 `wss://api.deepseek.com/v1/tools/tts` 可以边生成边合成（`{"event":"text"...}` + `finish_text`），适合"模型边说边出声音"
- 计费：**$0.45/万字符，限时五折 $0.225**；中文汉字按 **2 字符**计

### OCR 关键参数
- `multipart/form-data`：`file`（必须带文件名！见坑）+ `purpose`
- `purpose`：`text_recognition`（Word/PPT 无图直接抽文本，其余逐页识别）/ `rich_layout_recognition`（全部逐页，带版面）
- 返回 `pages[].text`，逐页识别时文本里夹着 `<｜ref｜>…<｜/ref｜><｜box｜>[[x1,y1,x2,y2]]<｜/box｜>` 坐标（归一化 0–1000）
- 限制：≤100MiB、≤1000 页、上传 120s 内、总时长 180s；最多 15 个并发
- 计费：**$0.225/千页**，按成功页数算；失败/超时不收费
- ⚠️ **实测坑**：`-F "file=@图"` **不带 filename 会返回 200 但 text 为空**（output_tokens=0）。必须写成 `-F "file=@图;filename=x.png"`。

## 二、能替换我们哪段脆弱链路

| 现在的脆弱点 | 换成 | 收益 |
|---|---|---|
| **小屋语音 / 直播间配音**：Edge TTS 只有 Node 能连，Python/aiohttp 拿不到证书，插件一重装就坏 | 官方 TTS `stella`/`tide` | 少一层证书依赖；10 种语言自动判；有 WebSocket 能边说边出 |
| **读图/扫描件**：Pro 看不见图、Flash 靠视觉模型读字，贵且不稳 | 官方 OCR（独立接口，不占聊天图片额度） | 只读文字时便宜得多（$0.225/千页）；还能拿坐标自己裁图 |
| **联网搜索**：37 引擎经常 429/证书错 | 聊天请求里开 `deepseek_web_search` / `deepseek_read_url`（服务端执行，带引用） | 不用自己维护引擎池；引用是官方结构化的 |
| **文件问答**：现在靠本地 pdftotext 之类 | Files API 上传拿 file id + `rich_layout_recognition` | 图表能跟着文字一起进上下文 |

## 三、还没做的（下次接着做）

1. **把小屋 `whale-house/chat_server.py` 的 TTS 换成官方接口**（保留 Edge TTS 作 fallback）。要改 `_tts()` 那条链路，改完要真起服务实测一次，别只看返回码。
2. **ASR**：参数没查文档，手机麦克风也不可用，先放着。
3. **搜索/读链接**：这不是独立接口，是聊天请求里的工具参数，要接就得用 `/chat/completions` 走一遍并把返回块按文档回传 —— 属于"换掉 dsh-free-search"级别的大改动，不在睡前时段做。
4. **账单**：陈说"模型费与工具费分开算"，所以每次记账要分层写：模型 token / 搜索次数（$0.75/千次）/ 抓取次数 / 解析页数 / 语音字符。

## 四、成本参考（今天实测的那几次）
- TTS 两段共约 40 个汉字 ≈ 80 计费字符 → **约 $0.0018**
- OCR 两页成功 → **约 $0.00045**
- 结论：这类工具调用比模型 token 便宜得多，可以放心用来替掉那些"为了省钱绕弯路"的写法。
