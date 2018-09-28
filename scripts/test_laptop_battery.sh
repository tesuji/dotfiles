#!/bin/sh
################################################
# This script is used to get battery information
# Use at your own risk!
################################################

# Ref:
#    https://askubuntu.com/q/69556/565006
get_battery_info() {
  # fgrep and cut is still faster than sed
  m_org_battery=$(upower --enumerate | grep -F "battery")
  upower --show-info "$m_org_battery"
}

get_battery_info
