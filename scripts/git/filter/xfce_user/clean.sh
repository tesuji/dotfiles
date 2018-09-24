#!/bin/sh
# Replace username path in desktop file and xfce config file
# From /home/my_user_name to /home/user
sed -E 's@(/home/)[a-z_][a-z0-9_]{0,30}@\1user@'
