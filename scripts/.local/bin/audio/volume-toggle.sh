#!/usr/bin/env bash

set -euo pipefail

pamixer -t

if pamixer --get-mute | grep -q true; then

    notify-send \
        -u low \
        -h string:x-canonical-private-synchronous:volume \
        "󰖁 Muted"

else

    volume=$(pamixer --get-volume)

    notify-send \
        -u low \
        -h string:x-canonical-private-synchronous:volume \
        "󰕾 Volume" \
        "${volume}%"

fi
