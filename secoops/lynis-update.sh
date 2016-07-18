#!/bin/bash
#
# This script is intended to update lynis without no errors
# because lynis tool when using update release gives error
# on the protocol http/https
#
# @2016-07-17 by s3cur3n3t
#
###########################################################
#
# Global variables declaration
#
local_ver=`lynis update info | grep Version | awk '{print $3}'`
site="https://cisofy.com/download/lynis/"
update_ver=`curl -s $site | sed -rn '/.*Version:[^0-9]*([0-9.]+).*/p' | grep Version: | sed 's/<\/li>/ /' | awk '{print $2}'`
site_download="https://cisofy.com/files/lynis-$update_ver.tar.gz"
#
# Check local and online version
#
clear
echo -e "################################################"
echo -e "#					       #"
echo -e "#		Lynis update tool	       #"
echo -e "#	 Continuing this will update your      #"
echo -e "#		Lynis system audit tool	       #"
echo -e "#					       #"
echo -e "# 	Created by s3cur3n3t @2016-7-17	       #"
echo -e "#					       #"
echo -e "################################################"
echo -e "Please wait while checking version..."
if [[ "$local_ver" == "$update_ver" ]]
then
	echo "Your lynis version is up to date. Nothing to be done!"
	exit
elif [[ "$local_ver" != "$update_ver" ]]
then
	echo "New version $update_ver is available. Do wish to update? [Yes/No]"
	read INPUT
	case $INPUT in
		Y|y|Yes|yes)
			  echo "Please wait while downloading new version..."
			  wget -O /usr/local/src/lynis-$update_ver.tar.gz  $site_download
			  echo "Preparing to unpack version. please wait..."
			  cd /usr/local/src/
			  tar -zxvf /usr/local/src/lynis-$update_ver.tar.gz
			  cd lynis
			  echo "Installing new lynis version..."
			  cp -f -r db /usr/share/lynis
			  cp -f -r include /usr/share/lynis
			  cp -f -r extras /usr/share/lynis
			  cp lynis /usr/sbin/
			  echo "Checking version...."
			  cd /
		          lynis update info
				;;
		  N|n|No|no)
			   echo "Exiting lynis-update tool..."
			   exit
				;;
			*)
			  echo "Please answer Yes/No..."
	esac
else
	exit
fi
fi
