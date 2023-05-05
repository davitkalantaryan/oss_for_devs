#
# file:				oss_for_devs.pro  
# path:				workspaces/oss_for_devs_qt/oss_for_devs.pro
# created on:		2021 Mar 29
# 

TEMPLATE = subdirs
#CONFIG += ordered


repositoryRoot = $${PWD}/../..


OTHER_FILES += $$files($${repositoryRoot}/.github/*.yml,true)
OTHER_FILES += $$files($${repositoryRoot}/sys/*.sh,true)
OTHER_FILES += $$files($${repositoryRoot}/docs/*.txt,true)

OTHER_FILES +=	\
	$${repositoryRoot}/.gitattribues										\
	$${repositoryRoot}/.gitignore											\
	$${PWD}/../../sys/Carbon/local_create_mtca_znaccount_prvt				\
	$${PWD}/../../sys/bionic/local_create_mtca_znaccount_prvt				\
	$${PWD}/../../sys/desy_specific/CellAlias_Zn							\
	$${PWD}/../../sys/desy_specific/CellServDB								\
	$${PWD}/../../sys/desy_specific/ThisCell_Zn								
