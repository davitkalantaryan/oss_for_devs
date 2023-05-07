# the location of this file is '/etc/profile.d'

if [ -z "${VAR}" ]; then
	source /opt/rh/devtoolset-10/enable
else
	PKG_CONFIG_PATH_TEMPORAR=$PKG_CONFIG_PATH
	source /opt/rh/devtoolset-10/enable
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PKG_CONFIG_PATH_TEMPORAR
fi

