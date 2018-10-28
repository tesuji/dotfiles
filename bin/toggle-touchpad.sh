#!/bin/sh
# -----------------------------------------------------------------------------
# This script is used to enabling / disabling Touchpad
# Use at your own risk!
# -----------------------------------------------------------------------------

# Ref:
#    https://stackoverflow.com/a/18756948/5456794
#    https://askubuntu.com/questions/844151/enable-disable-touchpad/844218
#    https://askubuntu.com/a/537031/565006
#    https://wiki.archlinux.org/index.php/Libinput#Disable_touchpad
toggle_touchpad() {
  m_icon_enable=input-touchpad-symbolic
  m_icon_disable=touchpad-disabled-symbolic
  m_info_enable="Touchpad has been enabled"
  m_info_disable="Touchpad has been disabled"

  mID="$( xinput --list | sed -E -n '/TouchPad/{s/^.*id=([0-9]+).*/\1/p}' )"
  mSTATE="$( xinput list-props "$mID" | sed -E -n 's/^\tDevice Enabled \([0-9]+\):\t([01])/\1/p' )"

  if [ "$mSTATE" -eq 1 ]; then
    # Should install Notification servers
    # https://wiki.archlinux.org/index.php/Desktop_notifications#Notification_servers
    xinput --disable "$mID" \
    && notify-send "Disabled" "$m_info_disable" --icon="$m_icon_disable"
  else
    xinput --enable "$mID" \
    && notify-send "Enabled " "$m_info_enable" --icon="$m_icon_enable"
  fi
}

toggle_touchpad
