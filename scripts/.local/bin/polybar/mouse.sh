#!/usr/bin/env bash

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/mouse-profile"

print_status() {

    [[ -f "$CACHE" ]] || {
        echo "󰍽 ?"
        return
    }

    # shellcheck disable=SC1090
    source "$CACHE"

    case "$active_profile" in
    FPS)
        icon="%{T3}%{T-}"
        ;;
    Coding)
        icon="%{T3}%{T-}"
        ;;
    Precision)
        icon="%{T3}󱗼%{T-}"
        ;;
    Reading)
        icon="%{T3}%{T-}"
        ;;
    *)
        icon="%{T3}󰍿%{T-}"

        ;;
    esac

    case "$profile" in
    adaptive)
        profile_icon="%{T3}󰓅%{T-}"
        ;;
    flat)
        profile_icon="%{T3}󰾅%{T-}"
        ;;
    *)
        profile_icon="%{T3}?%{T-}"
        ;;
    esac

    case "$natural_scroll" in
    off)
        natural_icon="%{T3}%{T-}"
        ;;
    on)
        natural_icon="%{T3} 󰊪%{T-}"
        ;;
    *)
        natural_icon="%{T3}?%{T-}"
        ;;
    esac

    echo "${icon}${natural_icon} ${speed} ${profile_icon}"
}

print_status

while inotifywait -qq -e close_write "$CACHE" 2>/dev/null; do
    print_status
done
