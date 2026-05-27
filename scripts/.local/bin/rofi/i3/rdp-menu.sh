#!/bin/bash

# Dopo aver inserito nuovo host nel file hosts.json lanciare il seguente comando
# sostituendo <nome_campo> con valore corrispondente.
#
# Richiede pacchetti:
#   - gnome-keyring
#   - libsecret
#
# secret-tool store --label="RDP <label>" rdp <nome_keyring_password>
#
# e inserire la password di accesso per l utente remoto

HOSTS_FILE="$HOME/.config/rdp-launcher/hosts.json"

CHOICE=$(
    jq -r '
    .[] |
    "󰒋  \(.name) | \(.host):\(.port)"
    ' "$HOSTS_FILE" |
        rofi -dmenu -i -p "RDP (Alt+e edit hosts)" -kb-custom-1 "Alt+e"
)

RETVAL=$?

if [ "$RETVAL" -eq 10 ]; then
    kitty -e nvim "$HOSTS_FILE"
    exit
fi

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
