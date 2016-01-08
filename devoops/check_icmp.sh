#!/bin/bash
# Verify Check_MK Agent version in all instances of Check_MK servers for all monitored hosts
#
# 2015-11-17 - by s3cur3n3t
#
###############################################################################################################

############
#   MAIN   #
############
# Should be used with source file check_mk.conf
. default/check_mk.conf

# Call to functions
get_icmp
send_mail_icmp
clean_tmp
