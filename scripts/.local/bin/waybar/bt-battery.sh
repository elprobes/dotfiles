#!/bin/bash

ICON_BT="󰂯"
ICON_OFF="󰂲"

battery_icons=(
    "󰂎"
    "󰁺"
    "󰁻"
    "󰁼"
    "󰁽"
    "󰁾"
    "󰁿"
    "󰂀"
)

get_device() {

    while IFS= read -r line; do

        case "$line" in
            Device*)
                REPLY=${line#Device }
                REPLY=${REPLY%% *}
                return
                ;;
        esac

    done < <(bluetoothctl devices Connected)

    REPLY=""
}

get_battery_icon() {
    local battery=$1

    if ((battery < 12)); then
        return 0
    elif ((battery < 25)); then
        return 1
    elif ((battery < 37)); then
        return 2
    elif ((battery < 50)); then
        return 3
    elif ((battery < 62)); then
        return 4
    elif ((battery < 75)); then
        return 5
    elif ((battery < 87)); then
        return 6
    else
        return 7
    fi
}

while true; do

    battery=""
    DEVICE=""

    get_device
    DEVICE="$REPLY"

    if [[ -n "$DEVICE" ]]; then

        while IFS= read -r line; do

            case "$line" in
                *"Battery Percentage:"*)
                    battery=$(grep -o '[0-9]\+' <<< "$line" | tail -n1)
                    battery=$((10#$battery))
                    break
                    ;;
            esac

        done < <(bluetoothctl info "$DEVICE")

    fi

    if [[ -n "$battery" ]]; then

        if ((battery >= 80)); then
            color="#9ece6a"

        elif ((battery >= 50)); then
            color="#e0af68"

        elif ((battery >= 25)); then
            color="#ff9e64"

        else
            color="#f7768e"
        fi

        get_battery_icon "$battery"
        idx=$?

        text=$(printf "<span foreground='#7aa2f7'><span font='Cascadia Mono PL 18' rise='-3000'>%s</span></span> <span foreground='%s'><span font='Cascadia Mono PL 18' rise='-3000'>%s</span> %3d%%</span>" \
            "$ICON_BT" \
            "$color" \
            "${battery_icons[$idx]}" \
            "$battery")

    else

        text=$(printf "<span foreground='#7a7a7a'><span font='Cascadia Mono PL 18' rise='-3000'>%s</span></span>" \
            "$ICON_OFF")
    fi

    printf '{"text":"%s"}\n' "$text"

    sleep 30

done
