#!/bin/bash
# 
# Scientific Linux 7 - Post installation script
# 
# Authors:		Bagrat Petrosyan, Davit Kalantaryan (Email: davit.kalantaryan@desy.de)
# Created on:	2020 Jan 07
# Codename:		Nitrogen
# 
# This is post installation script for Scientific Linux 7 .
# This script makes the host in such a stat where we (DESY ZN ERS group) can do our development 
# as well we can do our debugging stuff connected to SL6 development
#

# declaring some necessary variables
#                    https://desycloud.desy.de/index.php/s/Q4FdzZ5yiCj5gX8
#                    https://desycloud.desy.de/index.php/s/Q4FdzZ5yiCj5gX8
REPOSITORY_ROOT_BASE=https://desycloud.desy.de/index.php/s/Q4FdzZ5yiCj5gX8/download?path=%2Fsys
REPOSITORY_ROOT=${REPOSITORY_ROOT_BASE}%2FCarbon
REPOSITORY_CONFIGS_ROOT=${REPOSITORY_ROOT}%2Fconfigs\&files=
REPOSITORY_SCRIPTS_ROOT=${REPOSITORY_ROOT}%2Fscripts\&files=

# check if user is root
USER1=`id -nu`
if [ "${USER1}" != "root" ] ; then
	echo "!!! only root can start this script !!!"
	exit 1
fi

# 1. Make sshd on  
	systemctl enable sshd

# 2. Install (if not installed) and configure NTP client  
	yum install ntp -y
	PERL_PATH=`which perl`
	if [ -z "$PERL_PATH" ]; then
		yum install perl -y
	fi
	perl -pi -e 's/ntp.ubuntu.com/timesrv.ifh.de/g' /etc/ntp.conf
	echo "141.34.1.22 ntp-server-host" >> /etc/hosts	
	service ntpd restart
	
# 3. Install and configure OpenAFS  
	#yum install openafs.x86_64 -y 
	#yum install openafs-client.x86_64 -y 
	#yum install openafs-krb5.x86_64 -y 
	
	# https://wiki.ncsa.illinois.edu/display/ITS/OpenAFS+Install+via+YUM+for+EL6+EL7
	# https://support.azul.com/hc/en-us/articles/217293566-Using-DKMS-on-RHEL-CentOS-or-Oracle-Linux-to-build-ZST-for-other-kernel-versions
	############## yum -y install openafs*
	
	cp /usr/vice/etc/CellAlias /usr/vice/etc/CellAlias.original 2>/dev/null || :
	wget ${REPOSITORY_CONFIGS_ROOT}CellAlias -O /usr/vice/etc/CellAlias 
	cp /usr/vice/etc/CellServDB /usr/vice/etc/CellServDB.original 2>/dev/null || :
	wget ${REPOSITORY_CONFIGS_ROOT}CellServDB -O /usr/vice/etc/CellServDB
	cp /usr/vice/etc/ThisCell /usr/vice/etc/ThisCell.original 2>/dev/null || :
	wget ${REPOSITORY_CONFIGS_ROOT}ThisCell -O /usr/vice/etc/ThisCell
		
	#rmmod openafs 2>/dev/null || : 
	service afs restart
	systemctl enable sshd  
	#echo 'open the "cacheinfo" file in /usr/vice/etc/cacheinfo and make sure it has a line like this: "/afs:/usr/vice/cache:100000"' 
	CHECK_NECESSARY_STRING=`cat /usr/vice/etc/cacheinfo | grep /afs:/var/cache/afs:100000`
	if [ -z "$CHECK_NECESSARY_STRING" ]; then
		touch /usr/vice/etc/cacheinfo
		echo "/afs:/var/cache/afs:100000" >> /usr/vice/etc/cacheinfo
	fi
	
# 4. Setup sshd to access login using kerberos https://docs.openafs.org/QuickStartUnix/HDRWQ41.html 
	yum install pam_krb5 -y 
	cp /etc/pam.d/password-auth /etc/pam.d/password-auth.original 2>/dev/null || :
	wget ${REPOSITORY_CONFIGS_ROOT}password-auth -O /etc/pam.d/password-auth
	
# 5. Install rpcbind service and change it to insecure mode  
	yum install rpcbind -y 
	echo 'OPTIONS="-w -i"' | tee /etc/default/rpcbind 

	service rpcbind restart
	systemctl enable rpcbind 
	
# 6. Create /export directory with necessary subdirectories and corresponding links
	mkdir -p /export/doocs/.admin
	mkdir -p /export/doocs/scripts
	mkdir -p /export/doocs/server
	mkdir -p /export/doocs/bin
	mkdir -p /export/doocs/lib
	mkdir -p /export/home
	mkdir -p /local
	
# 7. Create some necessary links
	currentDirectory=`pwd`
	cd /local
	ln -s /export/doocs/lib
	cd /
	ln -s /afs/ifh.de/group/pitz/doocs 
	cd ${currentDirectory}
	
# 8. Download all initial files  
	# ${REPOSITORY_ROOT}%2Fconfigs\&files=
	wget ${REPOSITORY_ROOT_BASE}%2Fcommon%2F.admin\&files=.passwd_net_users -O /export/doocs/.admin/.passwd_net_users 
	wget ${REPOSITORY_ROOT_BASE}%2Fcommon%2F.admin\&files=.groups_net_users -O /export/doocs/.admin/.groups_net_users  
	wget ${REPOSITORY_SCRIPTS_ROOT}local_create_mtca_znaccount_prvt -O /export/doocs/.admin/local_create_mtca_znaccount_prvt 
	chmod a+x /export/doocs/.admin/local_create_mtca_znaccount_prvt
	
# 9. Create necessary account 
	# All developers
	/export/doocs/.admin/local_create_mtca_znaccount_prvt bagrat
	/export/doocs/.admin/local_create_mtca_znaccount_prvt gryvash
	/export/doocs/.admin/local_create_mtca_znaccount_prvt kalantar
	/export/doocs/.admin/local_create_mtca_znaccount_prvt mdavid
	/export/doocs/.admin/local_create_mtca_znaccount_prvt sweisse
	
	# doocsadm for running servers
	useradd -c "Doocs Admin" --home /export/home/doocsadm --gid 216 -m --shell /bin/bash --uid 995 doocsadm  
	
# 10. Setup corresponding owners and permissions for folders
	chown -R doocsadm:pitz /export/doocs
	chmod -R 775 /export/doocs
	chown -R root:adm /export/doocs/.admin
	chmod -R 770 /export/doocs/.admin
	
# 11 To do list
#	1. Disable ssh for root
