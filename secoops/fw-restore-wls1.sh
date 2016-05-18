#!/bin/bash
#
# Firestarter and iptables restore script
# for wireless network adapter
#
# @2016-04-27 by s3cur3n3t
#
############################################
# Debug script
set -x
clear

# Global variable declaration
IPT=/sbin/iptables
IPT_REST=/sbin/iptables-restore
IPT_SWITCH='--flush'

# Stopping and starting wifi interface
# to maintain convention interfaces name
nmcli r wifi off
ifrename -i wlan0 -n wls1
nmcli r wifi on
sleep 20

# Stoping and starting services
echo -e "Starting firestarter fw..."
pkill -f firestarter
cp /etc/firestarter/configuration.wls1 /etc/firestarter/configuration
firestarter --start-hidden & 2>&1
sleep 10

# Clean iptables
echo -e "Cleaning iptables... Please wait..."
$IPT $IPT_SWITCH

# Restore iptables configuration
echo -e "Restoring firewall state..."
$IPT_REST /etc/network/iptables_wls1
exit
