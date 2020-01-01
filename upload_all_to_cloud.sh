##!bash 
# 
# File:					upload_all_to_cloud.sh  
# Created by:			Davit Kalantaryan (davit.kalantaryan@desy.de)  
# Created on:			2019 Dec 31  
# Purpose:				To update files on cloud based on repository files  
# Number of arguments:	[0-2]
# Description:
#						Script accepts 0 to 3 arguments, all arguments are 
#						positional arguments. In the case if provided the meaning of arguments are following:
#							@1 Username to use to connect to cloud
#							@2 Password to use for connection to cloud
#

#sourcePath=`bash -c echo ${BASH_SOURCE[0]}`
sourcePath=${0}
cloutRepositoryBase=https://desycloud.desy.de/remote.php/webdav/oss_for_devs

if [ "$#" -gt 0 ]; then
	userName2=$1
else
	userName2=`id -nu`
fi

if [ "$#" -gt 1 ]; then
	password2=$2
else
	read -s -p "$userName2 Password:" password2
	echo ""
fi
#echo "Username:Password=["$userName2":"$password2"]"

currentDirectory=`pwd`
sourceDirectoryPathBase=`dirname ${sourcePath}`
baseName=`basename ${sourcePath}`

cd ${sourceDirectoryPathBase}
fileOrigin=`readlink ${baseName}`
if [ ! -z "$fileOrigin" ]; then
	relativeSourceDir=`dirname ${fileOrigin}`
	cd ${relativeSourceDir}
fi
# after this steps we finally landed to the script original directory 
sourceDirectoryPath=`pwd`
cd ${currentDirectory}

#echo "curDir="$currentDirectory " sourceDirPathBase="$sourceDirectoryPathBase " sourceDirPath="$sourceDirectoryPath " baseName="$baseName " fileOrigin="$fileOrigin
#exit 0

# SL6 Carbon (be aware, SL6 also can have code name Santiago)
curl -u $userName2:$password2 -T ${sourceDirectoryPath}/sys/Carbon/post_install_script.sh				${cloutRepositoryBase}/sys/Carbon/post_install_script.sh
curl -u $userName2:$password2 -T ${sourceDirectoryPath}/sys/Carbon/local_create_mtca_znaccount_prvt		${cloutRepositoryBase}/sys/Carbon/scripts/local_create_mtca_znaccount_prvt
curl -u $userName2:$password2 -T ${sourceDirectoryPath}/sys/desy_specific/CellAlias_Zn					${cloutRepositoryBase}/sys/Carbon/configs/CellAlias
curl -u $userName2:$password2 -T ${sourceDirectoryPath}/sys/desy_specific/CellServDB					${cloutRepositoryBase}/sys/Carbon/configs/CellServDB
curl -u $userName2:$password2 -T ${sourceDirectoryPath}/sys/desy_specific/ThisCell_Zn					${cloutRepositoryBase}/sys/Carbon/configs/ThisCell

# ubuntu18 (bionic)
curl -u $userName2:$password2 -T ${sourceDirectoryPath}/sys/bionic/post_install_script.sh				${cloutRepositoryBase}/sys/bionic/post_install_script.sh
curl -u $userName2:$password2 -T ${sourceDirectoryPath}/sys/bionic/local_create_mtca_znaccount_prvt		${cloutRepositoryBase}/sys/bionic/scripts/local_create_mtca_znaccount_prvt
