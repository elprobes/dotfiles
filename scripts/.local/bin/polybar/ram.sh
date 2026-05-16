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

    printf "%3d%% %%{T3}󱤓%%{T-}%%{T2}%s%%{T-} \n" \
        "$usage" \
        "${blocks[$idx]}"

    sleep 2
done
