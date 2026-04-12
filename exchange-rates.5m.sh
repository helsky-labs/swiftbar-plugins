#!/bin/bash
# <xbar.title>Currency Exchange Rates</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Hel Rabelo</xbar.author>
# <xbar.desc>USD and GBP to BRL exchange rates, updated every 5 minutes</xbar.desc>
# <xbar.dependencies>curl,python3</xbar.dependencies>

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

PYTHON=$(command -v python3 2>/dev/null)

if [ -z "$PYTHON" ]; then
    echo "BRL: N/A"
    echo "---"
    echo "⚠️ python3 not found | color=red"
    exit 1
fi

# Single call: get USD, GBP, BRL relative to EUR base
RESPONSE=$(/usr/bin/curl -sf --max-time 10 "https://api.frankfurter.dev/v1/latest?symbols=USD,GBP,BRL" 2>/dev/null)

if [ -z "$RESPONSE" ]; then
    echo "BRL: N/A"
    echo "---"
    echo "⚠️ Failed to fetch rates — check connection | color=red"
    echo "🔄 Retry | refresh=true"
    exit 1
fi

# Compute USD→BRL and GBP→BRL cross-rates from EUR base
PARSED=$(echo "$RESPONSE" | $PYTHON -c "
import sys, json
try:
    d = json.load(sys.stdin)
    r = d['rates']
    brl = r.get('BRL')
    usd = r.get('USD')
    gbp = r.get('GBP')
    if not all([brl, usd, gbp]):
        print('ERROR')
        sys.exit(1)
    usd_brl = brl / usd
    gbp_brl = brl / gbp
    date = d.get('date', 'unknown')
    print(f'{usd_brl:.4f} {gbp_brl:.4f} {date}')
except Exception:
    print('ERROR')
    sys.exit(1)
" 2>/dev/null)

if [ -z "$PARSED" ] || [[ "$PARSED" == ERROR* ]]; then
    echo "BRL: N/A"
    echo "---"
    echo "⚠️ Failed to parse response | color=red"
    echo "🔄 Retry | refresh=true"
    exit 1
fi

USD_BRL=$(echo "$PARSED" | awk '{print $1}')
GBP_BRL=$(echo "$PARSED" | awk '{print $2}')
DATE=$(echo "$PARSED" | awk '{print $3}')

# Short display (2 decimal places) for menu bar — LC_NUMERIC=C avoids locale comma issues
USD_SHORT=$(LC_NUMERIC=C printf "%.2f" "$USD_BRL")
GBP_SHORT=$(LC_NUMERIC=C printf "%.2f" "$GBP_BRL")

# Menu bar: avoid | in display text, use · as visual separator
echo "🇧🇷 \$${USD_SHORT} · £${GBP_SHORT}"

echo "---"
echo "Exchange Rates (→ BRL) | color=gray"
echo "---"
echo "🇺🇸  1 USD = ${USD_BRL} BRL | color=#22c55e"
echo "🇬🇧  1 GBP = ${GBP_BRL} BRL | color=#22c55e"
echo "---"
echo "Source: frankfurter.dev | color=gray"
echo "Updated: ${DATE} | color=gray"
echo "Refreshes every 5 min | color=gray"
echo "---"
echo "🔄 Refresh Now | refresh=true"
