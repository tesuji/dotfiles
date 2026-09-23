#!/bin/sh
################################################
# This script is used to get battery information
# Use at your own risk!
################################################

# Ref:
#    https://askubuntu.com/q/69556/565006
get_battery_info() {
  #org_battery=$(upower --enumerate | grep -F "battery")
  org_battery=/org/freedesktop/UPower/devices/battery_BAT0
  upower --show-info "$org_battery"
}

get_battery_info
