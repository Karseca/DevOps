#!/bin/bash
#
# This script is intdended to automatically
# generate,configure ssh_keys and test the  
# generated keys.
#
# @2016-02-05 by s3cur3n3t
#
##################################################
# Global variable declaration
command='ssh'
username=''
at='@'
hostname=''
switch='-p'

# Pause function to use in the script
function pause(){
     read -p "$*"
}   

# User creation, ssh keys generation and
# copy of public key to the servers to access remotely
echo "Insert username to create:"
read username
adduser -m $username

echo "Creating .ssh folder..."
mkdir -p /home/$username/.ssh

echo "Setting permissions on folder .ssh..." 
chown $username:$username /home/$username/.ssh

echo "Generating ssh keys..." 
sudo -u $username ssh-keygen

echo "Copying ssh public keys to the remote server..."
echo "Insert hostname:"
read hostname
cd /home/$username
sudo -u $username  ssh-copy-id -i .ssh/id_rsa.pub $username$at$hostame

echo "Press any key when ready to test connection..."
pause

# Test connection to remote server 
echo "Insert the created username to use:"
read username
echo "Insert the hostname to connect:"
read hostname
echo "Insert ssh port (if port different than port 22):"
read port

if [[ $port == ' ']]
then
    $command $username$at$hostname
else [[ $port != ' ']]
    $command $username$at$hostame $switch $port
fi
