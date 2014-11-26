# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #config.vm.boot_timeout = 600
  #config.vm.provider :virtualbox do |vb|
  #  vb.gui = true
  #end

  config.ssh.forward_x11 = true

  #config.vm.box = "precise64"
  #config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
  #config.vm.box_url = "https://plink.ucloud.com/public_link/link/a15d4c1ca008d431"

  #config.vm.box = "trusty64"
  #config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  #config.vm.box_url = "https://plink.ucloud.com/public_link/link/a7941f067ddd8aa3"

  #control.vm.box = "CentOS-6.5-x86_64"
  #control.vm.box_url = "https://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.5-x86_64-v20140504.box"
  #control.vm.box_url = "https://plink.ucloud.com/public_link/link/8a93d1a50f2aeaf2"

  #control.vm.box = "Fedora20-x86_64"
  #control.vm.box_url = "https://plink.ucloud.com/public_link/link/8690378de1d34f24"

  #control.vm.box = "Fedora19-x86_64"
  #control.vm.box_url = "https://plink.ucloud.com/public_link/link/85d911a7137d3429"

  ### Do not use ### 
  #config.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
  ##config.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
  #config.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
  #config.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"

  #config.vm.provision "puppet" do |puppet|
  #    puppet.working_directory = "/vagrant/resources/puppet"
  #    puppet.hiera_config_path = "resources/puppet/hiera.yaml"
  #    puppet.manifests_path = "resources/puppet/manifests"
  #    puppet.manifest_file  = "base.pp"
  #end

