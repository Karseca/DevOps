#!/bin/bash
#
# Firestarter and iptables restore script
# for ethernet network adapter
#
# @2016-04-27 by s3cur3n3t
#
#############################################
# Debug script
set -x
clear

# Global variable declaration
IPT=/sbin/iptables
IPT_REST=/sbin/iptables-restore
IPT_SWITCH='--flush'

# Stoping and starting services
echo -e "Starting firestarter fw..."
pkill -f firestarter
cp /etc/firestarter/configuration.ens5 /etc/firestarter/configuration
firestarter --start-hidden & 2>&1
sleep 10

# Clean iptables
echo -e "Cleaning iptables... Please wait..."
$IPT $IPT_SWITCH

# Restore iptables configuration
echo -e "Restoring firewall state..."
$IPT_REST /etc/network/iptables_ens5
exit
