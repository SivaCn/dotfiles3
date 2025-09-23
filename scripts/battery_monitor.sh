#!/bin/bash

#
# apt install espeak -y
#
# chmod +x scripts/battery_monitor.sh
#
# crontab -e
# */5 * * * * ~/scripts/battery_monitor.sh
#

# Specify the display and user
DISPLAY=:0
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus

export DISPLAY DBUS_SESSION_BUS_ADDRESS

# Battery monitoring script with desktop notifications
# Save as battery_monitor.sh, make executable with: chmod +x battery_monitor.sh
# Run with: ./battery_monitor.sh

# Configuration
LOW_BATTERY_THRESHOLD=20      # Percentage at which low battery warning is shown
FULL_BATTERY_THRESHOLD=95     # Percentage at which full battery notification is shown

# Function to send notification
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="$3"

    notify-send -u "$urgency" -i "battery" "$title" "$message"
}

# Get battery information
battery_info=$(acpi -b)
battery_status=$(echo "$battery_info" | awk '{print $3}' | tr -d ',')
battery_percent=$(echo "$battery_info" | grep -Po '\d+%' | tr -d '%')

# Check if on battery power
if echo "$battery_info" | grep -q "Discharging"; then
    # Battery is discharging
    if [ "$battery_percent" -le "$LOW_BATTERY_THRESHOLD" ]; then
        espeak "Low Battery"
        send_notification "Low Battery Warning" "Battery is at ${battery_percent}%! Connect the charger." "critical"
    fi
else
    # Battery is charging or full
    if [ "$battery_percent" -ge "$FULL_BATTERY_THRESHOLD" ] && [ "$battery_status" == "Charging" ]; then
        send_notification "Battery Charged" "Battery is at ${battery_percent}%. You may want to unplug the charger." "normal"
    fi
fi

