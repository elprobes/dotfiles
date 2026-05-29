#!/usr/bin/env bash

iface="enp7s0"

declare -a history_down
declare -a history_up

max_history=30
max_speed=100
interval=0.3

bars=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

colors=(
    "#7aa2f7" # blue
    "#9ece6a" # green
    "#e0af68" # yellow
    "#f7768e" # red
)

blue_limit=$(awk -v m="$max_speed" 'BEGIN{print m*0.20}')
green_limit=$(awk -v m="$max_speed" 'BEGIN{print m*0.50}')
yellow_limit=$(awk -v m="$max_speed" 'BEGIN{print m*0.80}')

rx_file="/sys/class/net/$iface/statistics/rx_bytes"
tx_file="/sys/class/net/$iface/statistics/tx_bytes"

rx_prev=$(<"$rx_file")
tx_prev=$(<"$tx_file")
time_prev=$(date +%s.%N)

prev_down=0
prev_up=0

get_bar() {
    local speed="$1"

    local idx

    idx=$(awk \
        -v s="$speed" \
        -v max="$max_speed" \
        -v n="${#bars[@]}" '
        BEGIN {
            if (s < 0) s = 0

            # scala logaritmica
            ratio = log(s + 1) / log(max + 1)

            i = int(ratio * n)

            if (i >= n) i = n - 1
            if (i < 0) i = 0

            print i
        }')

    REPLY="${bars[$idx]}"
}

get_color() {
    local speed="$1"

    if (($(awk "BEGIN{print ($speed < $blue_limit)}"))); then
        REPLY="${colors[0]}"
    elif (($(awk "BEGIN{print ($speed < $green_limit)}"))); then
        REPLY="${colors[1]}"
    elif (($(awk "BEGIN{print ($speed < $yellow_limit)}"))); then
        REPLY="${colors[2]}"
    else
        REPLY="${colors[3]}"
    fi
}

while true; do

    sleep "$interval"

    rx_now=$(<"$rx_file")
    tx_now=$(<"$tx_file")

    time_now=$(date +%s.%N)

    bytes_down=$((rx_now - rx_prev))
    bytes_up=$((tx_now - tx_prev))

    elapsed=$(awk \
        -v now="$time_now" \
        -v prev="$time_prev" \
        'BEGIN { printf "%.6f", now - prev }')

    time_prev="$time_now"

    rx_prev=$rx_now
    tx_prev=$tx_now

    # Mbps istantanei
    down=$(awk \
        -v b="$bytes_down" \
        -v e="$elapsed" \
        'BEGIN {
        if (e <= 0) e = 0.001
        printf "%.3f", b * 8 / e / 1000000
    }')

    up=$(awk \
        -v b="$bytes_up" \
        -v e="$elapsed" \
        'BEGIN {
        if (e <= 0) e = 0.001
        printf "%.3f", b * 8 / e / 1000000
    }')
    # smoothing pesato
    smooth_down=$(awk \
        -v p="$prev_down" \
        -v c="$down" \
        'BEGIN { printf "%.3f", p*0.35 + c*0.65 }')

    smooth_up=$(awk \
        -v p="$prev_up" \
        -v c="$up" \
        'BEGIN { printf "%.3f", p*0.35 + c*0.65 }')

    prev_down="$smooth_down"
    prev_up="$smooth_up"

    get_color "$smooth_down"
    down_color="$REPLY"

    get_bar "$smooth_down"
    down_bar="$REPLY"

    history_down+=("$(printf '%%{F%s}%s%%{F-}' \
        "$down_color" \
        "$down_bar")")

    get_color "$smooth_up"
    up_color="$REPLY"

    get_bar "$smooth_up"
    up_bar="$REPLY"

    history_up+=("$(printf '%%{F%s}%s%%{F-}' \
        "$up_color" \
        "$up_bar")")

    ((${#history_down[@]} > max_history)) &&
        history_down=("${history_down[@]:1}")

    ((${#history_up[@]} > max_history)) &&
        history_up=("${history_up[@]:1}")

    display_down=$(awk -v v="$down" 'BEGIN { printf "%.1f", v }')
    display_up=$(awk -v v="$up" 'BEGIN { printf "%.1f", v }')

    printf "%%{F#9ece6a}%5s Mb/s %%{T3}󰈀%%{T-}%%{F-} %s %%{F#9ece6a}%%{T2}󰁅%%{T-}%%{F-} %%{F#9ece6a}%5s Mb/s %%{T3}󰈀%%{T-}%%{F-} %s %%{F#9ece6a}%%{T2}󰁝%%{T-}%%{F-}\n" \
        "$display_down" \
        "$(printf '%s' "${history_down[@]}")" \
        "$display_up" \
        "$(printf '%s' "${history_up[@]}")"

done
