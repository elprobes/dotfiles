#!/usr/bin/env bash

iface="enp7s0"

declare -a history_down
declare -a history_up

max_history=12

# ~75 Mbps ≈ 9375 KB/s
max_speed=9500

bars=("⣀" "⣄" "⣆" "⣇" "⣧" "⣷" "⣿" "⠿" "⠛" "⠉")

rx_prev=$(<"/sys/class/net/$iface/statistics/rx_bytes")
tx_prev=$(<"/sys/class/net/$iface/statistics/tx_bytes")

get_bar() {
    local speed=$1

    local idx=$(( speed * ${#bars[@]} / max_speed ))

    (( idx >= ${#bars[@]} )) && idx=$((${#bars[@]} - 1))

    echo "${bars[$idx]}"
}

get_color() {
    local speed=$1

    if (( speed < 1000 )); then
        echo "#7aa2f7"   # blue
    elif (( speed < 4000 )); then
        echo "#9ece6a"   # green
    elif (( speed < 7000 )); then
        echo "#e0af68"   # yellow
    else
        echo "#f7768e"   # red
    fi
}

while true; do
    sleep 1

    rx_now=$(<"/sys/class/net/$iface/statistics/rx_bytes")
    tx_now=$(<"/sys/class/net/$iface/statistics/tx_bytes")

    down=$(( (rx_now - rx_prev) / 1024 ))
    up=$(( (tx_now - tx_prev) / 1024 ))

    rx_prev=$rx_now
    tx_prev=$tx_now

    history_down+=("$(printf '%%{F%s}%s%%{F-}' \
        "$(get_color "$down")" \
        "$(get_bar "$down")")")

    history_up+=("$(printf '%%{F%s}%s%%{F-}' \
        "$(get_color "$up")" \
        "$(get_bar "$up")")")

    (( ${#history_down[@]} > max_history )) && \
        history_down=("${history_down[@]:1}")

    (( ${#history_up[@]} > max_history )) && \
        history_up=("${history_up[@]:1}")

    printf "%6dKB/s %s 󰁅 %6dKB/s %s 󰁝\n" \
        "$down" \
        "$(printf '%s' "${history_down[@]}")" \
        "$up" \
        "$(printf '%s' "${history_up[@]}")"
done
