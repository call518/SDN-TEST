#!/bin/bash

if [ "`hostname`" == "opendaylight-mininet" ]; then
	echo
	echo -e " ======================================================================="
	echo -e "  [Install Feature] feature:install odl-dlux-core odl-restconf odl-nsf-all odl-adsal-northbound odl-mdsal-apidocs odl-l2switch-switch"
	echo -e "  [Web GUI URL] http://{ODL-IP-Address}:9191/dlux/index.html"
	echo -e " ======================================================================="
	echo -e "  Waiting.............."
elif [ "`hostname`" == "devstack-control" ]; then
	echo
	echo -e " ======================================================================="
	echo -e "  [Install Feature] feature:install odl-ovsdb-openstack odl-ovsdb-northbound odl-restconf odl-mdsal-apidocs odl-adsal-all odl-adsal-northbound odl-dlux-core"
	echo -e "  [Web GUI URL] http://{ODL-IP-Address}:8181/dlux/index.html"
	echo -e " ======================================================================="
	echo -e "  Waiting.............."
fi

#sleep 3

## for Mininet
./bin/karaf
