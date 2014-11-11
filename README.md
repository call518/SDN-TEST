# Description

*SDN Test Suite*

# Intro

Vagrant-based SDN Test Suite.

 * OpenDaylight /w Mininet
 * RouteFlow
 * VXLAN /w OVS

# RouteFlow

RouteFlow, is an open source project to provide virtualized IP routing services over OpenFlow enabled hardware.

https://sites.google.com/site/routeflow/home

### Architecture of TEST

![Compute and Network...](https://gitlab.com/call518/sdn-test/raw/master/README.md.files/setup-4sw.png)

### Components of "routeflow" VM

* RouteFlow
* OpenDaylight(Built Hydrogen) & RFProxy(for ODL)
* Mininet

### Public Network

1. Load Balancing
  * Load Balancing by Unlimited VRs (Virtual Routers)
  * Scale-Out
  * Load balanced Inbound & Outbound Traffic
2. High Availability
  * HA by Unlimited VRs
3. Traffic Engineering
  * Save of Network Bandwidth
  * Low latency
4. VM Migration

### Private Network

1. A large number of tenants
  * A large number of VLANs
  * Traffic Isolation by VXLAN (16,777,216)
2. Large layer 2 network
  * VxLAN: Multicast instead of Broadcast
  * VxLAN: Decrease in MAC Flooding
  * Controller: Eliminate Broadcast
3. No added central server & H/W
4. Cost & Scalability

# Movies

[PoC Demo](https://docs.google.com/file/d/0B_p_P2odDTXARElKZ3ZZSmFRbGM/edit)

# Concept

### Introduction of EYWA

![Introduction of EYWA](https://gitlab.com/call518/eywa-on-opennebula/raw/master/assets/introduction_of_eywa.png)

### Guest Virtual Network of EYWA

![Guest Virtual Network of EYWA](https://gitlab.com/call518/eywa-on-opennebula/raw/master/assets/guest_virtual_network_of_eywa.png)

### Architecture of EYWA

![Architecture of EYWA](https://gitlab.com/call518/eywa-on-opennebula/raw/master/assets/architecture_of_eywa.png)

# More Information

[Gitlab Wiki Home](https://gitlab.com/call518/eywa-on-opennebula/wikis/home)

[Limitation of Cloud Networking (SlideShare)](http://www.slideshare.net/baramdori/eywa-virtual-network-model-for-full-ha-and-lb20140204-v04)

### EYWA-Controller

* [Notice] It is in developing. Current version(GitLab) is purpose for PoC

# How To

* [How to Configure Eywa With Opennebula](https://gitlab.com/call518/eywa-on-opennebula/wikis/howto-configure-eywa-with-opennebula)
