#!/bin/bash

doubleDigit=$(pmset -g batt | grep [0-9][0-9]% | awk 'NR==1{print $3}' | cut -f1 -d"%")
isCharging=$(pmset -g batt | awk 'NR==1{print $4}' | cut -c 2-3)

# Change charging icon based on AC or Battery power
if [ $isCharging = "AC" ]; then
	ICON="ϟ"
	# ICON="⌁"
else
	ICON=""
fi

# Change color of battery based on percentage charged
if (( $"doubleDigit" <= "15" )); then
 	COLOR="#[fg=colour196]"
else
 	COLOR="#[default]"
fi

echo "$COLOR Battery: $ICON$doubleDigit%"
