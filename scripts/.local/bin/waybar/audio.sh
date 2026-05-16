#!/usr/bin/env bash

ICON_SPEAKER="󰕾"
ICON_HEADPHONES="󰋋"
ICON_HDMI="󰍹"
ICON_MUTED="󰖁"

COLOR_NORMAL="#ff7f50"
COLOR_MUTED="#f7768e"
COLOR_BT="#9ece6a"
COLOR_HDMI="#ff7f50"

truncate() {
    local text="$1"
    local max=14

    if ((${#text} > max)); then
        printf "%s…" "${text:0:max-1}"
    else
        printf "%s" "$text"
    fi
}

update_sink() {
    local line

    while IFS= read -r line; do

        [[ $line != *"*"* ]] && continue

        line=${line#*│}
        line=${line#*├─}
        line=${line#*\*}
        line=${line## }

        line=$(printf "%s" "$line" | sed 's/^[[:space:]]*[0-9]\+\.\s*//')

        line=${line%% \[vol:*}

        sink="$line"
        break

    done < <(wpctl status)

    icon="$ICON_SPEAKER"
    color="$COLOR_NORMAL"

    if [[ "$sink" =~ bluez|Bluetooth ]]; then
        icon="$ICON_HEADPHONES"
        color="$COLOR_BT"

    elif [[ "$sink" =~ HDMI ]]; then
        icon="$ICON_HDMI"
        color="$COLOR_HDMI"
    fi

    sink=$(truncate "$sink")
}

parse_volume() {
    local raw="$1"
    local int
    local dec

    raw=${raw#Volume: }

    int=${raw%%.*}
    dec=${raw#*.}

    dec=${dec:0:2}

    while ((${#dec} < 2)); do
        dec="${dec}0"
    done

    REPLY=$((10#$int * 100 + 10#$dec))
}

sink=""
icon="$ICON_SPEAKER"
color="$COLOR_NORMAL"

counter=0

update_sink

while true; do

    ((counter++))

    if ((counter >= 10)); then
        update_sink
        counter=0
    fi

    read -r _ raw_volume muted <<< "$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

    parse_volume "$raw_volume"
    volume=$REPLY

    if [[ "$muted" == "[MUTED]" ]]; then

        text=$(printf "<span foreground='%s'><span font='Cascadia Mono PL 20' rise='-3000'>%s</span> muted</span>" \
            "$COLOR_MUTED" \
            "$ICON_MUTED")

    else

        text=$(printf "<span foreground='#ff7f50'><span font='Cascadia Mono PL 20' rise='-5000'>%s</span></span> <span foreground='#7aa2f7' rise='-1500'>%3d%%</span> <span foreground='#c0caf5' font='UbuntuMono Nerd Font Mono 10'>%s</span>" \
            "$icon" \
            "$volume" \
            "$sink")

    fi

    printf '{"text":"%s"}\n' "$text"

    sleep 1

done
