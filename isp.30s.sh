#!/bin/bash
# <swiftbar.title>ISP Monitor</swiftbar.title>
# <swiftbar.version>1.0</swiftbar.version>
# <swiftbar.author>Hel</swiftbar.author>
# <swiftbar.desc>Shows current active ISP based on public IP lookup</swiftbar.desc>
# <swiftbar.refreshInterval>30s</swiftbar.refreshInterval>

INFO=$(curl -s --max-time 5 https://ipinfo.io/json)

if [ -z "$INFO" ]; then
    echo "❌ No Internet"
    exit 0
fi

IP=$(echo "$INFO" | sed -n 's/.*"ip"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
ORG=$(echo "$INFO" | sed -n 's/.*"org"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
CITY=$(echo "$INFO" | sed -n 's/.*"city"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

if [ -z "$IP" ]; then
    echo "❌ Lookup Failed"
    exit 0
fi

if echo "$ORG" | grep -qiE "AS26599|AS18881|vivo|telef"; then
    LABEL="🟢 Vivo"
elif echo "$ORG" | grep -qiE "AS4230|AS28573|AS28343|claro|embratel|americanet"; then
    LABEL="🟠 Claro"
else
    LABEL="⚪ ${ORG:0:20}"
fi

STATE_FILE="$HOME/.isp_state"
LAST_IP=$(cat "$STATE_FILE" 2>/dev/null)

if [ "$LAST_IP" != "$IP" ] && [ -n "$LAST_IP" ]; then
    osascript -e "display notification \"Now on: $LABEL ($IP)\" with title \"ISP Changed\" sound name \"Glass\""
fi

echo "$IP" > "$STATE_FILE"

echo "$LABEL"
echo "---"
echo "IP: $IP | font=Menlo"
echo "Org: $ORG | font=Menlo"
echo "City: $CITY | font=Menlo"
echo "---"
echo "Refresh | refresh=true"
echo "Open ipinfo.io | href=https://ipinfo.io/$IP"
