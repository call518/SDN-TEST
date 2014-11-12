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

* Devstack-compute-1

* devstack-compute-2

* devstack-compute-3

* vxlan-router

* vxlan-server1

* vxlan-server2

# OpenDaylight /w Mininet

SDN Controller, OpenDaylight TESTing with Mininet

### Sample OpenDaylight Helium Web-UI

![OpenDaylight-Mininet-Web-UI](etc-files/opendaylihg-mininet-1.png)

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

![Mininet Tree Common](etc-files/tree.png)

* Custom Topologys

      `vm> cd /home/vagrant/topo-mininet`

# RouteFlow

RouteFlow, is an open source project to provide virtualized IP routing services over OpenFlow enabled hardware.

Home: https://sites.google.com/site/routeflow/home
Video: https://www.youtube.com/watch?v=YduxuBTyjEw

(Note) OpenFlow1.0 Based

### RouteFlow Design

![RouteFlow Design](etc-files/routeflow-design.png)

### Start Vagrant

`host> vagrant up routeflow`

### Architecture of Tutorial-2 Demo

RouteFlow Document: https://sites.google.com/site/routeflow/documents/tutorial2-four-routers-with-ospf

![RouteFlow Architecture of Tutorial-2](etc-files/setup-4sw.png)

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

      `vm> cd /home/vagrant/opendaylight`

      `vm> ./run.sh`

* Web-UI (OpenDaylight)

      Browser: `http://{Vagratn Host IP}:8080`
      Default ID/PW: `admin / admin`

### Run RouteFlow Tutorial-2

* Run RouteFlow

      `host> vagrant ssh routeflow`

      `vm> cd /home/vagrant/RouteFlow-Test/RouteFlow/rftest/`

      `vm> sudo ./rftest2`

* RouteFlow Web-UI

      `host> vagrant ssh routeflow`

      `vm> cd /home/vagrant/RouteFlow-Test/RouteFlow/rfweb`

      `vm> gunicorn -w 4 -b 0.0.0.0:8111 rfweb:application`

      Browser: `http://Vagrant Host IP}:8111/index.html`

### Run Mininet

* Run Mininet (Virtual Infra)

      `host> vagrant ssh routeflow`

      `vm> cd /home/vagrant/rf-topo-mininet/`

      `vm> sudo ./run-routeflow-infra.sh`

### RouteFlow Mapping Virtual-Router & Physical-Router

![RouteFlow Mapping](etc-files/routeflow-mapping.png)

### RouteFlow APPENDIX

* Tutorial-1 (rftest1)
  * https://github.com/CPqD/RouteFlow/wiki/Tutorial-1:-rftest1
* Tutorial-2 (rftest2)
  * https://github.com/CPqD/RouteFlow/wiki/Tutorial-2:-rftest2
* RouteFlow Web-UI Sample
![ScreenShot RF-Web](etc-files/rf_web.png)

# DevStack /w OpenDaylight

* (Note) *Order is important!*
* DevStack (Icehouse)
  * Controller/Network Node: 1 Host
  * Compute Node: 1 Host (Max: 3)
* OpenDaylight (Helium)

### Start Vagrant

1. `host> vagrant up devstack-control`
2. `host> vagrant up devstack-compute-1`

### Run Control/Network Node

      `host> vagrant ssh devstack-control`

      `vm> cd /home/vagrant/devstack`

      `vm> ./stack.sh

      Browser: `http://{Vagratn Host IP}`

