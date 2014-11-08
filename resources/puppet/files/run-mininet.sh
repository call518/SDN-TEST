#!/bin/bash

echo
echo -e " ======================================================================="
echo -e "  [Install Feature] feature:install odl-dlux-core odl-restconf odl-nsf-all odl-adsal-northbound odl-mdsal-apidocs odl-l2switch-switch"
echo -e "  [Web GUI URL] http://{ODL-IP-Address}:9191/dlux/index.html"
echo -e " ======================================================================="
echo -e "  Waiting.............."

#sleep 3

## for Mininet
./bin/karaf
