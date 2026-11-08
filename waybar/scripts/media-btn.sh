#!/usr/bin/env bash
# ~/.config/waybar/scripts/media-btn.sh <icon>
# Used by the prev/next buttons. Prints the icon and the player state
# ("playing" / "paused") as a CSS class, so the buttons can turn grey together
# with the title when the music is paused.
status=$(playerctl status 2>/dev/null | tr 'A-Z' 'a-z')
printf '{"text":"%s","class":"%s"}\n' "$1" "${status:-stopped}"
