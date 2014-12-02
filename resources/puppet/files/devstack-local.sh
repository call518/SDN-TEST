#!/bin/bash

#sudo ovs-vsctl add-port br-ex eth3
sudo virsh net-destroy default
sudo virsh net-undefine default

exit 0
