#!/bin/bash
# 
# Scientific Linux 6 - Post installation script
# 
# Author:		Davit Kalantaryan (Email: davit.kalantaryan@desy.de)
# Created on:	2019 Dec 30
# Codename:		Carbon, Santiago
# 
# This is post installation script for Scientific Linux 6 .
# This script makes the host in such a stat where we (DESY ZN ERS group) can do our development 
# as well we can do our debugging stuff connected to SL6 development
#


# declaring some necessary variables
REPOSITORY_ROOT=https://desycloud.desy.de/index.php/s/a5A9sNtG5dJsafC/download?path=%2Fubuntu18
REPOSITORY_CONFIGS_ROOT=${REPOSITORY_ROOT}%2Fconfigs\&files=
REPOSITORY_SCRIPTS_ROOT=${REPOSITORY_ROOT}%2Fscripts\&files=

# check if user is root
USER1=`id -nu`
if [ "${USER1}" != "root" ] ; then
	echo "!!! only root can start this script !!!"
	exit 2
fi



		
# 4.	Switching off old interface and starting new interface
		#ifdown $CURRENT_INTERFACE_NAME && ifup eth1


		
# Old commands compatible for ubuntu 12

#  1.		First repository list should be updated and prepared!
		  apt-get update

#  2.		Good GUI text editor makes life easier
		  apt-get install nedit -y

#  3. (p. 10).	Installation of linux kernel sources (usually necessary)
#		For further version of this script this point will be confirmed after asking question
		  apt-get install linux-source -y

#  4. (p. 11)	Installation of linux headers if previous step is not done
		  apt-get install linux-headers-$(uname -r) -y

#  5. (p. 12)	Install NTP client
		  apt-get install ntp -y
		  #sudo nedit /etc/ntp.conf # this file should be modified to set correct time server
		  PERL_PATH=`which perl`
		  if [ -z "$PERL_PATH" ]; then
			apt-get install perl -y
		  fi
		  perl -pi -e 's/ntp.ubuntu.com/timesrv.ifh.de/g' /etc/ntp.conf
		  # ping to timesrv.zeuthen.desy.de 
		  echo "141.34.1.22 ntp-server-host" >> /etc/hosts 
		  sudo timedatectl set-timezone Europe/Berlin
		  # this app can be usefull ?
		  apt-get install ntpdate ntp -y
		  /etc/init.d/ntp restart

#  7.		Create all directories on /export
		  mkdir /export/doocs
		  mkdir /export/home
		  
		  
#  9.		Add user for Hamburg experts
		  groupadd -g 216 pitz
		  useradd -c "Hamburg Expert" --home /export/home/hamburgexpert --gid 216 -m --shell /bin/bash --uid 1001 hamburgexpert -p hamburgexpert
		  
#  6. (p. 13)	Installing afs_client+kerberos. Should be asked to AFS experts (Stephan Wiesand for example)
#		how could be prepared silent installer
		  apt-get install openafs-krb5 openafs-client krb5-user module-assistant openafs-modules-dkms -y # 2 questions, to make silent
		  dpkg-reconfigure krb5-config openafs-client   # a lot of questions
		  m-a prepare					# one queston
		  m-a auto-install openafs
		  modprobe openafs
		  service openafs-client restart

#  8.		Create symbolic linc doocs
		  ln -s /afs/ifh.de/group/pitz/doocs /doocs

# 10. (p. 06)	Change ssh to kerberos
		  #cp /doocs/amd64_linux26/pam.d/sshd  /etc/pam.d/.   # old approach
		  apt-get install libpam-afs-session -y
		  cp /etc/pam.d/sshd /etc/pam.d/sshd.original 2>/dev/null || :
		  wget ${REPOSITORY_CONFIGS_ROOT}_etc_pam.d_sshd -O /etc/pam.d/sshd
		  #cp /doocs/amd64_linux26/pam.d/password-auth /etc/pam.d/.  # old approach 
		  cp /etc/pam.d/password-auth /etc/pam.d/password-auth.original 2>/dev/null || :
		  wget ${REPOSITORY_CONFIGS_ROOT}_etc_pam.d_password-auth -O /etc/pam.d/password-auth
		  

# 11. (p. 14)	Install portmapper service
		  apt-get install rpcbind -y

# 12. (p. 15)	Change portmaper service to insecure mod
		  echo 'OPTIONS="-w -i"' | tee /etc/default/rpcbind
		  #service portmap restart
		  service rpcbind restart

