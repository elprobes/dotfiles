#!/usr/bin/env bash

temp_raw=$(< /sys/class/thermal/thermal_zone3/temp)
temp=$((temp_raw / 1000))

if (( temp < 40 )); then
    icon=""
    color="#7aa2f7"   # blue
elif (( temp < 55 )); then
    icon=""
    color="#9ece6a"   # green
elif (( temp < 70 )); then
    icon=""
    color="#e0af68"   # yellow
elif (( temp < 85 )); then
    icon=""
    color="#ff9e64"   # orange
else
    icon=""
    color="#f7768e"   # red
fi

printf "%%{F%s}%s %2d°C%%{F-}\n" \
    "$color" \
    "$icon" \
    "$temp"
