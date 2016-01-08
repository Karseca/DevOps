#!/bin/bash
# Verify Check_MK Agent version in all instances of Check_MK servers for all monitored hosts
#
# @2015-08-31 - s3cur3n3t 
#
# @2015-10-27 Script upgrade
#
###############################################################################################################

############
#   MAIN   #
############
# Should be used with source file check_mk.conf
. default/check_mk.conf

# Call to functions
get_version
send_mail_agent
clean_tmp
