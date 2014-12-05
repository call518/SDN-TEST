#!/bin/bash

sudo ovs-vsctl add-port br-ex eth3
sudo virsh net-destroy default
sudo virsh net-undefine default
neutron router-interface-delete router1 `neutron net-show private | awk '{if (NR == 13) {print $4}}'`
neutron net-delete private
neutron router-delete router1
sudo ip netns del `sudo ip netns | grep "^qrouter"`
keystone tenant-delete demo

exit 0
