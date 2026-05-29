#!/bin/bash

DEV="${1:-nvme0n1}"
STAT="/sys/block/$DEV/stat"

[ ! -r "$STAT" ] && exit 1

blocks=("⡀" "⡄" "⡆" "⡇" "⣇" "⣧" "⣷" "⣿")

read_stat() {
    read -r \
        _ _ sectors_read _ \
        _ _ sectors_written _ \
        _ < "$STAT"

    REPLY="$sectors_read $sectors_written"
}

human() {
    local kb=$1
    local whole
    local decimal

    whole=$((kb / 1024))
    decimal=$(((kb % 1024) * 10 / 1024))

    printf "%5d.%1dM" "$whole" "$decimal"
}

get_idx() {
    local kb=$1

    if ((kb < 64)); then
        return 0
    elif ((kb < 256)); then
        return 1
    elif ((kb < 1024)); then
        return 2
    elif ((kb < 4096)); then
        return 3
    elif ((kb < 16384)); then
        return 4
    elif ((kb < 65536)); then
        return 5
    elif ((kb < 262144)); then
        return 6
    else
        return 7
    fi
}

read_stat
read -r prev_read prev_write <<< "$REPLY"

while true; do
    sleep 1

    read_stat
    read -r curr_read curr_write <<< "$REPLY"

    delta_read=$((curr_read - prev_read))
    delta_write=$((curr_write - prev_write))

    # sectors (512B) -> KB
    read_kb=$((delta_read / 2))
    write_kb=$((delta_write / 2))

    prev_read=$curr_read
    prev_write=$curr_write

    get_idx "$read_kb"
    read_idx=$?

    get_idx "$write_kb"
    write_idx=$?

    read_human=$(human "$read_kb")
    write_human=$(human "$write_kb")

    printf "%s %%{T2}󰁝%%{T-}%%{T3}󰋊%%{T-}%%{T2}%s%%{T-} %s %%{T2}󰁅%%{T-}%%{T3}󰋊%%{T-}%%{T2}%s%%{T-}\n" \
        "$read_human" \
        "${blocks[$read_idx]}" \
        "$write_human" \
        "${blocks[$write_idx]}"
done
