#!/bin/bash
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=512m"
### Build RFProxy
cd /home/vagrant/RouteFlow-Test/opendaylight-with-rfproxy/opendaylight
mvn clean -q install -DskipTests -e
### Build ODL
cd /home/vagrant/RouteFlow-Test/opendaylight-with-rfproxy/opendaylight/distribution/opendaylight/
mvn clean -q install -DskipTests  -Dmaven.compile.fork=true
