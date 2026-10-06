 #!/bin/sh

# Width of the scrolling window (number of visible characters)
WIDTH=20

while true; do
    status=$(playerctl status 2>/dev/null)

    if [ -z "$status" ]; then
        echo "󰎈"
        sleep 2
        continue
    fi

    # Set Play/Pause icon based on playback state
    if [ "$status" = "Playing" ]; then
        play_icon="󰏤"
    else
        play_icon="󰐊"
    fi

    # Formatting click action buttons
    prev_btn="%{A1:playerctl previous:}󰒮%{A}"
    play_btn="%{A1:playerctl play-pause:}${play_icon}%{A}"
    next_btn="%{A1:playerctl next:}󰒭%{A}"
    controls="${prev_btn}  ${play_btn}  ${next_btn}"

    # Get artist and title
    track=$(playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null)

    # If track length fits inside WIDTH, don't scroll
    len=${#track}
    if [ "$len" -le "$WIDTH" ]; then
        output="${track}  |  ${controls}"
        echo "%{A4:pamixer -i 5:}%{A5:pamixer -d 5:}${output}%{A}%{A}"
        sleep 1
        continue
    fi

    # If paused, keep track static without scrolling
    if [ "$status" != "Playing" ]; then
        display_text=$(echo "$track" | cut -c 1-"$WIDTH")
        output="${display_text}...  |  ${controls}"
        echo "%{A4:pamixer -i 5:}%{A5:pamixer -d 5:}${output}%{A}%{A}"
        sleep 1
        continue
    fi

    # Ticker Loop for playing tracks: cycle characters smoothly
    padded_track="${track}   ---   "
    pad_len=${#padded_track}

    for i in $(seq 0 $((pad_len - 1))); do
        # Re-check status inside ticker loop so controls stay responsive
        current_status=$(playerctl status 2>/dev/null)
        if [ "$current_status" != "Playing" ]; then
            break
        fi

        # Extract ticker window substring
        double_str="${padded_track}${padded_track}"
        display_text=$(echo "$double_str" | cut -c $((i + 1))-$((i + WIDTH)))

        output="${display_text}    ${controls}"
        echo "%{A4:pamixer -i 5:}%{A5:pamixer -d 5:}${output}%{A}%{A}"

        # Controls scroll speed (0.3 seconds per shift)
        sleep 0.3
    done
done
