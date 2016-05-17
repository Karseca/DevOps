#!/bin/bash
#
#
#
#
#
#
###########################################
function check_ip_dns()
{
	if ping -q -c 1 -W 1 google.com >/dev/null 
	then
  		echo "The network is up"
		sleep 5  
	else
  		echo "The network is down"
		sleep 5  
	fi
}
# Call to function to check dns working or not
check_ip_dns