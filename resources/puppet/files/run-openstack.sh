#!/bin/bash

### WEB GUI URL ###
# http://{ODL-IP-Address}:8181/dlux/index.html

## for OpenStack
echo "feature:install odl-ovsdb-openstack odl-ovsdb-northbound odl-restconf odl-mdsal-apidocs odl-adsal-all odl-adsal-northbound odl-dlux-core" | ./bin/karaf
