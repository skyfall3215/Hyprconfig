#!/bin/bash

START_HYPRIDLE_CMD="hypridle &"

while true; do
    status=$(playerctl status 2>/dev/null)

    if [[ "$status" == "Playing" ]]; then
        if pgrep -x hypridle > /dev/null; then
            pkill -x hypridle
        fi
    else
        if ! pgrep -x hypridle > /dev/null; then
            eval "$START_HYPRIDLE_CMD"
        fi
    fi

    sleep 5
done
