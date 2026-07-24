#!/bin/bash
# Calculate percentage of year passed
day_of_year=$(date +%j)
year_days=$(( $(date -d "Dec 31" +%j) ))
percent=$(( day_of_year * 100 / year_days ))

# Create a "capsule" style string
echo "%{F#ffb52a}%{B#ffb52a F#000000} $percent% %{B#00000000 F#ffb52a}"
