#!/bin/bash
#
# This script is intended to test a site response time
#
# @2016-07-14 by s3cur3n3t
#
#########################################################
#
# Function http_response declaration
#
function http_response()
{
clear
echo -e	"################################################"
echo -e "#		Test internet published	       #"
echo -e	"#		  site response time	       #"
echo -e "#					       #"
echo -e "#	Usage: insert like www.site.com	       #"
echo -e "#					       #"
echo -e "#		Created by s3cur3n3t	       #"
echo -e "#					       #"
echo -e "################################################"
	echo -e "Please insert site to test response: "
	read SITE
	curl -s -w '\nLookup time:\t%{time_namelookup}\nConnect time:\t%{time_connect}\nPreXfer time:\t%{time_pretransfer}\nStartXfer time:\t%{time_starttransfer}\n\nTotal time:\t%{time_total}\n' -o /dev/null ${SITE}
}
#
# Function http_response_repeat declaration
#
function http_response_repeat()
{
	echo -e "Test another site response? [Yes/No]"
	read ANSWER
	case $ANSWER in
	      yes|Yes|y|Y)
			http_response
			http_response_repeat
			;;
      	       no|No|n|N)
			echo -e "Bye!!! :D"
			exit
			;;
		       *)
			echo "Invalid option..."
			sleep 2
			http_response_repeat
	esac
}
#
# Function call
#
http_response
http_response_repeat
