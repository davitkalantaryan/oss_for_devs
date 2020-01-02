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

function sendtocloud()
{
	local finalPath=${cloutRepositoryBase}/${2}
	echo "Uploading sys/Carbon/"$1 " to " ${finalPath} 
	curl --progress-bar -u $userName2:$password2 -T ${sourceDirectoryPath}/${1}	${finalPath} | tee /dev/null
	#curl --progress-bar -u $userName2:$password2 -T ${sourceDirectoryPath}/${1}	${finalPath} 1>/dev/null
	#echo "return="$?
}


# SL6 Carbon (be aware, SL6 also can have code name Santiago)
sendtocloud sys/Carbon/post_install_script.sh 			sys/Carbon/post_install_script.sh
sendtocloud sys/Carbon/local_create_mtca_znaccount_prvt		sys/Carbon/scripts/local_create_mtca_znaccount_prvt
sendtocloud sys/desy_specific/CellAlias_Zn 			sys/Carbon/configs/CellAlias
sendtocloud sys/desy_specific/CellServDB			sys/Carbon/configs/CellServDB
sendtocloud sys/desy_specific/ThisCell_Zn			sys/Carbon/configs/ThisCell

# ubuntu18 (bionic)
sendtocloud sys/bionic/post_install_script.sh 			sys/bionic/post_install_script.sh
sendtocloud sys/bionic/local_create_mtca_znaccount_prvt 	sys/bionic/scripts/local_create_mtca_znaccount_prvt
