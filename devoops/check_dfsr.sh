#!/bin/bash
# Check weather Check_MK DFSR Plugin is installed
# 
# @2015-11-17 - by s3cur3n3t
#
################################################################################################################################

############
#   MAIN   #
############
# Should be used with source file check_mk.conf
. default/check_mk.conf

# Call functions
get_dfsr
work_file_dfsr
blist_comp_dfsr
send_mail_dfsr