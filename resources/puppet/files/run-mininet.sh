#!/bin/bash

### WEB GUI URL ###
# http://{ODL-IP-Address}:8181/dlux/index.html

## for Mininet
echo "feature:install odl-dlux-core odl-restconf odl-nsf-all odl-adsal-northbound odl-mdsal-apidocs odl-l2switch-switch" | ./bin/karaf
