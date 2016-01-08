#!/bin/bash
# 
# Verify all hosts in source site can't exist in destination site.
# Report deviation via email weekly
#
# @2015-08-19 - by devoops team (pdm and s3cur3n3t)
#
##################################################################


# load conf file 
source /opt/devoops/oldscrpt/check_mk.conf
touch destination_site_hosts.list
touch deviation_site_host.txt

# -------------------------------------
# get destination list hosts 

echo -e 'GET hosts\nColumns: name\n' | nc $destination_site_host $destination_site_port | sort > destination_site_hosts.list


# -------------------------------------
# construct deviation list

echo -e 'GET hosts\nColumns: name\n' | nc $source_site_host $source_site_port | sort | while read h
do
	if ! grep -qi $h destination_site_hosts.list
	then
		echo $h >> deviation_site_host.txt
	fi
done


# -------------------------------------
# send information via email

#(
#echo "From: "
#echo "To: "
#echo "Cc: "
#echo "Bcc: antonio.pos-de-mina@novobancosi.pt"
#echo "MIME-Version: 1.0"
#echo "Content-Type: text/html; charset=UTF-8"
#echo -e "Subject: Monitozacao - verificacao entre sites $source_site_host e $destination_site_host"
#echo -e "<html><body><p>Verifica&ccedil;&atilde;o dos hosts que est&atilde;o no site <b>$source_site</b> e n&atilde;o est&atilde;o no site <b>$destination_site</b></p>"
#echo -e "<p>Total de hosts: <b>$(cat deviation_site_host.txt | wc -l)</b></p><hr><pre>"
#cat deviation_site_host.txt
#echo -e "</pre><hr><pre>$HOSTNAME $PWD $0 $SECONDS</pre></body></html>"
#) | sendmail -t 


# -------------------------------------
# clear last list

rm -f deviation_site_host.txt
rm -f destination_site_hosts.list

