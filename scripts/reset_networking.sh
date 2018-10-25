#!/usr/bin/env bash
##################################################
# This file is used to remember some commands for
# Wireless Network
##################################################

sudo ifdown -a
sudo ifup -a
# sudo lshw -C network
# sudo ip link show eno1
# sudo ip link show wlp3s0
# ifconfig
# sudo /etc/init.d/networking restart
sudo service network-manager restart
sudo systemctl restart NetworkManager
