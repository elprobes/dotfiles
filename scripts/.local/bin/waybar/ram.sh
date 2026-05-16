#!/bin/bash

blocks=("⡀" "⡄" "⡆" "⡇" "⣇" "⣧" "⣷" "⣿")

get_idx() {
    local percent=$1

    if ((percent < 12)); then
        return 0
    elif ((percent < 25)); then
        return 1
    elif ((percent < 37)); then
        return 2
    elif ((percent < 50)); then
        return 3
    elif ((percent < 62)); then
        return 4
    elif ((percent < 75)); then
        return 5
    elif ((percent < 87)); then
        return 6
    else
        return 7
    fi
}

while true; do

    while read -r key value _; do
        case "$key" in
            MemTotal:)
                total_kb=$value
                ;;
            MemAvailable:)
                avail_kb=$value
                ;;
        esac
    done < /proc/meminfo

    used_kb=$((total_kb - avail_kb))

    usage=$((used_kb * 100 / total_kb))

    get_idx "$usage"
    idx=$?

    if ((usage < 40)); then
        graph_color="#e0af68"

    elif ((usage < 75)); then
        graph_color="#e0af68"

    else
        graph_color="#f7768e"
    fi

    text=$(printf "<span foreground='#e0af68'>%3d%% <span font='Cascadia Mono PL 20' rise='-3000'>󰍛</span></span><span foreground='%s' font='Cascadia Mono PL 12'>%s</span>" \
        "$usage" \
        "$graph_color" \
        "${blocks[$idx]}")

    printf '{"text":"%s"}\n' "$text"

    sleep 2

done
