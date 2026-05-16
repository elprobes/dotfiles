#!/bin/bash

while true; do

    text=$(date +"<span foreground='#c0caf5'>%d/%m/%Y</span> <span foreground='#bb9af7' font='Cascadia Mono PL 16' rise='-3000'>󰥔</span> <span foreground='#c0caf5'>%H:%M:%S</span>")

    printf '{"text":"%s"}\n' "$text"

    sleep 1

done
