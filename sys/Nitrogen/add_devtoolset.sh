#!/bin/bash

# check if user is root
USER1=`id -nu`
if [ "${USER1}" != "root" ] ; then
	echo "!!! only root can start this script !!!"
	exit 1
fi

yum-config-manager --enable rhel-server-rhscl-7-rpms -y
yum install yum-conf-repos -y
yum install yum-conf-softwarecollections -y
yum install devtoolset-8 -y
export PATH=/opt/rh/devtoolset-8/root/usr/bin:${PATH}

# install nedit
wget https://rpmfind.net/linux/epel/7/x86_64/Packages/n/nedit-5.7-1.el7.x86_64.rpm
yum localinstall -y nedit-5.7-1.el7.x86_64.rpm
rm -f yum localinstall -y nedit-5.7-1.el7.x86_64.rpm

#install DOOCS
yum-config-manager --add-repo https://nexus-dev.zeuthen.desy.de/repository/ers-releases-yum/el7
yum install doocs-devel --nogpgcheck -y

#install TINE
yum-config-manager --add-repo https://nexus-dev.zeuthen.desy.de/repository/ers-releases-yum/noarch
yum install tine5c-devel --nogpgcheck -y
yum install tine-common-pitz --nogpgcheck -y
