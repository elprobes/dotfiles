#!/bin/bash

# Dopo aver inserito nuovo host nel file hosts.json lanciare il seguente comando
# sostituendo <nome_campo> con valore corrispondente.
#
# Richiede pacchetti:
#   - gnome-keyring
#   - libsecret
#   - libnotify
#   - netcat (nc)
#
# secret-tool store --label="RDP <label>" rdp <nome_keyring_password>
#
# e inserire la password di accesso per l'utente remoto

HOSTS_FILE="$HOME/.config/rdp-launcher/hosts.json"

CHOICE=$(
    jq -r '
    .[] |
    "󰒋  \(.name) | \(.host)\(if (.port // "") != "" then ":\(.port)" else "" end)"
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
PORT=$(echo "$HOST_DATA" | jq -r '.port // ""')
USER=$(echo "$HOST_DATA" | jq -r '.user')

#PASS=$(secret-tool lookup rdp "$ID")
PASS=$(
    secret-tool lookup rdp "$ID" |
        tr -d '\r\n'
)

RDP_PORT="${PORT:-3389}"

if [ -n "$PORT" ]; then
    TARGET="$HOST:$PORT"
else
    TARGET="$HOST"
fi

#
# Verifica raggiungibilità host
#
if ! nc -z -w3 "$HOST" "$RDP_PORT" >/dev/null 2>&1; then
    notify-send \
        -u normal \
        "Host non raggiungibile" \
        "$HOST:$RDP_PORT non risponde"

    exit 1
fi

#
# Avvia FreeRDP e cattura l'output
#

OUTPUT=$(
    xfreerdp3 \
        /v:"$TARGET" \
        /u:"$USER" \
        /p:"$PASS" \
        /size:1920x1020 \
        /clipboard \
        /cert:ignore \
        2>&1
)

        #/dynamic-resolution \
RET=$?

LOGFILE="/tmp/xfreerdp-${ID}.log"
echo "$OUTPUT" >"$LOGFILE"

if [ $RET -ne 0 ]; then

    ERROR_MSG="Errore sconosciuto (codice $RET)"

    case "$OUTPUT" in
    *ERRCONNECT_CONNECT_FAILED*)
        ERROR_MSG="Host ha rifiutato la connessione"
        ;;
    *"Connection timed out"*)
        ERROR_MSG="Timeout di connessione"
        ;;
    *LOGON_FAILURE*)
        ERROR_MSG="Username o password errati"
        ;;
    *Authentication\ failure*)
        ERROR_MSG="Autenticazione fallita"
        ;;
    *ERRCONNECT_PASSWORD_EXPIRED*)
        ERROR_MSG="Password scaduta"
        ;;
    *ERRCONNECT_ACCOUNT_LOCKED_OUT*)
        ERROR_MSG="Account bloccato"
        ;;
    *CERTIFICATE_VERIFY_FAILED*)
        ERROR_MSG="Problema con il certificato remoto"
        ;;
    *ERRCONNECT_SECURITY_NEGO_CONNECT_FAILED*)
        ERROR_MSG="Errore durante la negoziazione della sicurezza"
        ;;
    *ERRCONNECT_TLS_CONNECT_FAILED*)
        ERROR_MSG="Errore TLS"
        ;;
    *ERRCONNECT_DNS_NAME_NOT_FOUND*)
        ERROR_MSG="Host non trovato"
        ;;
    *)
        RAW_ERROR=$(
            echo "$OUTPUT" |
                grep -E "ERROR|Error|error|FAIL|Fail|fail" |
                tail -n1 |
                sed 's/^.* - //'
        )

        if [ -n "$RAW_ERROR" ]; then
            ERROR_MSG="$RAW_ERROR"
        else
            ERROR_MSG="Errore sconosciuto (codice $RET) - vedi $LOGFILE"
        fi
        ;;
    esac

    notify-send \
        -u critical \
        "Connessione RDP fallita" \
        "$ERROR_MSG"

    exit $RET
fi
