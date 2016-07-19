#!/bin/bash
#
# This script is intended to remotley verify the
# cypher suites that a server negotiates
#
# @2016-7-19 by s3cur3n3t
#
#####################################################
#
# OpenSSL requires the port number.
#
clear
echo -e "########################################################"
echo -e "#              Server SSL cipher fetch                 #"
echo -e "#                                                      #"
echo -e "#                Created by s3cur3n3t                  #"
echo -e "#                                                      #"
echo -e "########################################################"      
echo -e "Please insert server and port number [<server>:<port>]: "
read -p ">" SERVER
DELAY=1
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo Obtaining cipher list from $(openssl version).

for cipher in ${ciphers[@]}
do
echo -n Testing $cipher...
result=$(echo -n | openssl s_client -cipher "$cipher" -connect $SERVER 2>&1)
if [[ "$result" =~ ":error:" ]] ; then
  error=$(echo -n $result | cut -d':' -f6)
  echo -e "NO \($error\)"
else
  if [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
    echo YES
  else
    echo "UNKNOWN RESPONSE"
    echo $result
  fi
fi
sleep $DELAY
done