#!/usr/bin/env bash
#######################################################
## This script is used to enabling / disabling Touchpad
## Use at your own risk!
#######################################################

## Ref:
##    https://askubuntu.com/questions/844151/enable-disable-touchpad/844218
##    https://askubuntu.com/a/537031/565006
##    https://wiki.archlinux.org/index.php/Libinput#Disable_touchpad
toggle_touchpad() {
  local icon_enable=input-touchpad-symbolic
  local icon_disable=touchpad-disabled-symbolic

  local info_enable="Touchpad has been enabled"
  local info_disable="Touchpad has been disabled"

  ## fgrep and cut is still faster than sed
  local ID=$( xinput | fgrep TouchPad | cut -f2 | cut -d= -f2 )
  local STATE=$( xinput list-props "$ID" | grep "Device Enabled" | grep -o "[01]$" )

  if [[ "$STATE" -eq '1' ]]; then
    ## Should install Notification servers
    ## https://wiki.archlinux.org/index.php/Desktop_notifications#Notification_servers
    xinput --disable "$ID" && \
        notify-send "Disabled" "$info_disable" --icon="$icon_disable"
  else
    xinput --enable "$ID" && \
        notify-send "Enabled " "$info_enable" --icon="$icon_enable"
  fi
}

toggle_touchpad
