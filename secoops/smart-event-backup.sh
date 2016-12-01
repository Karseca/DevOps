#!/bin/bash
#
# This script is intended to automate the backup of files
# from Checkpoint SmartEvent to our Backup server, it will
# do it every 2 months and will only backup the last 60 days old 
# files.
#
# To use this script you'll need to do ssh-keygen on your
# local backup server, and then do ssh-copy-id to the 
# Checkpoint Smart Event Server and then you can put it 
# on your cron and every time it runs you receive email
#
# Created by s3cur3n3t @2016-11-29
# Email: s3cn3t@gmail.com
#
###########################################################
#
# Global variable declaration
#
CONTACTS=( ) # insert emails in this array for whoom you want to warn
SMART_EVT_SERVER= #  put server IP
SERVER_NAME=''  # insert hostname to use on file and  send mail
OLD_DATE=`ssh admin@$SMART_EVT_SERVER find /opt/CPsuite-R77/fw1/log/*.log -type f  -mtime +60 | grep -v fw.log | awk 'NR == 1 || /PATTERN/ {split($0,A,"/"); print A[6]}' | sed 's/_.*//'`
LAST_DATE=`ssh admin@$SMART_EVT_SERVER find /opt/CPsuite-R77/fw1/log/*.log -type f  -mtime +60 | grep -v fw.log | awk 'END{print}' | awk '{print $NF}' FS=/ | sed 's/_.*//'`
LOG_FILES=`ssh admin@$SMART_EVT_SERVER "cd /opt/CPsuite-R77/fw1/log/ ; find *.log* -type f -mtime +60"`

#
# Enter local directory to save backup tar file
#
cd /CheckPoint/Checkpoint_Logs/SmartEvent

#
# Actual backup command via SSH with private and public key
#
START_HOURS=`date | awk '{print $4}'`
ssh admin@$SMART_EVT_SERVER "cd /opt/CPsuite-R77/fw1/log/ ; tar -czvf - ${LOG_FILES[@]} --exclude='fw.log'" > backup-$SERVER_NAME.$OLD_DATE.$LAST_DATE.tar.gz

#
# Preparing data to sendmail
#
END_HOURS=`date | awk '{print $4}'`
HOSTNAME=`ssh admin@$SMART_EVT_SERVER "hostname"`
LOCATION=`ls -lha /CheckPoint/Checkpoint_Logs/SmartEvent/backup-$SERVER_NAME.$OLD_DATE.$LAST_DATE.tar.gz | awk '{print $9}'`

#
# Calulate time spent to take the backup
#
EPOCH_START=`date +%s -d ${START_HOURS}`
EPOCH_END=`date +%s -d ${END_HOURS}`
DIFF_EPOCH=`expr ${EPOCH_END} - ${EPOCH_START}`
TIME_SPENT=`date +%H:%M:%S -ud @${DIFF_EPOCH}`
#
# Sendmail alert to security team using postfix
#
(
    echo "From: " # insert the email from
    echo "To: ${CONTACTS[@]:0:2}"
    echo "Cc: ${CONTACTS[@]:2:3}"
    echo "MIME-Version: 1.0"    
    echo "Content-Type: text/html; charset=UTF-8"
    echo -e "Subject: Backup de logs de Checkpoint Smart Event com + 60 dias"
    echo -e "<html><body>Bom dia.</b></p>"
    echo -e "<p> Foi realizado o backup dos logs da SmartEvent - $HOSTNAME de $OLD_DATE a $LAST_DATE.</b></p>"
    echo -e "<p>A copia dos ficheiros de log teve inicio às $START_HOURS e finalizou às $END_HOURS.</b></p>"
    echo -e "<p>Tendo a copia durado cerca de:  $TIME_SPENT </b></p>"
    echo -e "<p> O ficheiro ficou armazenado em: $LOCATION</b></p></body></html>"
) | sendmail -t