### Run Compute-1 Node (also Compute-2, Compute-3)

      `host> vagrant ssh devstack-compute-1`

      `vm> cd /home/vagrant/devstack`

      `vm> ./stack.sh

# VXLAN /w OVS

* Configuration of VXLAN tunnel ports in OVS
* Configuration of OpenFlow entries OVS
* Logical separation of traffic between tenants
* Ref. http://www.youtube.com/watch?v=tnSkHhsLqpM

### Start Vagrant

(Note) *Order is important!*

1. `host> vagrant up vxlan-router`

2. `host> vagrant up vxlan-server1`

3. `host> vagrant up vxlan-server2`

### Underlay View

* Underlay: 192.168.1.0/24, 192.168.2.0/24
![VXLAN Underlay](etc-files/sdn-test-vxlan-underlay.png)

### Overlay View

* Overlay: 10.0.0.0/8 per Tenant
  * RED VNI: 100
  * BLUE VNI: 200
![VXLAN Overlay](etc-files/sdn-test-vxlan-overlay.png)

### vxlan-router

* Router Role, between 192.168.1.0/24 and 192.168.2.0/24

### vxlan-server1

* IP: 192.168.1.10
* RED, BLUE Network's Underlay for 2 VMs
  * 10.0.0.1/8 (VNI100-RED1)
  * 10.0.0.1/8 (VNI200-BLUE1)

#### Run vxlan-server1

* Command TXT File: /home/vagrant/topo-vxlan/vxlan-server1/cmd-server1.txt

      `cd /home/vagrant/topo-vxlan/vxlan-server1`

      `sudo mn --custom vxlan-server1.py --topo vxlan-server1`

      `mininet> sh ovs-vsctl add-port s1 vtep -- set interface vtep type=vxlan option:remote_ip=192.168.2.20 option:key=flow ofport_request=10`

      `mininet> sh ovs-vsctl show`

      `mininet> sh ovs-ofctl show s1`

      `mininet> sh ovs-ofctl add-flows s1 flows1.txt`

      `mininet> sh ovs-ofctl dump-flows s1`

      `mininet> red1 ping 10.0.0.1`

      `mininet> red1 ping 10.0.0.2`

      `mininet> blue1 ping 10.0.0.1`

      `mininet> blue1 ping 10.0.0.2`

* Appendix: flows1.txt

```
table=0,in_port=1,actions=set_field:100->tun_id,resubmit(,1)
table=0,in_port=2,actions=set_field:200->tun_id,resubmit(,1)
table=0,actions=resubmit(,1)

table=1,tun_id=100,dl_dst=00:00:00:00:00:01,actions=output:1
table=1,tun_id=200,dl_dst=00:00:00:00:00:01,actions=output:2
table=1,tun_id=100,dl_dst=00:00:00:00:00:02,actions=output:10
table=1,tun_id=200,dl_dst=00:00:00:00:00:02,actions=output:10
table=1,tun_id=100,arp,nw_dst=10.0.0.1,actions=output:1
table=1,tun_id=200,arp,nw_dst=10.0.0.1,actions=output:2
table=1,tun_id=100,arp,nw_dst=10.0.0.2,actions=output:10
table=1,tun_id=200,arp,nw_dst=10.0.0.2,actions=output:10
table=1,priority=100,actions=drop
```

### vxlan-server2

* IP: 192.168.2.20
* RED, BLUE Network's Underlay for 2 VMs
  * 10.0.0.2/8 (VNI100-RED2)
  * 10.0.0.2/8 (VNI200-BLUE2)

#### Run vxlan-server2

* Command TXT File: /home/vagrant/topo-vxlan/vxlan-server2/cmd-server2.txt

      `cd /home/vagrant/topo-vxlan/vxlan-server2`

      `sudo mn --custom vxlan-server2.py --topo vxlan-server2`

      `mininet> sh ovs-vsctl add-port s2 vtep -- set interface vtep type=vxlan option:remote_ip=192.168.1.10 option:key=flow ofport_request=10`

      `mininet> sh ovs-vsctl show`

      `mininet> sh ovs-ofctl show s2`

      `mininet> sh ovs-ofctl add-flows s2 flows2.txt`

      `mininet> sh ovs-ofctl dump-flows s2`

      `mininet> red2 ping 10.0.0.1`

      `mininet> red2 ping 10.0.0.2`

      `mininet> blue2 ping 10.0.0.1`

      `mininet> blue2 ping 10.0.0.2`

* Appendix: flows2.txt

```
table=0,in_port=1,actions=set_field:100->tun_id,resubmit(,1)
table=0,in_port=2,actions=set_field:200->tun_id,resubmit(,1)
table=0,actions=resubmit(,1)

table=1,tun_id=100,dl_dst=00:00:00:00:00:01,actions=output:10
table=1,tun_id=200,dl_dst=00:00:00:00:00:01,actions=output:10
table=1,tun_id=100,dl_dst=00:00:00:00:00:02,actions=output:1
table=1,tun_id=200,dl_dst=00:00:00:00:00:02,actions=output:2
table=1,tun_id=100,arp,nw_dst=10.0.0.1,actions=output:10
table=1,tun_id=200,arp,nw_dst=10.0.0.1,actions=output:10
table=1,tun_id=100,arp,nw_dst=10.0.0.2,actions=output:1
table=1,tun_id=200,arp,nw_dst=10.0.0.2,actions=output:2
table=1,priority=100,actions=drop
```

# Refrences

https://github.com/opendaylight/ovsdb/blob/master/README.Vagrant
