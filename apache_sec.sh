#!/bin/bash
#
# Automate the implementation of chroot and mod_security in apache2/httpd
# @2015-12-29 by s3cur3n3t
# Can be used and prepared for Puppet/Chef automation tools
# Create resources } classes } manifests
#
###############################################################################
# Global variables declaration
dir_rhel='/etc/httpd/conf/httpd.conf'
dir_deb='/etc/apache/apache2.conf'
ARCH_32='i*86'
ARCH_64='x86_64'
ARCH_TEST=`uname -m`

# Prepare directory
clear
echo -e "Preparing directory.."
JAIL="/chroot"
mkdir $JAIL
	
# Install packages Apache/MySQL/PHP
function rhel_server {
	clear
	echo -e "Preparing to install needed packages"
	yum install mysql mysql-server httpd php-mysql php-pear php-xml php-mysql php-cli php-imap php-gd php-pdo php-devel php-mbstring php-common php-ldap php httpd-devel
	php5dismod cache
	rm -rf /var/www/html
	}

# Install packages Apache/MySQL/PHP
function deb_server {
	clear
	echo -e "Preparing to install needed packages"
	apt-get install mysql mysql-server apache2 php5 php5-mysql php5-pear php5-cli php5-imap php5-gd php5-pdo php5-devel php5-mbstring php5-common php5-ldap libapache2-mod-php5
	php5dismod cache
	rm -rf /var/www/html
	}

# Create directory environment for chroot apache
function mk_dir {
	clear
	echo -e "Creating directories in jailed directory!"
	mkdir -p $JAIL/var/run
	chown -R root.root $JAIL/var/run
	mkdir -p $JAIL/home/httpd
	mkdir -p $JAIL/var/www/html
	mkdir -p $JAIL/tmp
	chmod 1777 $JAIL/tmp
	mkdir -p $JAIL/var/lib/php/session
	chown root.apache $JAIL/var/lib/php/session
}

# Prepare environment for httpd RHEL
function env_rhel {
	sed -i 's/ServerTokens OS/ServerTokens Prod/g' $dir_rhel
	sed -i 's/ServerSignature On/ServerSignature Off/g' $dir_rhel
	if [[ $ARCH_TEST == $ARCH_64 ]]
	then
		# edit file and put LoadModule chroot_module /usr/lib64/httpd/modules/mod_chroot.so
		sed '/\/mod_version/a LoadModule chroot_module /usr/lib64/httpd/modules/mod_chroot.so' $dir_rhel
		sed -i 's/PidFile run\/httpd.pid/PidFile \/var\/run\/httpd.pid' $dir_rhel
		sed 'ServerRoot \"\/etc\/httpd\"/i ChrootDir \/chroot' $dir_rhel
		sed 'ChrootDir \/chroot/i LockFile \/var\/run\/httpd\.lock' $dir_rhel
		sed 'LockFile \/var\/run\/httpd\.lock/i CoreDumpDirectory \/var\/run' $dir_rhel
		sed 'CoreDumpDirectory \/var\/run/i ScoreBoardFile \/var\/run\/httpd\.scoreboard' $dir_rhel
	elif [[ $ARCH_TEST == $ARCH_32 ]]
	then
		# edit file and put LoadModule chroot_module /usr/lib/httpd/modules/mod_chroot.so
		sed '/\/mod_version/i LoadModule chroot_module /usr/lib/httpd/modules/mod_chroot.so' $dir_rhel
		sed -i 's/PidFile run\/httpd.pid/PidFile \/var\/run\/httpd.pid' $dir_rhel
		sed 'ServerRoot \"\/etc\/httpd\"/i ChrootDir \/chroot' $dir_rhel
		sed 'ChrootDir \/chroot/i LockFile \/var\/run\/httpd\.lock' $dir_rhel
		sed 'LockFile \/var\/run\/httpd\.lock/i CoreDumpDirectory \/var\/run' $dir_rhel
		sed 'CoreDumpDirectory \/var\/run/i ScoreBoardFile \/var\/run\/httpd\.scoreboard' $dir_rhel
	else
		echo -e "Not able to create configuration, please review code!"
	fi
}

