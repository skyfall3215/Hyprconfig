#!/bin/bash

while true; do
    status=$(playerctl status 2>/dev/null)
    if [[ "$status" == "Playing" ]]; then
        pkill -STOP hypridle
    else
        pkill -CONT hypridle
    fi
    sleep 5
done

