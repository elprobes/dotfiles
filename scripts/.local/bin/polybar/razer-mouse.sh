#!/usr/bin/env bash

set -euo pipefail

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/razer-device"

get_device() {

    if [[ -f "$CACHE" ]]; then
        cat "$CACHE"
        return
    fi

    local device

    device="$(
        busctl --user tree org.razer |
            awk '/\/org\/razer\/device\// {print $NF}'
    )"

    [[ -n "$device" ]] || exit 1

    mkdir -p "$(dirname "$CACHE")"

    printf '%s\n' "$device" >"$CACHE"

    echo "$device"
}

get_dpi() {

    busctl --user call \
        org.razer \
        "$DEVICE" \
        razer.device.dpi \
        getDPI |
        awk '{print $4}'
}

get_poll() {

    busctl --user call \
        org.razer \
        "$DEVICE" \
        razer.device.misc \
        getPollRate |
        awk '{print $2}'
}

print_status() {

    local dpi poll icon

    dpi="$(get_dpi)"
    poll="$(get_poll)"

    case "$dpi" in
    400)
        icon="%{T3}󱗼%{T-}"
        ;;
    600)
        icon="%{T3}%{T-}"
        ;;
    800)
        icon="%{T3}%{T-}"
        ;;

    1200)
        icon="%{T3}󰑮%{T-}"
        ;;
    *)
        icon="%{T3}󰍿%{T-}"
        ;;
    esac

    echo "${icon} ${dpi} ${poll}Hz"
}

DEVICE="$(get_device)"

print_status
