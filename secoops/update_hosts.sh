#!/bin/bash
#
# Simple script to block advertisement on linux
# machines using /etc/hosts
# 
# @2016-02-03 by s3cur3n3t
#
###################################################
# Global variables
work_tmp="/tmp"
work_dir="/etc"
download="$work_tmp/download"
hosts_prd="$work_dir/hosts"
hosts_bck="$work_dir/hosts.bck"
white_lst="$work_tmp/whitelist.txt"
new_lst="$work_tmp/newlist.txt"

# Create files and folders before use
touch $white_lst
touch $new_lst
touch $hosts_bck
mkdir $download

# Create the white list to use after
cat /etc/hosts | sed -n -e '/BAD/,$p' | awk 'FS="\n" {print $1 $2}' >> $white_lst
head -27 /etc/hosts >> $hosts_bck

# Get the files we will get in the new list file
wget http://hosts-file.net/ad_servers.txt -P $download
wget http://hosts-file.net/emd.txt -P $download
wget http://hosts-file.net/exp.txt -P $download
wget http://hosts-file.net/fsa.txt -P $download
wget http://hosts-file.net/grm.txt -P $download
wget http://hosts-file.net/hjk.txt -P $download
wget http://hosts-file.net/mmt.txt -P $download
wget http://hosts-file.net/pha.txt -P $download
wget http://hosts-file.net/psh.txt -P $download
wget http://hosts-file.net/wrz.txt -P $download

# Clean old hosts file and send your locahost 
# configuration to new hosts file created

echo "Creating new hosts file..."
echo > $hosts_prd
cat $hosts_bck > $hosts_prd

echo "Updating new hosts file..."
cat $download/ad_servers.txt >> $hosts_prd
cat $download/emd.txt >> $hosts_prd
cat $download/exp.txt >> $hosts_prd   
cat $download/fsa.txt >> $hosts_prd
cat $download/grm.txt >> $hosts_prd
cat $download/hjk.txt >> $hosts_prd
cat $download/mmt.txt >> $hosts_prd
cat $download/pha.txt >> $hosts_prd
cat $download/psh.txt >> $hosts_prd
cat $download/wrz.txt >> $hosts_prd

# Compare lists of hosts of new files with old files
