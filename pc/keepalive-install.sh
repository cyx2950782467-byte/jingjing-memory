#!/usr/bin/env bash
# 电脑侧「不许掉线」自愈安装（鲸鲸 2026-11-14）
# 作用：让宿舍电脑自己盯着 Tailscale，掉线就重连；每 5 分钟写心跳，方便手机判断"是睡了/断网/还是 Tailscale 挂了"。
# 用法（电脑上一条命令）：
#   curl -fsSL https://gh-proxy.com/https://raw.githubusercontent.com/cyx2950782467-byte/jingjing-memory/main/pc/keepalive-install.sh | bash
# 幂等：可以重复跑。所有改动都在 ~/.dsh/ 和 crontab，不碰系统文件（除了提示你要不要 sudo）。
set -u
D="$HOME/.dsh"
mkdir -p "$D"
HB="$D/heartbeat.log"
SELF="$D/tailscale-selfheal.sh"

echo "== 0) 现状 =="
echo "主机: $(hostname)"
echo "在线接口:"; (ip -4 addr show 2>/dev/null | grep -E "inet .*(eth|wlan|enp|wlp)" || true) | sed 's/^/  /'
echo "tailscale 命令: $(command -v tailscale || echo 没装)"
if command -v tailscale >/dev/null 2>&1; then
  tailscale status 2>&1 | head -5 | sed 's/^/  /'
fi
echo "本机 SSID: $(iwgetid -r 2>/dev/null || echo '?')"

echo
echo "== 1) 写自愈脚本 $SELF =="
cat > "$SELF" <<'SH'
#!/usr/bin/env bash
# 每 2 分钟跑一次：Tailscale 不通就尝试重连；无论通不通都写心跳
HB="$HOME/.dsh/heartbeat.log"; mkdir -p "$(dirname "$HB")"
ts_ok() { timeout 5 ping -c1 -W2 100.100.100.100 >/dev/null 2>&1; }
if ts_ok; then
  echo "$(date '+%F %T') tailscale=up ip=$(hostname -I | awk '{print $1}')" >> "$HB"
  exit 0
fi
echo "$(date '+%F %T') tailscale=DOWN 尝试重连" >> "$HB"
# 三种重连方式，谁能用就用谁（tailscaled 以 operator 身份运行时第二条不需要 sudo）
tailscale up --reset --accept-routes >/dev/null 2>&1 \
  || sudo -n tailscale up --reset --accept-routes >/dev/null 2>&1 \
  || systemctl restart tailscaled >/dev/null 2>&1 \
  || sudo -n systemctl restart tailscaled >/dev/null 2>&1
sleep 8
if ts_ok; then echo "$(date '+%F %T') recovered" >> "$HB"; else echo "$(date '+%F %T') still down（可能是网断了/没登录）" >> "$HB"; fi
SH
chmod +x "$SELF"
echo "  写好并 +x"

echo
echo "== 2) 装 cron（每 2 分钟自愈） =="
( crontab -l 2>/dev/null | grep -v "tailscale-selfheal.sh" ; echo "*/2 * * * * $SELF >/dev/null 2>&1" ) | crontab -
crontab -l | tail -2 | sed 's/^/  /'

echo
echo "== 3) 立刻跑一次 =="
"$SELF"; tail -2 "$HB" | sed 's/^/  /'

echo
echo "== 4) 需要你（或 sudo）做的两件 =="
cat <<'TXT'
  a) 让 tailscale 免 sudo：
       sudo tailscale set --operator=$USER
  b) 确认 tailscaled 开机自启：
       sudo systemctl enable --now tailscaled
  做完这两条，掉线就会自己回来，手机侧 ~/dsh-guard.sh 每 5 分钟就能发现。
TXT
echo
echo "== 完成。心跳文件：$HB =="
