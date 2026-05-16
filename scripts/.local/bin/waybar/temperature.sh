#!/bin/bash

blocks=("⡀" "⡄" "⡆" "⡇" "⣇" "⣧" "⣷" "⣿")

TEMP_FILE="/sys/class/thermal/thermal_zone3/temp"

[ ! -r "$TEMP_FILE" ] && exit 1

get_idx() {
    local temp=$1

    if ((temp < 35)); then
        return 0
    elif ((temp < 45)); then
        return 1
    elif ((temp < 55)); then
        return 2
    elif ((temp < 65)); then
        return 3
    elif ((temp < 72)); then
        return 4
    elif ((temp < 78)); then
        return 5
    elif ((temp < 85)); then
        return 6
    else
        return 7
    fi
}

get_color() {
    local temp=$1

    if ((temp < 45)); then
        REPLY="#9ece6a"

    elif ((temp < 65)); then
        REPLY="#e0af68"

    elif ((temp < 80)); then
        REPLY="#ff9e64"

    else
        REPLY="#f7768e"
    fi
}

while true; do

    read -r raw < "$TEMP_FILE"

    temp=$((raw / 1000))

    get_idx "$temp"
    idx=$?

    get_color "$temp"
    color="$REPLY"

    text=$(printf "<span foreground='%s' rise='-1500'>%2d°C <span font='Cascadia Mono PL 16' rise='-3000'>󰔏</span></span><span foreground='%s' font='Cascadia Mono PL 14'>%s</span>" \
        "$color" \
        "$temp" \
        "$color" \
        "${blocks[$idx]}")

    printf '{"text":"%s"}\n' "$text"

    sleep 5

done
