#!/bin/bash

echo
echo -e " ======================================================================="
echo -e "  [Install Feature] feature:install odl-ovsdb-openstack odl-ovsdb-northbound odl-restconf odl-mdsal-apidocs odl-adsal-all odl-adsal-northbound odl-dlux-core"
echo -e "  [Web GUI URL] http://{ODL-IP-Address}:8181/dlux/index.html"
echo -e " ======================================================================="
echo

sleep 3

./bin/karaf
