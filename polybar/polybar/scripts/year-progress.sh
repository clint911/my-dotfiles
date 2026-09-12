#!/bin/bash

# Force decimal conversion (10#) to avoid bash octal errors in months like August/September (08/09)
day_of_year=$((10#$(date +%j)))
year_days=$((10#$(date -d "Dec 31" +%j)))
percent=$(( day_of_year * 100 / year_days ))

# Bar configuration (10 segments total)
total_blocks=10
filled_blocks=$(( percent * total_blocks / 100 ))
empty_blocks=$(( total_blocks - filled_blocks ))

# Build the progress bar string
bar=""
for ((i=0; i<filled_blocks; i++)); do
    bar="${bar}■"
done

empty_bar=""
for ((i=0; i<empty_blocks; i++)); do
    empty_bar="${empty_bar}░"
done

# Colors:
# XP Green:  #38B000
# Unfilled:  #103A7F
# Text/Wall: #FFFFFF

echo "%{F#38B000}${bar}%{F#103A7F}${empty_bar}%{F-} %{F#FFFFFF}${percent}%%{F-}"
