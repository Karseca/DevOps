#!/bin/bash
# Check weather IIS Check_MK Plugin is installed on Windows machines with Internet Information Services
# 
# 2015-08-19 - by devoops team
#
# 2015-10-21 - Script upgrade by s3cur3n3t
#
#####################################################################################################################################

############
#   MAIN   #
############
# Should be used with source file check_mk.conf
. default/check_mk.conf

# Call functions
get_iis
work_file_iis
blist_comp_iis
send_mail_iis
clean_tmp
