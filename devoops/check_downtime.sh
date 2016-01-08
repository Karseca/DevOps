#!/bin/bash
# 
# Verify all hosts in source site can't exist in destination site.
# Report deviation via email weekly
#
# @2015-08-28 -by devoops team
#
# 2015-11-21 - Script upgrade by s3cur3n3t
#
#####################################################################################################################################

############
#   MAIN   #
############
# Should be used with source file check_mk.conf
. default/check_mk.conf

# Call fucntions
get_downtimes
send_mail_downtimes
clean_tmp
