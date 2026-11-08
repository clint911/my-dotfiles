 #!/usr/bin/env bash
# ~/.config/waybar/scripts/media.sh
# Scrolling "marquee" for the waybar media module.
# Long titles slide to the left and wrap around in an endless loop, like a ticker.
# Short titles stay still. When nothing is playing the module hides itself.
#
# Needs: playerctl     (sudo pacman -S playerctl)

export LC_ALL=C.UTF-8     # so ${text:pos:len} counts characters, not bytes

WIDTH=28                  # how many characters are visible at once
SPEED=0.25                # seconds per step (smaller = faster scroll)
SEP="   ◆   "             # shown between the end and the start when it wraps

ICON_PAUSE=$'\uf04b'       # nerd-font play icon
ICON_PLAY=$'\uf04c'      # nerd-font pause icon

last=""                   # last title we saw (to restart scrolling on a new song)
pos=0
tick=0
status=""
title=""

# escape " and \ so the text is valid inside JSON
json_escape() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    printf '%s' "$s"
}

while true; do
    # ask playerctl only every 4th tick (cheaper than every frame)
    if (( tick % 4 == 0 )); then
        status=$(playerctl status 2>/dev/null)
        if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
            title=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null)
        else
            title=""
        fi
    fi
    (( tick++ ))

    # nothing playing -> empty text makes waybar hide the module
    if [ -z "$title" ]; then
        echo '{"text":"","class":"stopped"}'
        sleep 1
        continue
    fi

    # new song -> start from the beginning
    if [ "$title" != "$last" ]; then
        last="$title"
        pos=0
    fi

    if [ "$status" = "Playing" ]; then
        icon="$ICON_PLAY";  class="playing"
    else
        icon="$ICON_PAUSE"; class="paused"
    fi

    if (( ${#title} <= WIDTH )); then
        # fits: no scrolling needed
        view="$title"
    else
        loop="${title}${SEP}"
        doubled="${loop}${loop}"
        view="${doubled:pos:WIDTH}"
        # only advance while playing (freezes when paused)
        if [ "$status" = "Playing" ]; then
            pos=$(( (pos + 1) % ${#loop} ))
        fi
    fi

    printf '{"text":"%s  %s","class":"%s","tooltip":"%s"}\n' \
        "$icon" "$(json_escape "$view")" "$class" "$(json_escape "$title")"

    sleep "$SPEED"
done
