#!/bin/bash
# Check wich machines were wrongly configured on production instances on production servers
#
# 2015-11-21 - by s3cur3n3t
#
##########################################################################################################

############
#   MAIN   #
############
# Should be used with source file check_mk.conf
. default/check_mk.conf

# Call functions
get_ips
send_mail_ips
clean_tmp
