# Description

SDN Test Suite

# Intro

### Vagrant-based SDN Test Suite.

 * OpenDaylight /w Mininet
 * RouteFlow
 * VXLAN /w OVS

### Vagrant VMs

 * opendaylight-mininet

 * routeflow

 * devstack-control

 * devstack-compute-1

 * devstack-compute-2

 * devstack-compute-3

 * vxlan_router

 * vxlan_server1

 * vxlan_server2

# OpenDaylight /w Mininet

SDN Controller, OpenDaylight TESTing with Mininet

### Sample OpenDaylight Web-UI

![OpenDaylight-Mininet-Web-UI](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/opendaylihg-mininet-1.png)

### Start Vagrant

`host> vagrant up opendaylight-mininet`

### Components of VM

 * OpenDaylight(Helium)
 * Mininet 2.1.x
 * Wireshark /w OF Plugin

### Run OpenDaylight (Helium Pre-Built Binary)

 * Run OpenDaylight

      `host> vagrant ssh opendaylight-mininet`

      `vm> cd /home/vagrant/opendaylight-mininet`

      `vm> ./run-mininet.sh`

      `opendaylight-user@root> feature:install odl-dlux-core odl-restconf odl-nsf-all odl-adsal-northbound odl-mdsal-apidocs odl-l2switch-switch`

 * Web-UI

      Browser: `http://{Vagrant Host IP}:8181/dlux/index.html`
      Default ID/PW: `admin / admin`

### Run Mininet

 * Common Topology

      `host> vagrant ssh opendaylight-mininet`

      `vm> sudo mn --controller remote,ip=127.0.0.1,port=6633 --switch ovsk --topo tree,3`

![Mininet Tree_Common](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/tree.png)

 * Custom Topologys

      `vm> cd /home/vagrant/topo-mininet`

# RouteFlow

RouteFlow, is an open source project to provide virtualized IP routing services over OpenFlow enabled hardware.

Home: https://sites.google.com/site/routeflow/home
Video: https://www.youtube.com/watch?v=YduxuBTyjEw

(Note) OpenFlow1.0 Based

### Start Vagrant

`host> vagrant up routeflow`

### Architecture of Demo

RouteFlow Document: https://sites.google.com/site/routeflow/documents/tutorial2-four-routers-with-ospf

![RouteFlow Architecture of Tutorial-2](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/setup-4sw.png)

### Components of VM

 * RouteFlow
 * OpenDaylight(Built Hydrogen) & RFProxy(for OpenDaylight)
 * Mininet
 * NOX(Default: Disabled)
   * `/home/vagrant/RouteFlow-Test/RouteFlow/rftest/rftest2`
 * LXC Container (for Simulation Quagga's OSPF, BGP, RIP)

### Run OpenDaylight (Hydrogen)

 * Run OpenDaylight

      `host> vagrant ssh routeflow`

      `cd /home/vagrant/opendaylight`

      `./run.sh`

 * Web-UI (OpenDaylight)

      Browser: `http://{Vagratn Host IP}:8080`
      Default ID/PW: `admin / admin`

### Run RouteFlow Tutorial-2

  * Run RouteFlow

      `host> vagrant ssh routeflow`

      `cd /home/vagrant/RouteFlow-Test/RouteFlow/rftest/`

      `sudo ./rftest2`

  * RouteFlow Web-UI

      `cd /home/vagrant/RouteFlow-Test/RouteFlow/rfweb`

      `gunicorn -w 4 -b 0.0.0.0:8111 rfweb:application`

      Browser: `http://Vagrant Host IP}:8111/index.html`

### APPENDIX

  * Tutorial-1 (rftest1)
    * https://github.com/CPqD/RouteFlow/wiki/Tutorial-1:-rftest1
  * Tutorial-2 (rftest2)
    * https://github.com/CPqD/RouteFlow/wiki/Tutorial-2:-rftest2

![ScreenShot RF-Web](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/rf_web.png)

### Run Mininet

  * Run Mininet (Virtual Infra)

      `host> vagrant ssh routeflow`

      `cd /home/vagrant/rf-topo-mininet/`

      `sudo ./run-routeflow-infra.sh`

# DevStack /w OpenDaylight

 * DevStack (Icehouse)
   * Controller/Network Node: 1 Host
   * Compute Node: 1 Host (Max: 3)
 * OpenDaylight (Helium)

### Start Vagrant

1. `host> vagrant up devstack-control`
2. `host> vagrant up devstack-compute-1`

### Run Control/Network Node

### Run Compute-1 Node

# VXLAN /w OVS

 * Configuration of VXLAN tunnel ports in OVS
 * Configuration of OpenFlow entries OVS
 * Logical separation of traffic between tenants

### Start Vagrant

(Note) *Order is important!*

1. `host> vagrant up vxlan-router`

2. `host> vagrant up vxlan-server1`

3. `host> vagrant up vxlan-server2`

### Underlay

![VXLAN Underlay](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/sdn-test-vxlan-underlay.png)

### Overlay

![VXLAN Overlay](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/sdn-test-vxlan-overlay.png)
