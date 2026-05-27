#!/bin/bash

HOSTS_FILE="$HOME/.config/rdp-launcher/hosts.json"

CHOICE=$(
    jq -r '
    .[] |
    "󰒋  \(.name) | \(.host):\(.port)"
    ' "$HOSTS_FILE" |
    rofi -dmenu -i -p "RDP"
)

[ -z "$CHOICE" ] && exit

NAME=$(echo "$CHOICE" | sed 's/^󰒋  //' | cut -d'|' -f1 | sed 's/[[:space:]]*$//')

HOST_DATA=$(
    jq -r --arg name "$NAME" '
    .[] | select(.name == $name)
    ' "$HOSTS_FILE"
)

ID=$(echo "$HOST_DATA" | jq -r '.id')
HOST=$(echo "$HOST_DATA" | jq -r '.host')
PORT=$(echo "$HOST_DATA" | jq -r '.port')
USER=$(echo "$HOST_DATA" | jq -r '.user')

PASS=$(secret-tool lookup rdp "$ID")

xfreerdp3 \
    /v:$HOST:$PORT \
    /u:$USER \
    /p:$PASS \
    /dynamic-resolution \
    /cert:ignore
