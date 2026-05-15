#!/bin/bash


WALLDIR="/usr/share/backgrounds/"

while true; do
    feh --bg-fill "$(find "$WALLDIR" -type f | shuf -n 1)"
    sleep 300
done
