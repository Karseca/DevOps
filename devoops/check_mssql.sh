#!/bin/bash
# Check weather MSSSQL Check_MK Plugin is installed
# 
#@2015-11-13 - s3cur3n3t
#
####################################################################################################################################

############
#   MAIN   #
############
# Should be used with source file check_mk.conf
. default/check_mk.conf

# Call functions
get_mssql
work_file_mssql
blist_comp_mssql
send_mail_mssql
clean_tmp
