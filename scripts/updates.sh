#!/usr/bin/env bash

CACHE_FILE="/tmp/update_count.txt"
CACHE_EXPIRATION=300

while true; do
    if [ ! -f "$CACHE_FILE" ] || [ $(( $(date +%s) - $(date +%s -r "$CACHE_FILE") )) -gt $CACHE_EXPIRATION ]; then
        updates_arch=$(checkupdates 2>/dev/null | wc -l)
        updates_aur=$(paru -Qum 2>/dev/null | wc -l)
        updates=$((updates_arch + updates_aur))

        if [ "$updates" -gt 0 ]; then
            echo $updates > "$CACHE_FILE"
        else
            echo "None" > "$CACHE_FILE"
        fi
    fi

    sleep $CACHE_EXPIRATION
done
