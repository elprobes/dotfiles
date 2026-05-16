#!/usr/bin/env bash

DEVICE="18:9C:2C:AD:3B:26"

while true; do

    info=$(bluetoothctl info "$DEVICE" 2>/dev/null)

    if grep -q "Connected: yes" <<< "$info"; then

        battery=$(awk -F'[()]' \
            '/Battery Percentage/ {
                gsub("%","",$2)
                print $2
            }' <<< "$info")

        battery=${battery:-"?"}

        if [ "$battery" != "?" ]; then

            if (( battery >= 90 )); then
                icon="󰁹"
            elif (( battery >= 70 )); then
                icon="󰂁"
            elif (( battery >= 50 )); then
                icon="󰁿"
            elif (( battery >= 30 )); then
                icon="󰁼"
            else
                icon="󰁺"
            fi

            printf "%%{F#7aa2f7}%%{T4}󰂯%%{T-}%%{T4} 󰋋 %%{T-}%%{F-}%%{F#9ece6a}%%{T3}%s%%{T-}%%{F-} %s%%\n" \
                "$icon" \
                "$battery"

        else

            printf "%%{F#666666}󰋋 ?%%%%{F-}\n"

        fi

    else

        printf "%%{F#7aa2f7}%%{T4}󰂲%%{T-}%%{F-}\n"

    fi

    sleep 30

done
