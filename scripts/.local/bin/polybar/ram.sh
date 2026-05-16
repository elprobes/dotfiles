#!/bin/bash

blocks=("⡀" "⡄" "⡆" "⡇" "⣇" "⣧" "⣷" "⣿")

while true; do
    read used total <<< $(free | awk '/Mem:/ {print $3, $2}')

    usage=$((used * 100 / total))

    idx=$((usage / 13))

    if [ "$idx" -gt 7 ]; then
        idx=7
    fi

    #echo "RAM ${blocks[$idx]} ${usage}%"
    printf "%3d%% %%{T4}󱤓%%{T-}%%{T2}%s%%{T-}\n" "$usage" "${blocks[$idx]}"
    
    sleep 2
done