# 13. (p. 19)	Modify /etc/environment
		  #echo "LD_LIBRARY_PATH=/doocs/lib:/doocs/bin/qtbin:$LD_LIBRARY_PATH" >> /etc/environment
		  #echo "PATH=/doocs/bin:$PATH" >> /etc/environment
		  #echo "LD_LIBRARY_PATH=/doocs/lib" >> /etc/environment   # correct solution should be implemented
		  mkdir -p /export/doocs/bin
		  cp /etc/environment /etc/environment.original
		  wget ${REPOSITORY_CONFIGS_ROOT}_etc_environment_desy -O /etc/environment
		  #echo "ENSHOST=doocsens1:doocsens2" >> /etc/environment
		  export ENSHOST=doocsens1:doocsens2
		  export PATH=/export/doocs/bin:$PATH

# 14. (p. 17)	Hotplugging should be activated
		  echo "Activate hot plugging manually if it is needed!"

# 15. (p. 18)	SOL should be activated
		  echo "Activate grub and LINUX SOL manually if hardware exists and needed!"

# 16.		All necessary users should be added, currently it is done manually, 
#		in alphabetical order. Later on should be done, using script
		  mkdir -p /export/doocs/.admin
		  mkdir -p /export/doocs/scripts
		  mkdir -p /export/doocs/server
		  mv /etc/bash.bashrc /etc/bash.bashrc.original 2>/dev/null || :
		  wget ${REPOSITORY_CONFIGS_ROOT}_etc_bash.bashrc -O /etc/bash.bashrc
		  wget ${REPOSITORY_CONFIGS_ROOT}.passwd_net_users -O /export/doocs/.admin/.passwd_net_users
		  wget ${REPOSITORY_CONFIGS_ROOT}.groups_net_users -O /export/doocs/.admin/.groups_net_users
		  wget ${REPOSITORY_SCRIPTS_ROOT}local_create_mtca_znaccount_prvt -O /export/doocs/.admin/local_create_mtca_znaccount_prvt
		  wget ${REPOSITORY_SCRIPTS_ROOT}conf -O /export/doocs/scripts/conf		  
		  chmod -R 770 /export/doocs/.admin
		  chmod a+x /export/doocs/scripts/conf
		  
		  /export/doocs/.admin/local_create_mtca_znaccount_prvt azatyan
		  /export/doocs/.admin/local_create_mtca_znaccount_prvt bagrat
		  /export/doocs/.admin/local_create_mtca_znaccount_prvt grygiel
		  /export/doocs/.admin/local_create_mtca_znaccount_prvt gut
		  /export/doocs/.admin/local_create_mtca_znaccount_prvt kalantar
		  /export/doocs/.admin/local_create_mtca_znaccount_prvt mdavid
		  /export/doocs/.admin/local_create_mtca_znaccount_prvt sweisse
		  /export/doocs/.admin/local_create_mtca_znaccount_prvt tonisch
		  /export/doocs/.admin/local_create_mtca_znaccount_prvt wkoehler
		  useradd -c "Doocs Admin" --home /export/home/doocsadm --gid 216 -m --shell /bin/bash --uid 995 doocsadm
		  mkdir -p /export/doocs/bin
		  mkdir -p /export/doocs/lib
		  mkdir -p /export/doocs/server
		  mkdir -p /local
		  
		  wget ${REPOSITORY_SCRIPTS_ROOT}doocs_zn_unix -O /export/doocs/server/doocs
		  
		  chown -R doocsadm:pitz /export/doocs
		  chmod -R 775 /export/doocs
		  chown -R root:adm /export/doocs/.admin
		  chmod -R 770 /export/doocs/.admin
		  chmod a+x /export/doocs/scripts/configure_bash
		  chmod a+x /export/doocs/server/doocs
		  chmod a+x /export/doocs/scripts/.bashrc
		  ln -s /export/doocs/lib /local/lib
		  mkdir -p /lib/modules/`uname -r`/amtca
		  
		  # Copy from web or compile on the host necessary drivers (minimum) wget https: ....
		  # Copy from web '/etc/init.d/amtca_drivers' # script to load minimum drivers
		  # /etc/init.d/amtca_drivers   # load them for first time
		  # ln -s /etc/init.d/amtca_drivers /etc/rc1.d/K90amtca_drivers
		  # ln -s /etc/init.d/amtca_drivers /etc/rc2.d/S90amtca_drivers
		  # ln -s /etc/init.d/amtca_drivers /etc/rc3.d/S90amtca_drivers
		  # ln -s /etc/init.d/amtca_drivers /etc/rc4.d/S90amtca_drivers
		  # ln -s /etc/init.d/amtca_drivers /etc/rc5.d/S90amtca_drivers
		  # ln -s /etc/init.d/amtca_drivers /etc/rc6.d/K90amtca_drivers
		  depmod -a
		  
		  # Copy from web '/etc/init.d/doocs_watchdog' # script to start doocs watchdog
		  # Copy watchdog server # or these last 2 lines should be done by debian package
		  # sudo scp kalantar@mtcapitzcpu3:/etc/udev/rules.d/10-mtcagen.rules .
		  # sudo scp -r kalantar@mtcapitzcpu3:/lib/modules/`uname -r`/amtca/binaries .

