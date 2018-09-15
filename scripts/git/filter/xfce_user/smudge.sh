#!/usr/bin/env bash
# Restore home path in configuration file (default is /home/user)
MY_USER=$(whoami)
sed -E 's@(/home/)user@\1'"${MY_USER}"'@'
