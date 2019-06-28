#!/bin/sh
# Stop PC FROM randomly waking up immediately after suspend.
#
# # Usage
#
# Copy this file to `/root/scripts/`
# Run `sudo crontab -e` and add this line
#     @reboot sh /root/scripts/stop-wakeup.sh
#
# # Reference
#
# * https://www.simplified.guide/linux/automatically-run-program-on-startup
# * https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#Instantaneous_wakeups_from_suspend
#
# # Alternative
#
# Use systemd to hook suspend events https://wiki.archlinux.org/index.php/Power_management#Suspend.2Fresume_service_files

# NOTE: Each time only passes a device to /proc/acpi/wakeup, not all devices.
awk '(NR!=1 && $1!~/^(LID|PB|PW)/ && $3=="*enabled"){print $1}' /proc/acpi/wakeup | \
while IFS='' read -r dev; do
  echo "$dev" | tee /proc/acpi/wakeup
done > /dev/null
