#!/bin/bash
#
# Get your public IP Address
# @2016-03-01 by s3cur3n3t
#
#######################################
pub_ip=`curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`

function pause() {
    read -p "$*"
}

clear
echo -e "Your Public IP is $pub_ip! "
echo -e "Press any key to continue..."
pause
