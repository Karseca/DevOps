#!/bin/bash                                     
#                                                 
#        fwsnort cron.daily update script         
#             created by s3cur3n3t                
#                 @216-02-2017                    
#                                                 
###################################################
# Source conf file with the remove temp files
source /usr/local/include

# Global variables declaration
snort_rules='https://rules.emergingthreats.net/open/'  
check_snort_ver=`snort -V`
work_tmp='/tmp' 
rules_dir='/etc/snort/rules'
snort_ver_file=$work_tmp/'snort_ver.txt' 
sudo touch /usr/bin/fwsnort_update.sh

# Prepare to donwload snort rules based on SNORT version
echo "Checking snort version and prepare for rules download..."
touch $snort_ver_file
echo $check_snort_ver | grep    | awk '{ print }' >> $snort_ver_file
wget -r -N -nH -nd -np -R index.html* https://$snort_rules/snort-$(cat $snort_ver_file)/rules/ -P /etc/snort/rules/
echo "Firewall snort rules will starting..."
touch $work_tmp/rules.txt
ls -la $rules_dir/*.rules  >> $work_tmp/rules.txt
cat $work_tmp/rules.txt | while read line do {
                                               echo "Converting snort rules to iptables..."
                                               fwsnort --snort-rfile /etc/snort/rules/$line
                                               fwsnort
                                               echo "Please wait, applying iptables rules..."
                                               sudo /var/lib/fwsnort/fwsnort_iptcmds.sh                        
                                              }
                                          done
# Remove temporary files created on upgrade process                                          
rm_tmp 
