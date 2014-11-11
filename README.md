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

 * Run ODL Helium

      `cd /home/vagrant/opendaylight`

      `./run-mininet.sh`

      `karaf> feature:install odl-dlux-core odl-restconf odl-nsf-all odl-adsal-northbound odl-mdsal-apidocs odl-l2switch-switch`

 * Web-UI

      Browser `http://{Vagrant Host IP}:8181/dlux/index.html`

### Run Mininet

 * Common Topology

      `sudo mn --controller remote,ip=127.0.0.1,port=6633 --switch ovsk --topo tree,3`

![Compute and Network...](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/tree.png)

 * Custom Topology

      `cd /home/vagrant/topo-mininet`

# RouteFlow

RouteFlow, is an open source project to provide virtualized IP routing services over OpenFlow enabled hardware.

https://sites.google.com/site/routeflow/home

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

 * Run ODL Hydrogen

      `cd /home/vagrant/opendaylight`

      `./run.sh`

 * Web-UI

      Browser `http://{Vagratn Host IP}:8080`

### Run RouteFlow Demo

  * Run RouteFlow Tutorial-2

      `cd /home/vagrant/RouteFlow-Test/RouteFlow/rftest/`

      `sudo ./rftest2`

### Run Mininet

  * Run Mininet (Virtual Infra)

      `cd /home/vagrant/rf-topo-mininet/`

      `sudo ./run-routeflow-infra.sh`

# VXLAN /w OVS

