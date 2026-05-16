#!/bin/bash

blocks=("⡀" "⡄" "⡆" "⡇" "⣇" "⣧" "⣷" "⣿")

read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

prev_idle=$((idle + iowait))
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))

while true; do
    sleep 1

    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

    idle_time=$((idle + iowait))
    total_time=$((user + nice + system + idle + iowait + irq + softirq + steal))

    diff_idle=$((idle_time - prev_idle))
    diff_total=$((total_time - prev_total))

    usage=$((100 * (diff_total - diff_idle) / diff_total))

    prev_idle=$idle_time
    prev_total=$total_time

    idx=$((usage * 8 / 100))

    [ "$idx" -gt 7 ] && idx=7

    printf "%3d%% %%{T4}󰻠%%{T-}%%{T2}%s%%{T-} \n" "$usage" "${blocks[$idx]}"
done
