#!/bin/bash

MSG="$(cat)"

paplay ~/.local/share/sounds/event.wav

notify-send \
    -u critical \
    "󰃭 Calendar" \
    "$MSG"
