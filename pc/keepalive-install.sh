#!/usr/bin/env bash
# 电脑侧「不许掉线」自愈安装 v2（鲸鲸 2026-11-14）
# v2 新增：链路断了先让**本机小模型（Qwen3-4B）**看日志判断原因，再从白名单里挑一条命令执行。
#          模型挂/答不对时退回纯 shell 的固定动作，不会因此卡死。
# 用法（电脑上一条命令）：
#   curl -fsSL https://gh-proxy.com/https://raw.githubusercontent.com/cyx2950782467-byte/jingjing-memory/main/pc/keepalive-install.sh | bash
set -u
D="$HOME/.dsh"
mkdir -p "$D"
HB="$D/heartbeat.log"
SELF="$D/tailscale-selfheal.sh"
AGENT="$D/pc-agent.sh"
STATE="$D/selfheal-fail-count"

echo "== 0) 现状 =="
echo "主机: $(hostname)"
echo "IP: $(hostname -I 2>/dev/null)"
echo "SSID: $(iwgetid -r 2>/dev/null || echo '?')"
echo "tailscale: $(command -v tailscale || echo 没装)"
command -v tailscale >/dev/null 2>&1 && tailscale status 2>&1 | head -4 | sed 's/^/  /'
echo "本地模型调用器: $(ls -l "$HOME/bin/pc-llm" 2>/dev/null | awk '{print $NF}' || echo '没找到 ~/bin/pc-llm')"

echo
echo "== 1) 写小模型值守脚本 $AGENT =="
cat > "$AGENT" <<'SH'
#!/usr/bin/env bash
# 由 tailscale-selfheal.sh 在「连续 3 次不通」时调用：让本机小模型看现场，输出一条修复命令。
# 安全阀：模型输出必须命中白名单，否则一律不执行。
D="$HOME/.dsh"; HB="$D/heartbeat.log"
TS() { timeout 5 ping -c1 -W2 100.100.100.100 >/dev/null 2>&1; }
TS && { echo "$(date '+%F %T') agent: 链路已恢复，不动" >> "$HB"; exit 0; }

CTX=$( { echo "### ip"; ip -4 addr show 2>/dev/null | grep inet;
         echo "### wifi"; (iwgetid -r 2>/dev/null || nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | head -1);
         echo "### tailscale status"; timeout 8 tailscale status 2>&1 | head -12;
         echo "### tailscaled"; systemctl is-active tailscaled 2>&1;
         echo "### 最近日志"; tail -12 "$HB" 2>/dev/null; } 2>&1 | head -60)

PROMPT="你是这台 Linux 电脑的网络值守。下面是现场状态。只输出一条能修复 Tailscale/网络断连的 shell 命令，不要解释，不要代码块。可选命令只有这些：tailscale up --reset --accept-routes | sudo -n tailscale up --reset | systemctl restart tailscaled | sudo -n systemctl restart tailscaled | sudo -n nmcli networking off && sudo -n nmcli networking on | ip link set dev \$(ip route | awk '/default/{print \$5; exit}') up
现场：
$CTX"

CMD=""
if [ -x "$HOME/bin/pc-llm" ]; then
  CMD=$(timeout 120 bash "$HOME/bin/pc-llm" "$PROMPT" 2>/dev/null | tr -d '\r' | grep -vE '^\s*$' | tail -3 | tr '\n' ' ' | sed 's/```//g' | sed 's/^[[:space:]]*//')
fi
echo "$(date '+%F %T') agent: 模型建议 => ${CMD:-（模型没给出）}" >> "$HB"

allow() {
  case "$1" in
    "tailscale up --reset --accept-routes"|"sudo -n tailscale up --reset"|\
    "systemctl restart tailscaled"|"sudo -n systemctl restart tailscaled"|\
    "sudo -n nmcli networking off && sudo -n nmcli networking on") return 0 ;;
    *"ip link set dev"*" up") return 0 ;;
    *) return 1 ;;
  esac
}
run() { echo "$(date '+%F %T') agent: 执行 [$1]" >> "$HB"; timeout 60 bash -c "$1" >> "$HB" 2>&1; sleep 8;
        TS && echo "$(date '+%F %T') agent: 修好了 ✅" >> "$HB" || echo "$(date '+%F %T') agent: 还是不通" >> "$HB"; }

if [ -n "$CMD" ] && allow "$CMD"; then run "$CMD"
else
  echo "$(date '+%F %T') agent: 建议不在白名单/为空 → 走固定动作" >> "$HB"
  run "systemctl restart tailscaled"
  TS || run "sudo -n tailscale up --reset"
fi
SH
chmod +x "$AGENT"
echo "  写好并 +x"

echo
echo "== 2) 写自愈主脚本 $SELF =="
cat > "$SELF" <<SH2
#!/usr/bin/env bash
HB="$HOME/.dsh/heartbeat.log"; ST="$HOME/.dsh/selfheal-fail-count"; mkdir -p "\$(dirname "\$HB")"
echo 0 > "\$ST" 2>/dev/null || true
ts_ok() { timeout 5 ping -c1 -W2 100.100.100.100 >/dev/null 2>&1; }
if ts_ok; then
  echo "\$(date '+%F %T') tailscale=up ip=\$(hostname -I | awk '{print \$1}')" >> "\$HB"
  echo 0 > "\$ST"; exit 0
fi
N=\$(( \$(cat "\$ST" 2>/dev/null || echo 0) + 1 )); echo "\$N" > "\$ST"
echo "\$(date '+%F %T') tailscale=DOWN (\$N)" >> "\$HB"
# 前两次先走固定动作，别一上来就叫模型
if [ "\$N" -le 2 ]; then
  tailscale up --reset --accept-routes >/dev/null 2>&1 || sudo -n tailscale up --reset --accept-routes >/dev/null 2>&1 || systemctl restart tailscaled >/dev/null 2>&1 || sudo -n systemctl restart tailscaled >/dev/null 2>&1
  sleep 8
else
  bash "\$HOME/.dsh/pc-agent.sh"
fi
SH2
chmod +x "$SELF"
echo "  写好并 +x"

echo
echo "== 3) 装 cron（每 2 分钟） =="
( crontab -l 2>/dev/null | grep -v "tailscale-selfheal.sh" ; echo "*/2 * * * * $SELF >/dev/null 2>&1" ) | crontab -
crontab -l | tail -2 | sed 's/^/  /'

echo
echo "== 4) 立刻跑一次 =="
"$SELF"; tail -3 "$HB" | sed 's/^/  /'

echo
echo "== 5) 需要 sudo 做一次的两条 =="
cat <<'TXT'
  sudo tailscale set --operator=$USER     # 免 sudo 重连
  sudo systemctl enable --now tailscaled  # 开机自启
TXT
echo
echo "== 完成。小模型值守：$AGENT ；心跳：$HB =="
