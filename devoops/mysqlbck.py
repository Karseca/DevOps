#!/usr/env/python
#
# Interactive python script for mysql database backup local or remotely
# @30-12-2015 by s3cur3n3t
#
# #######################################################################
import MySQLdb
import getpass
import os
import gzip
from subprocess import Popen, PIPE, STDOUT

# Define password function
def get_password():
	os.system("stty -echo")
	passwd = raw_input( getpass.getpass() + "'s passwd")
	os.system("stty echo")
	print "\n"
	return passwd
	
def dump_db():
	print "Enter hostname or ip address:"
	host = raw_input()			
	print "Enter port number:"
	port = int(raw_input())
	print "Enter username:"
	user = raw_input()
	print "Enter your password:"
	password = get_password()
	print "Enter databasename:"
	db = raw_input()
				
	# Test connection to database
	print "Testing connection"
	connection=MySQLdb.connect(host,port,user,password,db)
	cursor = db.cursor()
	cursor.execute("SELECT VERSION()")
	cursor.close()
	connection.close()
				
	# Dumping database
	print "Database backup started, please wait..."
	dump = ["mysqldump", "--dump-date", "-h" + host, "--port=" + port, "-u" + user, "-p" + password, db]
	process_dump = subprocess.Popen(dump, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
	output_dump = dump.communicate()[0]
				
	# Compress with gunzip and save it to file location
	file = gzip.open(/usr/local/src/bck/, "wb")
	file.write(output_dump)
	file.close()				

# Define submenu local connection function 
def sub_conn_local():
	sublocal{}
	sublocal['1']="1.1- Insert connection parameters (Host, Port, User, Pass, DB)"
	sublocal['2']="1.2- Exit"
	sublocal['3']="1.3- Back"
	while True:
		options=sublocal.keys()
		options.sort()
		for entry in options:
			print entry, menu[entry]
		select=raw_input("Select operation: \n")
		if select == '1':
			dump_db()
		elif select == '2':
			exit()
		else
			menu()
			
# Define submenu local connection function
def sub_conn_remote():
	subremote{}
	subremote['1']="2.1- Insert connection parameters (Host, Port, User, Pass, DB)"
	subremote['2']="2.2- Exit"
	subremote['3']="2.3- Back"
	while True:
		options=sublocal.keys()
		options.sort()
		for entry in options:
			print entry, menu[entry]
		select=raw_input("Select operation: \n")
		if select == '1':
			dump_db()
		elif select == '2':
			exit()
		else
			menu()

# Get user input
def menu():
	menu = {}
	menu['1']="1- Local connection"
	menu['2']="2- Remote connection"
	menu['3']="3- Exit"
	while True:
		options=menu.keys()
		options.sort()
		for entry in options:
			print entry,menu[entry]

		selection=raw_input("Please select:")
		if selection == '1':
			sub_conn_local()
		elif selection == '2':
			sub_conn_remote()
		else
			exit()

def main():
	menu()
	
if __name__ == "__main__":
	main()
