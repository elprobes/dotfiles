#!/usr/bin/env bash

set -euo pipefail

DEVICE="18:9C:2C:AD:3B:26"

DEVICE_NAME="Cuffie BT Sound Core"

CONNECTED=0

coproc BTCTL { bluetoothctl; }

while read -r line <&"${BTCTL[0]}"; do

    # -----------------------------------
    # Connected
    # -----------------------------------

    if [[ "$line" == *"$DEVICE"* && "$line" == *"Connected: yes"* ]]; then

        if [[ $CONNECTED -eq 0 ]]; then

            CONNECTED=1

            notify-send \
                -u low \
                -h string:x-canonical-private-synchronous:bluetooth \
                "󰋋 Bluetooth" \
                "$DEVICE_NAME connected"
        fi
    fi

    # -----------------------------------
    # Disconnected
    # -----------------------------------

    if [[ "$line" == *"$DEVICE"* && "$line" == *"Connected: no"* ]]; then

        if [[ $CONNECTED -eq 1 ]]; then

            CONNECTED=0

            notify-send \
                -u low \
                -h string:x-canonical-private-synchronous:bluetooth \
                "󰋋 Bluetooth" \
                "$DEVICE_NAME disconnected"

            sleep 2

            bluetoothctl connect "$DEVICE" >/dev/null 2>&1 || true
        fi
    fi

done
