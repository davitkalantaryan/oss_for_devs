#
# file:				oss_for_devs.pro  
# path:				workspaces/oss_for_devs_qt/oss_for_devs.pro
# created on:		2021 Mar 29
# 

TEMPLATE = subdirs
#CONFIG += ordered


#SUBDIRS		+=	$${PWD}/../../contrib/sl6/EmCalc/SL6/EmCalc-SL6.pro
#SUBDIRS		+=	$${PWD}/../../contrib/sl6/EmCont/SL6/EmCont-SL6.pro
#SUBDIRS		+=	$${PWD}/../../contrib/sl6/FastScan/SL6/FastScan-SL6.pro
#SUBDIRS		+=	$${PWD}/../../contrib/sl6/MemoryWatcher/SL6/MemoryWatcher-SL6.pro
#SUBDIRS		+=	$${PWD}/../../contrib/sl6/Null_project/EmCont.pro
#SUBDIRS		+=	$${PWD}/../../contrib/sl6/RootPlot/SL6/RootPlot-SL6.pro


OTHER_FILES +=	\
	$${PWD}/../../.gitattribues												\
	$${PWD}/../../.gitignore												\
	\
	$${PWD}/../../sys/Carbon/add_devtoolset.sh								\
	$${PWD}/../../sys/Carbon/local_create_mtca_znaccount_prvt				\
	$${PWD}/../../sys/Carbon/post_install_script.sh							\
	\
	$${PWD}/../../sys/Nitrogen/add_devtoolset.sh							\
	$${PWD}/../../sys/Nitrogen/post_install_script.sh						\
	\
	$${PWD}/../../sys/bionic/local_create_mtca_znaccount_prvt				\
	$${PWD}/../../sys/bionic/post_install_script.sh							\
	\
	$${PWD}/../../sys/desy_specific/CellAlias_Zn							\
	$${PWD}/../../sys/desy_specific/CellServDB								\
	$${PWD}/../../sys/desy_specific/ThisCell_Zn								\
