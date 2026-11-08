#!/usr/bin/env bash
# ~/.config/waybar/scripts/calendar.sh
# Themed month calendar popup for waybar clock.
# Colors: glow #9D4EDD, lavender #D6ACFF, rose #FFB7C5, cyan #48CAE4, dark #0F051D

# ANSI RGB helpers
GLOW='\e[38;2;157;78;221m'     # #9D4EDD
LAV='\e[38;2;214;172;255m'     # #D6ACFF
ROSE='\e[38;2;255;183;197m'    # #FFB7C5
CYAN='\e[38;2;72;202;228m'     # #48CAE4
RESET='\e[0m'
BOLD='\e[1m'

cm=$(date +%-m)   # month being shown
cy=$(date +%Y)    # year being shown

month_name() {
    case "$1" in
        1) echo "January";; 2) echo "February";; 3) echo "March";; 4) echo "April";;
        5) echo "May";; 6) echo "June";; 7) echo "July";; 8) echo "August";;
        9) echo "September";; 10) echo "October";; 11) echo "November";; 12) echo "December";;
    esac
}

draw() {
    clear
    printf '\n'
    # Themed header: Month Year
    mname=$(month_name "$cm")
    printf '   %s%s%s %s%s%d%s\n' "$BOLD" "$GLOW" "$mname" "$RESET" "$CYAN" "$cy" "$RESET"
    printf '\n'

    # Weekday header in lavender
    printf '   %s%sMo Tu We Th Fr Sa Su%s\n' "$LAV" "$BOLD" "$RESET"

    # The calendar grid (Monday first, week numbers)
    cal --color=always -m -w "$cm" "$cy" | sed 's/^/   /'

    printf '\n'
    # Controls hint in rose
    printf '   %s%s← p prev   n next →   t today   q close%s\n' "$ROSE" "$BOLD" "$RESET"
    printf '\n'
}

draw
while true; do
    IFS= read -rsn1 key
    # arrow keys arrive as escape sequences (ESC [ C / ESC [ D)
    if [[ "$key" == $'\e' ]]; then
        IFS= read -rsn2 -t 0.05 rest
        if [ -z "$rest" ]; then exit 0; fi      # a lone Esc closes the popup
        key+="$rest"
    fi
    case "$key" in
        n|l|$'\e[C')
            cm=$((cm + 1)); if (( cm > 12 )); then cm=1; cy=$((cy + 1)); fi ;;
        p|h|$'\e[D')
            cm=$((cm - 1)); if (( cm < 1 )); then cm=12; cy=$((cy - 1)); fi ;;
        t)
            cm=$(date +%-m); cy=$(date +%Y) ;;
        q)
            exit 0 ;;
    esac
    draw
done