#################################################################################################################
############## VTN Coordinator / OpenDaylight / Mininet / RouteFlow #############################################
#################################################################################################################

  ## VTN Coordinator
  config.vm.define "vtn-coordinator" do |vtn_coordinator|
    #vtn_coordinator.vm.box = "Fedora19-x86_64"
    #vtn_coordinator.vm.box_url = "https://plink.ucloud.com/public_link/link/85d911a7137d3429"
    vtn_coordinator.vm.box = "Fedora20-x86_64"
    vtn_coordinator.vm.box_url = "https://plink.ucloud.com/public_link/link/8690378de1d34f24"
    vtn_coordinator.vm.hostname = "vtn-coordinator"
    vtn_coordinator.vm.network "private_network", ip: "192.168.40.10"
    vtn_coordinator.vm.network "forwarded_port", guest: 8083, host: 8083
    vtn_coordinator.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
    end
    #vtn_coordinator.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    #vtn_coordinator.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    #vtn_coordinator.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    vtn_coordinator.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    vtn_coordinator.vm.provision "shell", inline: <<-SCRIPT
      route add -net 192.168.41.0/24 p7p1 2> /dev/null; echo "route add -net 192.168.41.0/24 p7p1"
      route add -net 192.168.42.0/24 p7p1 2> /dev/null; echo "route add -net 192.168.42.0/24 p7p1"
    SCRIPT
    vtn_coordinator.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = "--verbose"
    end
    vtn_coordinator.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "vtn-coordinator.pp"
      puppet.facter = {
        #"odl_dist_name" => "Hydrogen-Virtualization"
        #"odl_dist_name" => "Hydrogen-SP"
        #"odl_dist_name" => "Helium"
        "odl_dist_name" => "Helium-SR1"
      }
      puppet.options = "--verbose"
    end
  end

  ## OpenDaylight & Mininet (1)
  config.vm.define "opendaylight-mininet-1" do |opendaylight_mininet_1|
    opendaylight_mininet_1.vm.box = "trusty64"
    #opendaylight_mininet_1.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
    opendaylight_mininet_1.vm.box_url = "https://plink.ucloud.com/public_link/link/a7941f067ddd8aa3"
    opendaylight_mininet_1.vm.hostname = "opendaylight-mininet-1"
    opendaylight_mininet_1.vm.network "private_network", ip: "192.168.41.10"
    opendaylight_mininet_1.vm.network "forwarded_port", guest: 8080, host: 9191
    opendaylight_mininet_1.vm.network "forwarded_port", guest: 8181, host: 8181
    opendaylight_mininet_1.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "4"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
    end
    opendaylight_mininet_1.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    opendaylight_mininet_1.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    opendaylight_mininet_1.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    opendaylight_mininet_1.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    opendaylight_mininet_1.vm.provision "shell", inline: <<-SCRIPT
      route add -net 192.168.40.0/24 eth1 2> /dev/null; echo "route add -net 192.168.40.0/24 eth1"
      route add -net 192.168.42.0/24 eth1 2> /dev/null; echo "route add -net 192.168.42.0/24 eth1"
    SCRIPT
    opendaylight_mininet_1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = "--verbose"
    end
    opendaylight_mininet_1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "opendaylight.pp"
      puppet.facter = {
        #"odl_dist_name" => "Hydrogen-Virtualization"
        #"odl_dist_name" => "Hydrogen-SP"
        #"odl_dist_name" => "Helium"
        "odl_dist_name" => "Helium-SR1"
      }
      puppet.options = "--verbose"
    end
    opendaylight_mininet_1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininet.pp"
      puppet.options = "--verbose"
    end
    opendaylight_mininet_1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininext.pp"
      puppet.options = "--verbose"
    end
  end

  ## OpenDaylight & Mininet (2)
  config.vm.define "opendaylight-mininet-2" do |opendaylight_mininet_2|
    opendaylight_mininet_2.vm.box = "trusty64"
    #opendaylight_mininet_2.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
    opendaylight_mininet_2.vm.box_url = "https://plink.ucloud.com/public_link/link/a7941f067ddd8aa3"
    opendaylight_mininet_2.vm.hostname = "opendaylight-mininet-2"
    opendaylight_mininet_2.vm.network "private_network", ip: "192.168.42.10"
    opendaylight_mininet_2.vm.network "forwarded_port", guest: 8080, host: 9292
    opendaylight_mininet_2.vm.network "forwarded_port", guest: 8181, host: 8282
    opendaylight_mininet_2.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "4"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
    end
    opendaylight_mininet_2.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    opendaylight_mininet_2.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    opendaylight_mininet_2.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    opendaylight_mininet_2.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    opendaylight_mininet_2.vm.provision "shell", inline: <<-SCRIPT
      route add -net 192.168.40.0/24 eth1 2> /dev/null; echo "route add -net 192.168.40.0/24 eth1"
      route add -net 192.168.41.0/24 eth1 2> /dev/null; echo "route add -net 192.168.41.0/24 eth1"
    SCRIPT
    opendaylight_mininet_2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = "--verbose"
    end
    opendaylight_mininet_2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "opendaylight.pp"
      puppet.facter = {
        #"odl_dist_name" => "Hydrogen-Virtualization"
        #"odl_dist_name" => "Hydrogen-SP"
        #"odl_dist_name" => "Helium"
        "odl_dist_name" => "Helium-SR1"
      }
      puppet.options = "--verbose"
    end
    opendaylight_mininet_2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininet.pp"
      puppet.options = "--verbose"
    end
    opendaylight_mininet_2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininext.pp"
      puppet.options = "--verbose"
    end
  end

  ## RouteFlow & OpenDaylight(Source) & Mininet
  config.vm.define "routeflow" do |routeflow|
    routeflow.vm.box = "precise64"
    #routeflow.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
    routeflow.vm.box_url = "https://plink.ucloud.com/public_link/link/a15d4c1ca008d431"
    routeflow.vm.hostname = "routeflow"
    routeflow.vm.network "private_network", ip: "192.168.30.10"
    routeflow.vm.network "forwarded_port", guest: 8080, host: 8080
    routeflow.vm.network "forwarded_port", guest: 8111, host: 8111
    routeflow.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "4"]
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      #vb.customize ["modifyvm", :id, "--vrde", "on"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
    end
    routeflow.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    routeflow.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    routeflow.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    routeflow.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    routeflow.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-routeflow.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = "--verbose"
    end
    routeflow.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-routeflow.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "routeflow.pp"
      puppet.options = "--verbose"
    end
    routeflow.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-routeflow.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininet.pp"
      puppet.options = "--verbose"
    end
  end

