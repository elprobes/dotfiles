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

    if ((usage < 40)); then
        graph_color="#e0af68"

    elif ((usage < 75)); then
        graph_color="#e0af68"

    else
        graph_color="#f7768e"
    fi

    text=$(printf "<span foreground='#e0af68'>%3d%% <span font='Cascadia Mono PL 20' rise='-3000'>󰻠</span></span><span foreground='%s' font='Cascadia Mono PL 12'>%s</span>" \
        "$usage" \
        "$graph_color" \
        "${blocks[$idx]}")

    printf '{"text":"%s"}\n' "$text"

done
