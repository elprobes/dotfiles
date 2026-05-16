#!/usr/bin/env bash

DEVICE="18:9C:2C:AD:3B:26"

while true; do

    info=$(bluetoothctl info "$DEVICE" 2>/dev/null)

    connected=$(echo "$info" | grep "Connected: yes")
   
    if [ -n "$connected" ]; then

    battery=$(echo "$info" | awk -F'[()]' '/Battery Percentage/ {gsub("%","",$2); print $2}')
        # Fallback se battery non disponibile
        [ -z "$battery" ] && battery="?"

        # Icone dinamiche
        if [ "$battery" != "?" ]; then

            if (( battery >= 90 )); then
                icon="󰥉"
            elif (( battery >= 70 )); then
                icon="󰥈"
            elif (( battery >= 50 )); then
                icon="󰥇"
            elif (( battery >= 30 )); then
                icon="󰥆"
            else
                icon="󰥅"
            fi

        printf "%%{F#9ece6a}%%{T4}%s%%{T-}%%{F-} %s%%\n" \
            "$icon" \
                "$battery"

        else

            printf "󰋋 ?%%\n"

        fi

    else

        printf "%%{F#666666}󰋐 disconnected%%{F-}\n"

    fi

    sleep 30

done
