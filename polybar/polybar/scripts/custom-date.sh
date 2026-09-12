#!/usr/bin/env bash

# 1. Fetch exact time and date elements
TIME=$(date +"%H:%M:%S")
DAY_NAME=$(date +"%A")
MONTH_NAME=$(date +"%B")
YEAR=$(date +"%Y")
WEEK_NUM=$(date +"%V")
DAY_OF_YEAR=$(date +"%-j")

# 2. Determine the correct suffix for the day (st, nd, rd, th)
DAY=$(date +"%-d")
case $DAY in
    1|21|31) SUFFIX="st" ;;
    2|22)    SUFFIX="nd" ;;
    3|23)    SUFFIX="rd" ;;
    *)       SUFFIX="th" ;;
esac

# 3. Calculate year progress percentage
DAYS_IN_YEAR=$(date -d "${YEAR}-12-31" +"%j")
PROGRESS=$(( DAY_OF_YEAR * 100 / DAYS_IN_YEAR ))

# 4. Build a 10-character progress bar using our theme colors
FILLED_CHARS=$(( PROGRESS / 10 ))
EMPTY_CHARS=$(( 10 - FILLED_CHARS ))

# Primary color for filled (#CCFF00), Disabled color for empty (#555555)
BAR="%{F#CCFF00}"
for ((i=0; i<FILLED_CHARS; i++)); do BAR+="█"; done
BAR+="%{F#555555}"
for ((i=0; i<EMPTY_CHARS; i++)); do BAR+="█"; done
BAR+="%{F-}" # Reset to normal text color

# 5. Output the final exact format
echo "$TIME, $DAY_NAME, ${DAY}${SUFFIX} Of ${MONTH_NAME} ${YEAR}, Wk $WEEK_NUM, Day $DAY_OF_YEAR [$BAR]"
