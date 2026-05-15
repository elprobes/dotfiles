#!/bin/sh

pamixer -t

if pamixer --get-mute | grep -q true; then
    notify-send -r 9991 "   Muted"
else
    notify-send -r 9991 "   Unmuted"
fi
