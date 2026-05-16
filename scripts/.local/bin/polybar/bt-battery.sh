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

        printf "%%{F#7aa2f7}%s%%{F-} %%{F%s}%s %3d%% %%{F-}\n" \
            "$ICON_BT" \
            "$color" \
            "${battery_icons[$idx]}" \
            "$battery"

    else

        printf "%%{F#7a7a7a}%s%%{F-}\n" \
            "$ICON_OFF"

    fi

    sleep 30

done
