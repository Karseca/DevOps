#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# @2016-05-07 by s3cur3n3t
#
##############################################
#
# Call libraries needed for the program
#
from Tkinter import *
import os as sys

#
# Command button function definition
#
def main_srv_command():
        sys.system("gnome-terminal -e 'bash -c /usr/local/bin/net_svc.sh; exit'")        
        
def lan_command():
        sys.system("gnome-terminal -e 'bash -c /usr/local/bin/fw-restore-ens5.sh; exit'")
        
def wlan_commmand():
        sys.system("gnome-terminal -e 'bash -c /usr/local/bin/fw-restore-wls1.sh; exit'")
        
def ip_dns_commmand():
        sys.system("gnome-terminal -e 'bash -c /usr/local/bin/check_ip_dns.sh'; exit")
        
def http_command():
        sys.system("gnome-terminal -e 'bash -c /usr/local/bin/check_web_access.sh; exit'")
        
def ipt_snort_command():
        sys.system("gnome-terminal -e 'bash -c /usr/local/bin/check_ipt_snort.sh; exit'")
        
def fwsnort_upd_command():
         sys.system("gnome-terminal -e 'bash -c /usr/local/bin/fwsnort_rules_update.sh; exit'")
 
def exit_command():
        exit() 
 
def window_help():
        window_help = Tk()
	window_icon()
        window_help.title("Help")
        window_help.geometry('{}x{}'.format(640, 480))
        window_help.resizable(width=FALSE, height=FALSE)
        text = Text(window_help)
        text.pack()
        text.insert(END, """Services Start - This button will do the following:\n
                                      --> Execute the configuration files for the network services:
                                         - Stop the network card active;
                                         - Change macaddress using macchanger;
                                         - Restore firestarter firewall gui configuration;
                                         - Start fprobe on the active network card;
                                         - Start snort and suricata;
                                         - Restore iptables configuration, if saved before;
                                         - Create and restore the honeypots;
                                         - Start farpd on the active network card;
                                         - Start arpon to monitor arp connections;\n\n           
                                      --> Execute the global configuration file for services common to network interfaces:\n 
                                         - Start Mysql service;\n
                                         - Start metasploit service;\n
                                         - Start TOR service with sepcific user;\n
                                         - Start Apache web server;\n
                                         - Start Nessus service;\n
                                         - Start i2p service;\n
                                         - Start OSSEC Network Intrusion Dectection System;\n
                                         - Start BeEF XSS exploitation framework;\n 
                                         - start Spiderfoot Web Vuulnerability Scanner;
                                         - Start local monitoring services: HTOP, IOTOP, TOR Monitor(arm);\n
                                         - Start DNS Crypt to encrypt DNS queries;\n
                                         - Start VirtualBox web services;\n
                                         - Start Port Spoofing service;\n
                                         - Start fail2ban service;""")

#
# Set windows icon (favicon)
#
def window_icon():
    icon = PhotoImage(file = '/opt/devoops/Firewall.png')
    window.tk.call('wm', 'iconphoto', window._w, icon)

#
# Main menu window definition
#        
window = Tk()
window_icon()
window.title("Connections State Restore")
window.geometry('{}x{}'.format(420, 285))
window.resizable(width=FALSE, height=FALSE)
bckground_img = PhotoImage(file = '/root/Pictures/net_svc.gif')
bckground_label = Label(window, image = bckground_img)
bckground_label.place(x=0, y=0, relwidth=1, relheight=1)

#
# Buttons definitions and configuration
#
button_svr = Button(window, text = '         Services Start          ', command = main_srv_command)
button_svr.pack(pady = 5, padx = 5)
button_svr.place(x = 10, y = 5)

button_lan = Button(window, text = '    LAN Network Adapter    ', command = lan_command)
button_lan.pack(pady = 5, padx = 5)
button_lan.place(x = 10, y = 40)

button_wlan = Button(window, text = '  WLAN Network Adapter   ', command = wlan_commmand)
button_wlan.pack(pady = 5, padx = 5)
button_wlan.place(x = 10, y = 75)

button_conn_check = Button(window, text = 'IP/DNS Connectivity Check', command = ip_dns_commmand)
button_conn_check.pack(pady = 5, padx = 5)
button_conn_check.place(x = 10, y = 110)

button_http_check = Button(window, text = '     HTTP Access Check      ', command = http_command)
button_http_check.pack(pady = 5, padx = 5)
button_http_check.place(x = 10, y = 145)

button_ipt_snort_check = Button(window, text = '  IPT/SNORT Rules Check   ', command = ipt_snort_command)
button_ipt_snort_check.pack(pady = 5, padx = 5)
button_ipt_snort_check.place(x = 10, y = 180)

button_fwsnort_upd = Button(window, text = '   FWSnort Rules Update   ', command = fwsnort_upd_command)
button_fwsnort_upd.pack(pady = 5, padx = 5)
button_fwsnort_upd.place(x = 10, y = 215)

button_exit = Button(window, text = 'Exit', command = exit_command)
button_exit.pack(pady = 5, padx = 5)
button_exit.place(x = 10, y = 250)

button_help = Button(window, text = 'Help', command = window_help)
button_help.pack(pady = 5, padx = 5)
button_help.place(x = 141, y = 250)

#
# Call to main menu window function
# 
window.mainloop()
