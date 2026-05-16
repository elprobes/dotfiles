#!/bin/bash
#Glyph: 󰋊󰜮 󰈐󰕒 󰛳󰇚  󱧶󰋚

ROOT=$(findmnt -n -o SOURCE /)
DEV=$(lsblk -no PKNAME "$ROOT")

while true; do
    stats=$(iostat -d -k "$DEV" 1 2 | awk -v dev="$DEV" '$1==dev' | tail -n1)

    read_kb=$(echo "$stats" | awk '{print $3}')
    write_kb=$(echo "$stats" | awk '{print $4}')

    read_mb=$(awk "BEGIN {printf \"%.1f\", $read_kb/1024}")
    write_mb=$(awk "BEGIN {printf \"%.1f\", $write_kb/1024}")

    printf "%6s MB/s %%{T4}⬇󰋊%%{T-} %6s MB/s %%{T4}󰋊⬆%%{T-}\n" "$read_mb" "$write_mb"
done
