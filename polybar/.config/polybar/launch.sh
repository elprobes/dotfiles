#!/usr/bin/env bash

killall -q polybar

until [ -p /tmp/audiograph/cava_mic_fifo ]; do
    sleep 0.5
done

while pgrep -u $UID -x polybar >/dev/null; do
 sleep 1
done

polybar top &
polybar bottom &
