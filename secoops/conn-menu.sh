#!/bin/bash
#
# This is a menu script intended to be used to
# choose wich is the network connections we
# want to restore.
#
# @2016-05-04 by s3cur3n3t
#
##############################################
# Terminal window name definition
TERM_TITLE="Connections State Restore"
echo -e '\033]2;'$TERM_TITLE'\007'

# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$ 

# Storage file for displaying command output
OUTPUT=/tmp/output.sh.$$
 
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; clear; exit" SIGHUP SIGINT SIGTERM SIGQUIT SIGTSTP
 
#
# Purpose - display output using msgbox 
#  $1 -> set msgbox height
#  $2 -> set msgbox width
#  $3 -> set msgbox title
#
function display_output(){
	local h=${1-21}			# box height default 21
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title 
	dialog --backtitle "Services and Network Restore, FW and IPS Updates" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w} --item-help --help-status --hfile /opt/devoops/help-conn-menu.txt
}

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

function check_web_access()
{
	case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
  		 [23]) echo "HTTP connectivity is up"; sleep 5; ;;
  			5) echo "The web proxy won't let us through"; sleep 5; ;;
  			*) echo "The network is down or very slow"; sleep 5; ;;
	esac
}

function check_ipt_snort()
{
	IPT_COMMAND="iptables -L"
	IPT_REF="FWSNORT"
	IPT_VAR_STDOUT="$(iptables -L | grep FWSNORT | awk "NR==1 { print $2 }")"
	if [[ "$IPT_VAR_STDOUT" == *"${IPT_REF}"* ]]
	then
        echo "FWSnort rules applied successfully!!!"
		sleep 5
	else
        echo "FWSnort rules not applied. Please run $IPT_COMMAND on terminal to check snort rules."
		sleep 5
	fi
}

function startup()
{
while true
do
 
	### display main menu ###
	dialog --clear  --help-button   --backtitle "Services and Network Restore, FW and IPS Updates" \
	--title "[ M A I N - M E N U ]" \
	--menu  " You can use the UP/DOWN arrow keys, the first letter \n\
	as a hot key, or the number keys 1-7 to choose an option. \n\
	Choose the TASK to execute: " 17 82 8 \
	"Services Start" "Restore services on link interface" \
	"LAN Network Adapter" "Restore network on ENS5" \
	"WLAN Network Adapter" "Restore network on WLS1" \
	"IP/DNS Connectivity Check" "Check weather IP and name resolution are working" \
	"HTTP Access Check" "Check weather web access is working" \
	"IPT/SNORT Rules Check" "Check weather snort rules applied on iptables" \
	"FWSnort Rules Update" "Update snort rules from emergingthreats.net" \
	Exit "Exit to the shell" 2>"${INPUT}"
	
	[ $? -ne 0 ] && break	
 
	menuitem=$(<"${INPUT}")

	# make decision 
	case $menuitem in
		'Services Start')
						 /opt/devoops/netsvc.sh;
						 startup;
					;;
		'LAN Network Adapter') 
								/usr/local/bin/fw-restore-ens5.sh;
								startup;
					;; 
		'WLAN Network Adapter') 
								/usr/local/bin/fw-restore-wls1.sh;
							    startup;
					;;
		'IP/DNS Connectivity Check')
									check_ip_dns;
									startup;
					;;
		'HTTP Access Check')
							check_web_access;
							startup;
					;;			
		'IPT/SNORT Rules Check')
								check_ipt_snort;
								startup;
					;;			
		'FWSnort Rules Update') 
								/opt/devoops/fwsnort_rules_update.sh;
								startup;
					;;
		'Exit') 
				clear;
				rm -rf /tmp/menu.sh*; 
				echo "Bye, thanks for using this script!"; 
				break;
					;;
		*)	
			echo "Error: Invalid option";
			sleep 2;
			startup;
					;;
	esac
done
}
# Call startup function
startup