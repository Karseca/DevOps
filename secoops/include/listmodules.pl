#!/usr/bin/perl -w
# 
# This script is used along with fw_snort.sh 
# to list perl modules needed to install
# fwsnort.
#
# @2016 by s3cur3n3t
#
###########################################
use ExtUtils::Installed;

my $inst    = ExtUtils::Installed->new();
my @modules = $inst->modules();
 foreach $module (@modules){
      print $module . "\n";
 }
