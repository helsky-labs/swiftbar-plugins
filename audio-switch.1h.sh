#!/bin/bash
# <xbar.title>Audio Device Switcher</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Hel Rabelo</xbar.author>
# <xbar.desc>Switch audio input/output devices from the menu bar</xbar.desc>
# <xbar.dependencies>switchaudio-osx</xbar.dependencies>

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

SWITCH_CMD=$(command -v SwitchAudioSource 2>/dev/null)

if [ -z "$SWITCH_CMD" ]; then
    echo "🔊 Audio"
    echo "---"
    echo "⚠️ switchaudio-osx not installed | color=red"
    echo "---"
    echo "Install via Homebrew:"
    echo "  brew install switchaudio-osx | color=#888888"
    echo "---"
    echo "Open Terminal | bash=/usr/bin/open | param1=-a | param2=Terminal | terminal=false"
    exit 0
fi

# Get current devices (strip any trailing whitespace/newlines)
CURRENT_OUTPUT=$("$SWITCH_CMD" -c -t output 2>/dev/null | head -1 | tr -d '\r\n')
CURRENT_INPUT=$("$SWITCH_CMD" -c -t input 2>/dev/null | head -1 | tr -d '\r\n')

# Truncate for menu bar
if [ ${#CURRENT_OUTPUT} -gt 20 ]; then
    MENUBAR_LABEL="${CURRENT_OUTPUT:0:17}…"
else
    MENUBAR_LABEL="$CURRENT_OUTPUT"
fi

# Custom monochrome speaker template icon. Source: Resources/audio.png (18x18)
TEMPLATE_ICON="iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAABH0lEQVR4nKXUvy5EQRQG8N9dS4RkESIRChuVB9CSbCi0Ct5ApyEShceRoFXqVR5AtfEACIk/iT+L4p6bTO5aNu6XTM7MOd/9zpkzM5f+UEPWJ7cnBqoKZInIPJqJnz6rTAmbuMV6rOuleJdYFqMWYxbH+IqxEryiyj3slnxdGEY7BF7xiVbExjCKLXQwhaxW+ngC45jBdBCLXhRZd3COUzxgIxIaDMIB7nETthOEwq4GrxXrBo5wJrIVGIlqJsOmMbE9uAzxBVyJ0yyT/416Mn+R7/kj/I1SomK+JO9XG4u4LoumzW7iMUTf5T1ZC94hLmJ+h+3fKq10/OmFfMMyTjAU/k7wnvCMOezLb33PXld6Ij+JVX60KSr/RlL8mf0bwTs5IznoxZoAAAAASUVORK5CYII="
echo "${MENUBAR_LABEL:-Audio} | templateImage=${TEMPLATE_ICON}"
echo "---"

# Output devices
echo "OUTPUT | color=gray"
while IFS= read -r device; do
    [ -z "$device" ] && continue
    device=$(echo "$device" | tr -d '\r')
    if [ "$device" = "$CURRENT_OUTPUT" ]; then
        echo "✓ ${device} | bash=$SWITCH_CMD | param1=-s | param2=${device} | param3=-t | param4=output | terminal=false | refresh=true | color=#22c55e"
    else
        echo "  ${device} | bash=$SWITCH_CMD | param1=-s | param2=${device} | param3=-t | param4=output | terminal=false | refresh=true"
    fi
done < <("$SWITCH_CMD" -a -t output 2>/dev/null)

echo "---"

# Input devices
echo "INPUT | color=gray"
while IFS= read -r device; do
    [ -z "$device" ] && continue
    device=$(echo "$device" | tr -d '\r')
    if [ "$device" = "$CURRENT_INPUT" ]; then
        echo "✓ ${device} | bash=$SWITCH_CMD | param1=-s | param2=${device} | param3=-t | param4=input | terminal=false | refresh=true | color=#22c55e"
    else
        echo "  ${device} | bash=$SWITCH_CMD | param1=-s | param2=${device} | param3=-t | param4=input | terminal=false | refresh=true"
    fi
done < <("$SWITCH_CMD" -a -t input 2>/dev/null)

echo "---"
echo "🔄 Refresh | refresh=true"
