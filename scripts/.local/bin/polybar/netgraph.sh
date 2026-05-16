#!/usr/bin/env bash

iface="enp7s0"

declare -a history_down
declare -a history_up

max_history=12

# ~75 Mbps ≈ 9375 KB/s
max_speed=9500

bars=("⡀" "⡄" "⡆" "⡇" "⣇" "⣧" "⣷" "⣿" "⢿" "⢻" "⢹" "⢸" "⠸" "⠘" "⠈")

colors=(
    "#7aa2f7" # blue
    "#9ece6a" # green
    "#e0af68" # yellow
    "#f7768e" # red
)

rx_file="/sys/class/net/$iface/statistics/rx_bytes"
tx_file="/sys/class/net/$iface/statistics/tx_bytes"

rx_prev=$(<"$rx_file")
tx_prev=$(<"$tx_file")

get_bar() {
    local speed=$1
    local idx=$(( speed * ${#bars[@]} / max_speed ))

    (( idx >= ${#bars[@]} )) && idx=$((${#bars[@]} - 1))

    REPLY="${bars[$idx]}"
}

get_color() {
    local speed=$1

    if (( speed < 1000 )); then
        REPLY="${colors[0]}"
    elif (( speed < 4000 )); then
        REPLY="${colors[1]}"
    elif (( speed < 7000 )); then
        REPLY="${colors[2]}"
    else
        REPLY="${colors[3]}"
    fi
}

while true; do

    sleep 1

    rx_now=$(<"$rx_file")
    tx_now=$(<"$tx_file")

    down=$(( (rx_now - rx_prev) / 1024 ))
    up=$(( (tx_now - tx_prev) / 1024 ))

    rx_prev=$rx_now
    tx_prev=$tx_now

    get_color "$down"
    down_color="$REPLY"

    get_bar "$down"
    down_bar="$REPLY"

    history_down+=("$(printf '%%{F%s}%s%%{F-}' \
        "$down_color" \
        "$down_bar")")

    get_color "$up"
    up_color="$REPLY"

    get_bar "$up"
    up_bar="$REPLY"

    history_up+=("$(printf '%%{F%s}%s%%{F-}' \
        "$up_color" \
        "$up_bar")")

    (( ${#history_down[@]} > max_history )) && \
        history_down=("${history_down[@]:1}")

    (( ${#history_up[@]} > max_history )) && \
        history_up=("${history_up[@]:1}")

    printf "%%{F#9ece6a}%6dKB/s %%{T4}󰈀%%{T-}%%{F-} %s %%{F#9ece6a}%%{T4}󰁅%%{T-}%%{F-} %%{F#9ece6a}%6dKB/s %%{T4}󰈀%%{T-}%%{F-} %s %%{F#9ece6a}%%{T4}󰁝%%{T-}%%{F-}\n" \
        "$down" \
        "$(printf '%s' "${history_down[@]}")" \
        "$up" \
        "$(printf '%s' "${history_up[@]}")"

done
