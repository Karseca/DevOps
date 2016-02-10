#!/bin/bash
#
# This script will install the the scripts to /opt
# 
# @2016 by s3cur3n3t 
#
#########################################################
LOCATION=`pwd`
RESULT="/tmp/install.log"
INSTDIRDEV="/opt/devoops"
INSTSCRIPTSDEV="/opt/devoops/clean_tmp.sh"
INSTMAINCONFDEV="/opt/devoops/default/check_mk.conf"
INSTINCLUDESDEV="/opt/devoops/default/include/clean_tmp.conf"
INSTDIRSEC="/opt/secoops"
touch /tmp/install.log

echo -e "Install log result of DevOps github" > $RESULT
echo -e "Please wait while copying files..."
cp -v -R $LOCATION/* /opt >> $RESULT

if [[ -d $INSTDIRDEV && $INSTDIRSEC && -a $INSTSCRIPTSDEV && -a $INSTMAINCONFDEV && -a $INSTINCLUDESDEV ]]
then 
	echo -e "Installation completed successfuly"
	cd /opt/devoops ; ls -la ;
	cd /opt/secoops ; ls -la ; 
else
	echo -e "Something went wrong, please verify log file!"
fi
