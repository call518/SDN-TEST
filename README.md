# Description

*SDN Test Suite*

# Intro

Vagrant-based SDN Test Suite.

 * OpenDaylight /w Mininet
 * RouteFlow
 * VXLAN /w OVS

# OpenDaylight /w Mininet

SDN Controller, OpenDaylight TESTing with Mininet

### Components of VM

 * OpenDaylight(Helium)
 * Mininet 2.1.x
 * Wireshark /w OF Plugin

### Run OpenDaylight (Helium Pre-Built Binary)

 * Run ODL

      `cd /home/vagrant/opendaylight`

      `./run-mininet.sh`

      `karaf> feature:install odl-dlux-core odl-restconf odl-nsf-all odl-adsal-northbound odl-mdsal-apidocs odl-l2switch-switch`

 * Web-UI

      Browser: `http://{Vagrant Host IP}:8181/dlux/index.html`

### Run Mininet

 * Common Topology

      `sudo mn --controller remote,ip=127.0.0.1,port=6633 --switch ovsk --topo tree,3`

![Compute and Network...](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/tree.png)

 * Custom Topology

      `cd /home/vagrant/topo-mininet`

# RouteFlow

RouteFlow, is an open source project to provide virtualized IP routing services over OpenFlow enabled hardware.

Home: https://sites.google.com/site/routeflow/home
Video: https://www.youtube.com/watch?v=YduxuBTyjEw

(Note) OpenFlow1.0 Based

### Architecture of Demo

![Compute and Network...](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/setup-4sw.png)

### Components of VM

 * RouteFlow
 * OpenDaylight(Built Hydrogen) & RFProxy(for ODL)
 * Mininet
 * NOX(Default: Disabled)
   * `/home/vagrant/RouteFlow-Test/RouteFlow/rftest/rftest2`
 * LXC Container (for Simulation Quagga's OSPF, BGP, RIP)

### Run OpenDaylight (Hydrogen)

 * Run ODL

      `cd /home/vagrant/opendaylight`

      `./run.sh`

 * ODL Web-UI

      Browser: `http://{Vagratn Host IP}:8080`

### Run RouteFlow Tutorial-2

  * Run RouteFlow

      `cd /home/vagrant/RouteFlow-Test/RouteFlow/rftest/`

      `sudo ./rftest2`

  * RouteFlow Web-UI

      `cd /home/vagrant/RouteFlow-Test/RouteFlow/rfweb`

      `gunicorn -w 4 -b 0.0.0.0:8111 rfweb:application`

      Browser: `http://Vagrant Host IP}:8111/index.html`

![Compute and Network...](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/rf_web.png)

### Run Mininet

  * Run Mininet (Virtual Infra)

      `cd /home/vagrant/rf-topo-mininet/`

      `sudo ./run-routeflow-infra.sh`

# VXLAN /w OVS