# 17.		Change owner of directory /export/doocs
		  chown doocsadm:pitz /export/doocs

# 18.		Configure repositories from Hamburg   # here there is an error, to be investigated
		  #wget -O - http://doocs.desy.de/pub/doocs/DESY-Debian-key.asc | apt-key add -
		  wget -O - http://doocs.desy.de/pub/doocs/DOOCS-key.gpg.asc | apt-key add -
		  echo "deb http://doocs.desy.de/pub/doocs `lsb_release -sc` main" > /etc/apt/sources.list.d/doocs.list
		  apt-get update

# 19.		Install watchdog server from Hamburg repository
		  #apt-get install doocs-watchdog-server
		  # other repositories from Hamburg

# 20.		Install qt, for qthardmon and friends
		  #sudo apt-get install qt5-default
		  
# 21.		/export/doocs/lib shoulb be set as known path
		  wget ${REPOSITORY_CONFIGS_ROOT}_etc_ld.so.d_doocs.conf -O /etc/ld.so.conf.d/doocs.conf
		  ldconfig
		  
# 22
		#mv /etc/bash.bashrc /etc/bash.bashrc.original 2>/dev/null || :
		#cp /export/doocs/scripts/.bashrc /etc/bash.bashrc   # This is from network

# new added commands (should work for ubuntu16)

#  1.	Backup original /etc/default/grub file by the name 
#	/etc/default/grub.backup
		apt-get update
		cp /etc/default/grub /etc/default/grub.original 2>/dev/null || :
		wget ${REPOSITORY_CONFIGS_ROOT}_etc_default_grub -O /etc/default/grub
		
		update-grub
		update-grub2
		  
# 2.	New line should be aded to the /etc/udev/rules.d/70-persistent-net.rules in order to force the driver to set 
#	predefined name (eth1)
		#CURRENT_INTERFACE_NAME=`ifconfig -a | grep -B1  "inet addr" | grep HWaddr | cut -d' ' -f 1`
		#INTERESTED_MAC_ADDRESS=`ifconfig -a | grep -B1  "inet addr" | grep HWaddr | cut -d' ' -f 7` # works for ubuntu16
		INTERESTED_MAC_ADDRESS=`ifconfig -a | grep -A2  "inet " | grep ether | cut -d' ' -f 10`
		echo 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="'$INTERESTED_MAC_ADDRESS'", ATTR{type}=="1", NAME="eth9"' > /etc/udev/rules.d/70-persistent-net.rules
		
# 3.	Get the proper /etc/network/interfaces file, then down current interface and start new
		#_etc_netplan_50-cloud-init.yaml__started_from_ubuntu18
		wget ${REPOSITORY_CONFIGS_ROOT}_etc_netplan_50-cloud-init.yaml__started_from_ubuntu18 -O /etc/netplan/50-cloud-init.yaml
		
		#cp /etc/network/interfaces /etc/network/interfaces.original 2>/dev/null || :
		#wget https://desycloud.desy.de/index.php/s/fAgu8KBTKedcsuJ/download && \
		#ifdown $CURRENT_INTERFACE_NAME && \
		#mv download /etc/network/interfaces && \
		#ifup eth1 && update-grub2 && sync && reboot
		#wget https://desycloud.desy.de/index.php/s/fAgu8KBTKedcsuJ/download && mv download /etc/network/interfaces && sync && reboot
		  
# 21.
		#sync
		#reboot
