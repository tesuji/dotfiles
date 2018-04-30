#!/usr/bin/env bash
## Clean up personal username in desktop file and
## xfce config file

sed -E "s/(\/home\/)[a-z_][a-z0-9_]{0,30}/\1user/"
