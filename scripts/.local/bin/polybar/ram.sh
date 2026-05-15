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
    printf "RAM %%{T2}%s%%{T-} %3d%%\n" "${blocks[$idx]}" "$usage"
    
    sleep 2
done
