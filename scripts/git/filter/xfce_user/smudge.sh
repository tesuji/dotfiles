#!/usr/bin/env bash
## Clean up personal username in desktop file and
## xfce config file
MY_USER=$(whoami)
sed -E 's@(/home/)user@\1'"${MY_USER}"'@'
