#!/bin/bash

EVENT=$(calcurse --next 2>/dev/null | tail -1 | sed 's/^ *//')

paplay ~/.local/share/sounds/event.wav >/dev/null 2>&1 &

notify-send \
    -u critical \
    -h string:x-dunst-stack-tag:calendar \
    "󰃭 Calendar" \
    "$EVENT"

