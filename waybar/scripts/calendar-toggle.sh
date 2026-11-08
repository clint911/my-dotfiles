#!/usr/bin/env bash
# ~/.config/waybar/scripts/calendar-toggle.sh
# Click the clock: open the themed calendar popup. Click again: close it.
# The popup is a kitty window with app_id "calendar-popup"; sway floats and
# positions it through the for_window rule in the sway config.

if swaymsg -t get_tree | grep -q '"app_id": *"calendar-popup"'; then
    swaymsg '[app_id="calendar-popup"] kill' > /dev/null
else
    setsid -f kitty --class calendar-popup \
        -o confirm_os_window_close=0 \
        -o font_size=12 \
        -o opacity=0.92 \
        -o active_border_color='#9D4EDD' \
        -o inactive_border_color='#333333' \
        -o window_padding_x=14 \
        -o window_padding_y=10 \
        -e "$HOME/.config/waybar/scripts/calendar.sh"
fi
