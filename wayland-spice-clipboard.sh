#!/bin/bash
# Clipboard bridge with MIME-type filtering

IGNORED_MIMES=(
    "x-special/gnome-copied-files"
    "application/x-kde-cutselection"
    "text/uri-list"
    "application/x-qabstractitemmodeldatalist"
)

should_sync() {
    local mime
    mime=$(wl-paste --list-types 2>/dev/null)
    for ignored in "${IGNORED_MIMES[@]}"; do
        if echo "$mime" | grep -q "$ignored"; then
            return 1
        fi
    done
    return 0
}

LAST=""
while true; do
    PRIMARY=$(wl-paste --primary 2>/dev/null || echo "")
    if [ -n "$PRIMARY" ] && [ "$PRIMARY" != "$LAST" ]; then
        if should_sync; then
            echo "$PRIMARY" | xclip -selection clipboard -in 2>/dev/null
            LAST="$PRIMARY"
        fi
    fi
    sleep 0.5
done