#################################################################################################################
############## DevStack / OpenDaylight ##########################################################################
#################################################################################################################

  ## ip pre-configuration
  control_ip = "192.168.50.10" ## DevStack Controller Node
  #num_compute_nodes = (ENV['DEVSTACK_NUM_COMPUTE_NODES'] || 1).to_i
  num_compute_nodes = 3 # (Max: 3)
  compute_ip_base = "192.168.50." ## DevStac Compute Nodes
  compute_ips = num_compute_nodes.times.collect { |n| compute_ip_base + "#{n+21}" }

  ## Devstack Control Node
  config.vm.define "devstack-control" do |control|
    control.vm.box = "trusty64"
    #control.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    control.vm.box_url = "https://plink.ucloud.com/public_link/link/a7941f067ddd8aa3"
    control.vm.hostname = "devstack-control"
    control.vm.network "private_network", ip: "#{control_ip}"
    control.vm.network "forwarded_port", guest: 8080, host: 8080 # ODL API URL (http://loclahost:8080)
    control.vm.network "forwarded_port", guest: 8181, host: 8181 # ODL GUI URL (http://localhost:8181/dlux/index.html)
    control.vm.network "forwarded_port", guest: 80, host: 80 # DevStack CTL (http://localhost)
    #control.vm.network "forwarded_port", guest: 6080, host: 6080
    control.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "4"]
      #vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--memory", "3072"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
    end
    control.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    control.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    control.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    control.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    control.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = "--verbose"
    end
    control.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "opendaylight.pp"
      puppet.options = "--verbose"
    end
    control.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "devstack-control.pp"
      puppet.options = "--verbose"
    end
  end

  ## Devstack Compute Nodes
  num_compute_nodes.times do |n|
    config.vm.define "devstack-compute-#{n+1}" do |compute|
      compute_ip = compute_ips[n]
      compute_index = n+1
      compute.vm.box = "trusty64"
      #compute.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      compute.vm.box_url = "https://plink.ucloud.com/public_link/link/a7941f067ddd8aa3"
      compute.vm.hostname = "devstack-compute-#{compute_index}"
      compute.vm.network "private_network", ip: "#{compute_ip}"
      #compute.vm.network "forwarded_port", guest: 6080, host: 6080
      compute.vm.provider :virtualbox do |vb|
        #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
        vb.customize ["modifyvm", :id, "--cpus", "4"]
        vb.customize ["modifyvm", :id, "--memory", "1024"]
        #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
        #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
      end
      compute.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
      compute.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
      compute.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
      compute.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
      compute.vm.provision "puppet" do |puppet|
        puppet.working_directory = "/vagrant/resources/puppet"
        puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
        puppet.manifests_path = "resources/puppet/manifests"
        puppet.manifest_file  = "base.pp"
        puppet.options = "--verbose"
      end
      compute.vm.provision "puppet" do |puppet|
        puppet.working_directory = "/vagrant/resources/puppet"
        puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
        puppet.manifests_path = "resources/puppet/manifests"
        puppet.manifest_file  = "devstack-compute.pp"
        puppet.options = "--verbose"
      end
    end
  end

