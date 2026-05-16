#!/usr/bin/env bash

DEVICE="18:9C:2C:AD:3B:26"
DEVICE_NAME="Cuffie BT Sound Core"

coproc BTCTL { bluetoothctl; }

echo "scan on" >&"${BTCTL[1]}"

while read -r line <&"${BTCTL[0]}"; do

    printf '%q\n' "$line"

    # Connected
    if [[ "$line" == *"$DEVICE"* && "$line" == *"Connected: yes"* ]]; then

        notify-send -u low \
            "󰋋 Bluetooth" \
            "$DEVICE_NAME connected"
    fi

    # Disconnected
    if [[ "$line" == *"$DEVICE"* && "$line" == *"Connected: no"* ]]; then

        notify-send -u low \
            "󰋋 Bluetooth" \
            "$DEVICE_NAME disconnected"

        bluetoothctl connect "$DEVICE" >/dev/null 2>&1
    fi

done
