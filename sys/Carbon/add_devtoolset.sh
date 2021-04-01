#!/bin/bash

# check if user is root
USER1=`id -nu`
if [ "${USER1}" != "root" ] ; then
	echo "!!! only root can start this script !!!"
	exit 1
fi

yum-config-manager --enable rhel-server-rhscl-6-rpms -y
yum install "http://ftp.scientificlinux.org/linux/scientific/6/external_products/softwarecollections/yum-conf-softwarecollections-2.0-1.el6.noarch.rpm" -y
yum install devtoolset-8 -y
export PATH=/opt/rh/devtoolset-8/root/usr/bin:${PATH}