#################################################################################################################
############## VXLAN / OVS ######################################################################################
#################################################################################################################

  ## VXLAN - Router (Must be deploy first)
  config.vm.define "vxlan-router" do |vxlan_router|
    vxlan_router.vm.box = "trusty64"
    #vxlan_router.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    vxlan_router.vm.box_url = "https://plink.ucloud.com/public_link/link/a7941f067ddd8aa3"
    vxlan_router.vm.hostname = "vxlan-router"
    vxlan_router.vm.network "private_network", ip: "192.168.1.1"
    vxlan_router.vm.network "private_network", ip: "192.168.2.1"
    #vxlan_router.vm.network "forwarded_port", guest: 80, host: 8081
    vxlan_router.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
      vb.customize ["modifyvm", :id, "--nic3", "intnet"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
    end
    #vxlan_router.vm.provision "shell", inline: <<-SCRIPT
    #  sed -i 's/^#net.ipv4.ip_forward.*/net.ipv4.ip_forward=1/g' /etc/sysctl.conf && sysctl -p
    #  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    #SCRIPT
    vxlan_router.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    vxlan_router.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    vxlan_router.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    vxlan_router.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    vxlan_router.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = "--verbose"
    end
    vxlan_router.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "vxlan_router.pp"
      puppet.options = "--verbose"
    end
  end

  ## VXLAN - server1
  config.vm.define "vxlan-server1" do |vxlan_server1|
    vxlan_server1.vm.box = "trusty64"
    #vxlan_server1.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    vxlan_server1.vm.box_url = "https://plink.ucloud.com/public_link/link/a7941f067ddd8aa3"
    vxlan_server1.vm.hostname = "vxlan-server1"
    vxlan_server1.vm.network "private_network", ip: "192.168.1.10"
    #vxlan_server1.vm.network "forwarded_port", guest: 80, host: 8081
    vxlan_server1.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
    end
    vxlan_server1.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    vxlan_server1.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    vxlan_server1.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    vxlan_server1.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    vxlan_server1.vm.provision "shell", inline: <<-SCRIPT
      route del default && route add default gw 192.168.1.1
    SCRIPT
    vxlan_server1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = "--verbose"
    end
    vxlan_server1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "vxlan-servers.pp"
      puppet.options = "--verbose"
    end
  end

  ## VXLAN - server2
  config.vm.define "vxlan-server2" do |vxlan_server2|
    vxlan_server2.vm.box = "trusty64"
    #vxlan_server2.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    vxlan_server2.vm.box_url = "https://plink.ucloud.com/public_link/link/a7941f067ddd8aa3"
    vxlan_server2.vm.hostname = "vxlan-server2"
    vxlan_server2.vm.network "private_network", ip: "192.168.2.20"
    vxlan_server2.vm.network "forwarded_port", guest: 80, host: 8081
    vxlan_server2.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
    end
    vxlan_server2.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    #vxlan_server2.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    vxlan_server2.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    vxlan_server2.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    vxlan_server2.vm.provision "shell", inline: <<-SCRIPT
      route del default && route add default gw 192.168.2.1
    SCRIPT
    vxlan_server2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = "--verbose"
    end
    vxlan_server2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "vxlan-servers.pp"
      puppet.options = "--verbose"
    end
  end

#  ## mininext
#  num_mininext_nodes = 3 # (Max: 3)
#  mininext_ip_base = "192.168.80."
#  mininext_ips = num_mininext_nodes.times.collect { |n| compute_ip_base + "#{n+11}" }
#
#  num_mininext_nodes.times do |n|
#    config.vm.define "mininext-#{n+1}" do |mininext|
#      mininext_ip = mininext_ips[n]
#      mininext_index = n+1
#      mininext.vm.box = "trusty64"
#      #mininext.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
#      mininext.vm.box_url = "https://plink.ucloud.com/public_link/link/a7941f067ddd8aa3"
#      mininext.vm.hostname = "mininext-#{mininext_index}"
#      mininext.vm.network "private_network", ip: "#{mininext_ip}"
#      #mininext.vm.network "forwarded_port", guest: 8080, host: 9292
#      #mininext.vm.network "forwarded_port", guest: 8181, host: 8282
#      mininext.vm.provider :virtualbox do |vb|
#        #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
#        vb.customize ["modifyvm", :id, "--cpus", "2"]
#        vb.customize ["modifyvm", :id, "--memory", "2048"]
#        #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
#        #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
#        #vb.customize ["modifyvm", :id, "--nic2", "intnet"]
#      end
#      mininext.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
#      mininext.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
#      mininext.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
#      mininext.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
#      #mininext.vm.provision "shell", inline: <<-SCRIPT
#      #  route add -net 192.168.40.0/24 eth1 2> /dev/null; echo "route add -net 192.168.40.0/24 eth1"
#      #  route add -net 192.168.41.0/24 eth1 2> /dev/null; echo "route add -net 192.168.41.0/24 eth1"
#      #SCRIPT
#      mininext.vm.provision "puppet" do |puppet|
#        puppet.working_directory = "/vagrant/resources/puppet"
#        puppet.hiera_config_path = "resources/puppet/hiera-mininext.yaml"
#        puppet.manifests_path = "resources/puppet/manifests"
#        puppet.manifest_file  = "base.pp"
#        puppet.options = "--verbose"
#      end
#      mininext.vm.provision "puppet" do |puppet|
#        puppet.working_directory = "/vagrant/resources/puppet"
#        puppet.hiera_config_path = "resources/puppet/hiera-mininext.yaml"
#        puppet.manifests_path = "resources/puppet/manifests"
#        puppet.manifest_file  = "mininext.pp"
#        puppet.options = "--verbose"
#      end
#    end
#  end

end