# Prepare environment for apache DEB
function env_deb {
	sed -i 's/ServerTokens OS/ServerTokens Prod/g' $dir_deb
	sed -i 's/ServerSignature On/ServerSignature Off/g' $dir_deb
	if [[ $ARCH_TEST == $ARCH_64 ]]
	then
		# edit file and put LoadModule chroot_module /usr/lib64/httpd/modules/mod_chroot.so
		sed '/\/mod_version/a LoadModule chroot_module /usr/lib64/apache2/modules/mod_chroot.so' $dir_deb
		sed -i 's/PidFile run\/apache2.pid/PidFile \/var\/run\/apache2.pid' $dir_deb
		sed 'ServerRoot \"\/etc\/apache2\"/i ChrootDir \/chroot' $dir_deb
		sed 'ChrootDir \/chroot/i LockFile \/var\/run\/apache2\.lock' $dir_deb
		sed 'LockFile \/var\/run\/apache2\.lock/i CoreDumpDirectory \/var\/run' $dir_deb
		sed 'CoreDumpDirectory \/var\/run/i ScoreBoardFile \/var\/run\/apache2\.scoreboard' $dir_deb
	elif [[ $ARCH_TEST == $ARCH_32 ]]
	then
		# edit file and put LoadModule chroot_module /usr/lib/httpd/modules/mod_chroot.so
		sed '/\/mod_version/i LoadModule chroot_module /usr/lib/apache2/modules/mod_chroot.so' $dir_deb
		sed -i 's/PidFile run\/apache2.pid/PidFile \/var\/run\/apache2.pid' $dir_deb
		sed 'ServerRoot \"\/etc\/apache2\"/i ChrootDir \/chroot' $dir_deb
		sed 'ChrootDir \/chroot/i LockFile \/var\/run\/apache2\.lock' $dir_deb
		sed 'LockFile \/var\/run\/apache2\.lock/i CoreDumpDirectory \/var\/run' $dir_deb
		sed 'CoreDumpDirectory \/var\/run/i ScoreBoardFile \/var\/run\/apache2\.scoreboard' $dir_deb
	else
		echo -e "Not able to create configuration, please review code!"
	fi
}

# Download and install chroot RHEL
function get_chroot_rhel {
	clear
	echo -e "Start download and install mod_chroot for RHEL distro"
	cd /usr/local/src
	wget http://core.segfault.pl/~hobbit/mod_chroot/dist/mod_chroot-0.5.tar.gz
	tar -zxvf mod_chroot-0.5.tar.gz
	cd mod_chroot-0.5
	apxs -cia mod_chroot.c
	cd /
	setsebool httpd_disable_trans 1
	sed 'RETVAL\=0/i ROOT\=\/chroot' $dir_exec_rhel
	sed 'echo \-n \$\"Stopping \$prog\: \"/i \/bin\/ln \-s \$ROOT\/var\/run\/httpd\.pid \/var\/run\/httpd\.pid' $dir_exec_rhel
	service httpd restart
}

# Download and install chroot DEB
function get_chroot_deb {
	clear
	echo -e "Start download and install mod_chroot for Deb distro"
	apt-get install libapache2-mod-chroot mod-chroot-common apache2.2-common
	sed 'RETVAL\=0/i ROOT\=\/chroot' $dir_exec_deb
	sed 'echo \-n \$\"Stopping \$prog\: \"/i \/bin\/ln \-s \$ROOT\/var\/run\/httpd\.pid \/var\/run\/httpd\.pid' $dir_exec_deb
	echo -e "Installation complete"
	service apache2 restart
}

# Test what linux distribution we have and execute the functions for one of the distros
if [ -f /etc/debian_version ];
then
	deb_server
	mk_dir
	env_deb
	get_chroot_deb
elif [ -f /etc/redhat-release]
then
	rhel_server
	create_dir
	env_rhel
	get_chroot_rhel
else
	echo -e "Unknown linux distribution, please contact administrator"
fi
