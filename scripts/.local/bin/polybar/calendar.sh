#!/bin/bash

if pgrep -f "kitty --class floating-calendar -e calcurse" >/dev/null; then
    pkill -f "kitty --class floating-calendar -e calcurse"
else
    kitty --class floating-calendar -e calcurse &
fi
