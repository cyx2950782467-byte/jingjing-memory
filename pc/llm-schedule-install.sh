#!/usr/bin/env bash
# 本地 Qwen3-4B 的定时开关 + 与 ComfyUI 互斥（鲸鲸 2026-11-14）
# 背景：1050Ti 只有 4G 显存，Qwen3-4B(Q4) 要占 ~2.5-3G，ComfyUI 出图也要 2-3G，同时开会 OOM 或降速。
# 用法（电脑上一条命令装好）：
#   curl -fsSL https://cdn.jsdelivr.net/gh/cyx2950782467-byte/jingjing-memory@main/pc/llm-schedule-install.sh -o /tmp/l.sh && bash /tmp/l.sh
# 装完后：
#   ~/.dsh/llmctl.sh start|stop|status|guard   手动控
#   cron：工作日 08:30 开、18:30 关；每 10 分钟 guard 一次（发现 ComfyUI 在跑就把模型让位）
set -u
D="$HOME/.dsh"; mkdir -p "$D"
CTL="$D/llmctl.sh"; LOG="$D/llm.log"; PID="$D/llm.pid"
MODEL="${LLM_MODEL:-}"
PORT="${LLM_PORT:-8080}"

echo "== 0) 探测这台机器上的本地模型 =="
echo "llama-server: $(command -v llama-server || true)$(ls -l "$HOME"/llama.cpp/build/bin/llama-server 2>/dev/null | awk '{print "  "$NF}' || true)"
echo "~/bin/pc-llm: $( [ -f "$HOME/bin/pc-llm" ] && echo 有 || echo 没找到 )"
if [ -f "$HOME/bin/pc-llm" ]; then echo "--- 它的内容 ---"; head -20 "$HOME/bin/pc-llm" | sed 's/^/  /'; fi
echo "--- 可能的 gguf 模型 ---"
find "$HOME" -maxdepth 4 -iname "*.gguf" 2>/dev/null | head -5 | sed 's/^/  /'
echo "--- 现在 8080 端口 ---"; (ss -ltnp 2>/dev/null | grep ":$PORT " || echo "  空闲")
echo "--- 现在显存 ---"; nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader 2>/dev/null | sed 's/^/  /'

echo
echo "== 1) 写控制脚本 $CTL =="
cat > "$CTL" <<SH
#!/usr/bin/env bash
# 只管它自己拉起的那个进程（PID 记在 ~/.dsh/llm.pid），不会误杀别的 llama 进程
D="\$HOME/.dsh"; PIDF="\$D/llm.pid"; LOG="\$D/llm.log"; PORT="\${LLM_PORT:-$PORT}"
MODEL="\${LLM_MODEL:-$MODEL}"
BIN="\${LLM_BIN:-\$(command -v llama-server || echo "\$HOME/llama.cpp/build/bin/llama-server")}"

comfy_running() { ss -ltn 2>/dev/null | grep -q ':8188 '; }
alive() { [ -f "\$PIDF" ] && kill -0 "\$(cat "\$PIDF")" 2>/dev/null; }

start() {
  if comfy_running; then echo "ComfyUI 在跑(8188)，模型让位，不启动"; return 1; fi
  if alive; then echo "已经在跑 pid \$(cat "\$PIDF")"; return 0; fi
  [ -n "\$MODEL" ] && [ -f "\$MODEL" ] || { echo "没找到模型文件：请设 LLM_MODEL=/path/to/qwen3-4b.gguf"; return 2; }
  [ -x "\$BIN" ] || { echo "没找到 llama-server：请设 LLM_BIN=/path"; return 2; }
  nohup "\$BIN" -m "\$MODEL" --host 127.0.0.1 --port "\$PORT" -ngl 99 -c 8192 >> "\$LOG" 2>&1 &
  echo \$! > "\$PIDF"
  sleep 4
  alive && { echo "已启动 pid \$(cat "\$PIDF") 端口 \$PORT"; return 0; } || { echo "启动失败，看 \$LOG"; return 3; }
}

stop() {
  if alive; then kill "\$(cat "\$PIDF")" 2>/dev/null; sleep 2; kill -9 "\$(cat "\$PIDF")" 2>/dev/null; rm -f "\$PIDF"; echo "已停"; else echo "没在跑"; fi
}

status() {
  alive && echo "模型: 跑着 pid \$(cat "\$PIDF")" || echo "模型: 没跑"
  comfy_running && echo "ComfyUI: 在跑(8188)" || echo "ComfyUI: 没跑"
  ss -ltn 2>/dev/null | grep -q ":\$PORT " && echo "端口 \$PORT: 监听中" || echo "端口 \$PORT: 空闲"
  nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader 2>/dev/null | awk '{print "显存: "\$0}'
}

guard() {   # 给 ComfyUI / 游戏让位
  if comfy_running && alive; then echo "\$(date '+%F %T') guard: ComfyUI 起来了 → 停模型" >> "\$LOG"; stop; fi
}

case "\${1:-status}" in
  start) start ;; stop) stop ;; status) status ;; guard) guard ;;
  *) echo "用法: \$0 {start|stop|status|guard}"; exit 2 ;;
esac
SH
chmod +x "$CTL"
echo "  写好并 +x"

echo
echo "== 2) 装 cron：工作日定时 + 每 10 分钟让位检查 =="
( crontab -l 2>/dev/null | grep -v "llmctl.sh"
  echo "30 8 * * 1-5 $CTL start >/dev/null 2>&1"
  echo "30 18 * * 1-5 $CTL stop >/dev/null 2>&1"
  echo "*/10 * * * * $CTL guard >/dev/null 2>&1"
) | crontab -
crontab -l | tail -3 | sed 's/^/  /'

echo
echo "== 3) 现在状态 =="
"$CTL" status | sed 's/^/  /'

echo
echo "== 说明 =="
cat <<'TXT'
  · 定时窗口是「工作日 08:30–18:30」，正好在你上班、不跑 ComfyUI 和游戏的时段。
  · 每 10 分钟检查一次：ComfyUI 一旦起来（8188 在监听），模型立刻让出显存。
  · 想换时间就改 crontab：crontab -e，改那两行的小时。
  · 模型文件/二进制没自动找到的话，先跑：LLM_MODEL=/路径/qwen3-4b.gguf LLM_BIN=/路径/llama-server ~/.dsh/llmctl.sh start
TXT
