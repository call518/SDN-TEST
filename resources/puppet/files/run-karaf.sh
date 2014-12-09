#!/bin/bash

if [ `hostname | egrep -c "opendaylight-mininet-1|opendaylight-mininet-1"` -ne 0 ]; then
	echo
	echo -e " ======================================================================="
	echo -e "  [e.g.) for OVS] > feature:install odl-dlux-core odl-restconf odl-nsf-all odl-adsal-northbound odl-mdsal-apidocs odl-l2switch-switch odl-l2switch-hosttracker odl-l2switch-addresstracker"
	echo -e "  [e.g.) for VTN] > feature:install odl-adsal-compatibility-all odl-openflowplugin-all odl-vtn-manager-all odl-dlux-core odl-l2switch-hosttracker odl-l2switch-addresstracker"
	echo -e "  [e.g.) for CBench] > feature:install odl-openflowplugin-flow-services odl-openflowplugin-drop-test odl-l2switch-hosttracker odl-l2switch-addresstracker"
	echo -e "                     > (dropAllPacketsRpc on / dropAllPackets on)"
	echo -e "  [Web GUI URL] http://{Vagrant Host IP}:8181/dlux/index.html"
	echo -e " ======================================================================="
	echo -e "  Waiting.............."
elif [ "`hostname`" == "devstack-control" ]; then
	echo
	echo -e " ======================================================================="
	echo -e "  [e.g.) for ML2/OVSDB] > feature:install odl-ovsdb-openstack odl-ovsdb-northbound odl-restconf odl-mdsal-apidocs odl-adsal-all odl-adsal-northbound odl-dlux-core odl-l2switch-hosttracker odl-l2switch-addresstracker"
	echo -e "  [Web GUI URL] http://{Vagrant Host IP}:8181/dlux/index.html"
	echo -e " ======================================================================="
	echo -e "  Waiting.............."
fi

#sleep 3

./bin/karaf clean
