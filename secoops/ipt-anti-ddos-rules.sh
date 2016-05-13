#!/bin/bash
#
# This script is intended to implement iptables anti-ddos
# rules to prevent these kind of attacks
#
# reference: https://javapipe.com/iptables-ddos-protection
#
# @2016-05-09 by s3cur3n3t
#
############################################################
#
# Global variables declaration
#
IPT=/sbin/iptables
IPTSAVE=$IPT-save
IPTREST=$IPT-restore
DATE=$(date +%y-%m-%d_%H%m%s)

# Clear screen
clear

#
# Backup your iptables rules
echo "Where do you wich to backup iptables configuration?"
read DIR
echo -e "Saving iptables configuration to" $DIR "please wait.."
$IPTSAVE > $DIR/iptables_$DATE.bck

#
# Implementing the anti-ddos rules
#
### 1: Drop invalid packets ###
echo "Installing Anti-DDoS Rules to your iptables..."
$IPT -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP

### 2: Drop TCP packets that are new and are not SYN ###
$IPT -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

### 3: Drop SYN packets with suspicious MSS value ###
$IPT -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

### 4: Block packets with bogus TCP flags ###
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
$IPT -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

### 5: Block spoofed packets ###
$IPT -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP
$IPT -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP
$IPT -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP
$IPT -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP
$IPT -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP
$IPT -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP
$IPT -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP
$IPT -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP
$IPT -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP

### 6: Drop ICMP (you usually don't need this protocol) ###
$IPT -t mangle -A PREROUTING -p icmp -j DROP

### 7: Drop fragments in all chains ###
$IPT -t mangle -A PREROUTING -f -j DROP

### 8: Limit connections per source IP ###
$IPT -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset

### 9: Limit RST packets ###
$IPT -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
$IPT -A INPUT -p tcp --tcp-flags RST RST -j DROP

### 10: Limit new TCP connections per second per source IP ###
$IPT -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 20 -j ACCEPT
$IPT -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP

### 11: Use SYNPROXY on all ports (disables connection limiting rule) ###
#$IPT -t raw -D PREROUTING -p tcp -m tcp --syn -j CT --notrack
#$IPT -D INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
#$IPT -D INPUT -m conntrack --ctstate INVALID -j DROP

### SSH brute-force protection ###
$IPT -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
$IPT -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

### Protection against port scanning ###
$IPT -N port-scanning
$IPT -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
$IPT -A port-scanning -j DROP

#
# Backup iptables with new rules
#
sleep 10
echo "Backing up iptables with Anti-DDoS rules"
$IPTSAVE > $DIR/iptables_new_$DATE.bck