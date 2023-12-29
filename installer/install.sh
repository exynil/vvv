#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
pad=$(printf '%0.1s' "."{1..60})

missing_packages=()

mapfile -t packages < <(awk '$1 !~ /(#|^$)/ {print $1}' packages.txt)

for i in "${packages[@]}"; do
    if yay -Qi "$i" &>/dev/null; then
        printf "%b%s" "$GREEN" "$i"
        printf '%b%*.*s' "$NC" 0 $((50 - ${#i})) "$pad"
        printf "%b[  %bOK%b  ]\n" "$NC" "$GREEN" "$NC"
    else
        missing_packages+=("$i")
    fi
done

if [[ "${#missing_packages[@]}" -gt 0 ]]; then
    yay -S --noconfirm --removemake ${missing_packages[*]}

    for i in "${missing_packages[@]}"; do
        if yay -Qi "$i" &>/dev/null; then
            printf "%b%s" "$GREEN" "$i"
            printf '%b%*.*s' "$NC" 0 $((50 - ${#i})) "$pad"
            printf "%b[  %bOK%b  ]\n" "$NC" "$GREEN" "$NC"
        else
            printf "%b%s" "$RED" "$i"
            printf '%b%*.*s' "$NC" 0 $((50 - ${#i})) "$pad"
            printf "%b[%bFAILED%b]\n" "$NC" "$RED" "$NC"
        fi
    done
fi
