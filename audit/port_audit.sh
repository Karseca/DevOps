#!/bin/bash
#
# This script is intended too audit ip's or
# domain names within a file list
#
# @2016-03-01 by s3cur3n3t
#
##############################################
function fork_nmap() {
    ip_dn='ip_dn.lst'
    result='result.txt'
    res='result_new.txt'

    cat ip_dn.lst | while read ip;  do
	   	          {
                  if [[ -f $result ]]
                  then 
                    echo -e "File $result already used... Using $res file for final results..."
                    clear
		            echo -e "Scanning started, please wait for result..." 
                    nmap -T 5 -PS -Pn $ip >> $res
                  else
                    echo -e "File $result will be used for final results..."
                    clear
		            echo -e "Scanning started, please wait for result..."
                    nmap -T 5 -PS -Pn $ip >> $result
                  fi
                  }
		        done

    echo -e "Openning result files..."

    less $result 
    less $res
}

############
#   MAIN   #
############
# Call function to fork - parent/child creation
fork_nmap &
