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
  m_icon_enable=input-touchpad-symbolic
  m_icon_disable=touchpad-disabled-symbolic

  m_info_enable="Touchpad has been enabled"
  m_info_disable="Touchpad has been disabled"

  ## fgrep and cut is still faster than sed
  mID="$( xinput | grep -F 'TouchPad' | cut -f2 | cut -d= -f2 )"
  mSTATE="$( xinput list-props "$mID" | grep "Device Enabled" | grep -o "[01]$" )"

  if [[ "$mSTATE" -eq '1' ]]; then
    ## Should install Notification servers
    ## https://wiki.archlinux.org/index.php/Desktop_notifications#Notification_servers
    xinput --disable "$mID" \
        && notify-send "Disabled" "$m_info_disable" --icon="$m_icon_disable"
  else
    xinput --enable "$mID" \
        && notify-send "Enabled " "$m_info_enable" --icon="$m_icon_enable"
  fi
}

toggle_touchpad
