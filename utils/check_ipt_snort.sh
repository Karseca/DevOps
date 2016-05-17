#!/bin/bash
#
#
#
#
#
#
#########################################
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

# Call to function to validate FWsnort rules install
check_ipt_snort