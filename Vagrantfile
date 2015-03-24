# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #config.vm.boot_timeout = 600
  #config.vm.provider :virtualbox do |vb|
  #  vb.gui = true
  #end

  config.ssh.forward_x11 = true

#################################################################################################################
############## VTN Coordinator / OpenDaylight / Mininet / RouteFlow #############################################
#################################################################################################################

  ## Ubuntu (General)
  config.vm.define "trusty64" do |trusty64|
    trusty64.vm.box = "trusty64"
    trusty64.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
    trusty64.vm.hostname = "ubuntu-trusty"
    trusty64.vm.network "private_network", ip: "192.168.10.10"
    #trusty64.vm.network "forwarded_port", guest: 8083, host: 8083
    trusty64.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
      #vb.customize ["modifyvm", :id, "--nic2", "intnet"]
    end
    #trusty64.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    #trusty64.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    #trusty64.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    trusty64.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    trusty64.vm.provision "shell", inline: <<-SCRIPT
      #route add -net 192.168.41.0/24 p7p1 2> /dev/null; echo "route add -net 192.168.41.0/24 p7p1"
      #route add -net 192.168.42.0/24 p7p1 2> /dev/null; echo "route add -net 192.168.42.0/24 p7p1"
      #route add -net 192.168.0.0/16 p7p1 2> /dev/null; echo "route add -net 192.168.0.0/16 p7p1"
    SCRIPT
    #trusty64.vm.provision "puppet" do |puppet|
    #  puppet.working_directory = "/vagrant/resources/puppet"
    #  puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
    #  puppet.manifests_path = "resources/puppet/manifests"
    #  puppet.manifest_file  = "base.pp"
    #  puppet.options = ["--verbose", "--debug"]
    #  puppet.options = "--verbose"
    #end
  end

  ## ONOS /w Mininet
  config.vm.define "onos" do |onos|
    onos.vm.box = "trusty64"
    onos.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
    onos.vm.hostname = "onos"
    onos.vm.network "private_network", ip: "192.168.13.10"
    onos.vm.network "forwarded_port", guest: 8181, host: 8181
    onos.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
    end
    #onos.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    #onos.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    #onos.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    onos.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    onos.vm.provision "shell", inline: <<-SCRIPT
      route add -net 192.168.0.0/16 eth1 2> /dev/null; echo "route add -net 192.168.0.0/16 eth1"
    SCRIPT
    onos.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    onos.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "java8.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    onos.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "onos.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    onos.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininet.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

  ## OSCP (OpenDaylight SDN Controller Platform)
  config.vm.define "oscp" do |oscp|
    oscp.vm.box = "trusty64"
    oscp.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
    oscp.vm.hostname = "oscp"
    oscp.vm.network "private_network", ip: "192.168.12.10"
    oscp.vm.network "forwarded_port", guest: 8000, host: 8000
    oscp.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
    end
    #oscp.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    #oscp.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    #oscp.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    oscp.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    oscp.vm.provision "shell", inline: <<-SCRIPT
      route add -net 192.168.0.0/16 eth1 2> /dev/null; echo "route add -net 192.168.0.0/16 eth1"
    SCRIPT
    oscp.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    oscp.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "oscp.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    oscp.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininet.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

  ## VTN Coordinator
  config.vm.define "vtn-coordinator" do |vtn_coordinator|
    #vtn_coordinator.vm.box = "Fedora19-x86_64"
    #vtn_coordinator.vm.box_url = "https://vagrantcloud.com/JungJungIn/boxes/Fedora19-x86_64/versions/0.2.0/providers/virtualbox.box"
    vtn_coordinator.vm.box = "Fedora20-x86_64"
    vtn_coordinator.vm.box_url = "https://vagrantcloud.com/JungJungIn/boxes/Fedora20-x86_64/versions/0.1.0/providers/virtualbox.box"
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
      #route add -net 192.168.41.0/24 p7p1 2> /dev/null; echo "route add -net 192.168.41.0/24 p7p1"
      #route add -net 192.168.42.0/24 p7p1 2> /dev/null; echo "route add -net 192.168.42.0/24 p7p1"
      route add -net 192.168.0.0/16 p7p1 2> /dev/null; echo "route add -net 192.168.0.0/16 p7p1"
    SCRIPT
    vtn_coordinator.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      #puppet.options = ["--verbose", "--debug"]
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
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

  ## OpenDaylight & Mininet (1)
  config.vm.define "opendaylight-mininet-1" do |opendaylight_mininet_1|
    opendaylight_mininet_1.vm.box = "trusty64"
    opendaylight_mininet_1.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
    opendaylight_mininet_1.vm.hostname = "opendaylight-mininet-1"
    opendaylight_mininet_1.vm.network "private_network", ip: "192.168.41.10"
    opendaylight_mininet_1.vm.network "forwarded_port", guest: 8080, host: 9191
    opendaylight_mininet_1.vm.network "forwarded_port", guest: 8181, host: 8181
    opendaylight_mininet_1.vm.network "forwarded_port", guest: 8101, host: 8101
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
      #route add -net 192.168.40.0/24 eth1 2> /dev/null; echo "route add -net 192.168.40.0/24 eth1"
      #route add -net 192.168.42.0/24 eth1 2> /dev/null; echo "route add -net 192.168.42.0/24 eth1"
      route add -net 192.168.0.0/16 eth1 2> /dev/null; echo "route add -net 192.168.0.0/16 eth1"
    SCRIPT
    opendaylight_mininet_1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    opendaylight_mininet_1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "java7.pp"
      #puppet.options = ["--verbose", "--debug"]
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
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    opendaylight_mininet_1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininet.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    opendaylight_mininet_1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininext.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

  ## OpenDaylight & Mininet (2)
  config.vm.define "opendaylight-mininet-2" do |opendaylight_mininet_2|
    opendaylight_mininet_2.vm.box = "trusty64"
    opendaylight_mininet_2.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
    opendaylight_mininet_2.vm.hostname = "opendaylight-mininet-2"
    opendaylight_mininet_2.vm.network "private_network", ip: "192.168.42.10"
    opendaylight_mininet_2.vm.network "forwarded_port", guest: 8080, host: 9292
    opendaylight_mininet_2.vm.network "forwarded_port", guest: 8181, host: 8282
    opendaylight_mininet_2.vm.network "forwarded_port", guest: 8101, host: 8202
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
      #route add -net 192.168.40.0/24 eth1 2> /dev/null; echo "route add -net 192.168.40.0/24 eth1"
      #route add -net 192.168.41.0/24 eth1 2> /dev/null; echo "route add -net 192.168.41.0/24 eth1"
      route add -net 192.168.0.0/16 eth1 2> /dev/null; echo "route add -net 192.168.0.0/16 eth1"
    SCRIPT
    opendaylight_mininet_2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = ["--verbose", "--debug"]
      #puppet.options = "--verbose"
    end
    opendaylight_mininet_2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "java7.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    opendaylight_mininet_2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      #puppet.manifest_file  = "opendaylight.pp"
      puppet.facter = {
        #"odl_dist_name" => "Hydrogen-Virtualization"
        #"odl_dist_name" => "Hydrogen-SP"
        #"odl_dist_name" => "Helium"
        "odl_dist_name" => "Helium-SR1"
      }
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    opendaylight_mininet_2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininet.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    opendaylight_mininet_2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininext.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

  ## RouteFlow & Mininet
  config.vm.define "routeflow" do |routeflow|
    routeflow.vm.box = "precise64"
    routeflow.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!244&authkey=!ABlsBcuzsaL0dAw&ithint=file%2cbox"
    routeflow.vm.hostname = "routeflow"
    routeflow.vm.network "private_network", ip: "192.168.30.10"
    #routeflow.vm.network "forwarded_port", guest: 8080, host: 8080
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
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    #routeflow.vm.provision "puppet" do |puppet|
    #  puppet.working_directory = "/vagrant/resources/puppet"
    #  puppet.hiera_config_path = "resources/puppet/hiera-routeflow.yaml"
    #  puppet.manifests_path = "resources/puppet/manifests"
    #  puppet.manifest_file  = "java7.pp"
    #  #puppet.options = ["--verbose", "--debug"]
    #  puppet.options = "--verbose"
    #end
    routeflow.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-routeflow.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "routeflow.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    routeflow.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-routeflow.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "mininet.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

#################################################################################################################
############## DevStack / OpenDaylight ##########################################################################
#################################################################################################################

  ### Toggle /w OpenDaylight(Selective SDN)
  is_enable_odl = true # true/false

  ### DevStack Branch
  #devstack_branch = "havana-eol" ## by tag
  #devstack_branch = "stable/icehouse"
  devstack_branch = "stable/juno"

  ### Devstack Control Node
  ## ip pre-configuration
  control_ip = "192.168.50.10"
  control_ip_data = "172.16.0.10"
  rsyslog_port = "10514"

  config.vm.define "devstack-control" do |control|
    control.vm.box = "trusty64"
    control.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
    control.vm.hostname = "devstack-control"
    control.vm.network "private_network", ip: "#{control_ip}"
    control.vm.network "private_network", ip: "#{control_ip_data}"
    control.vm.network "public_network", auto_config: false
    control.vm.network "forwarded_port", guest: 8080, host: 8080 # ODL API URL (http://loclahost:8080)
    control.vm.network "forwarded_port", guest: 8181, host: 8181 # ODL GUI URL (http://localhost:8181/dlux/index.html)
    control.vm.network "forwarded_port", guest: 8101, host: 8101 # ODL Karaf SSH Console (ID/PW: karaf/karaf)
    control.vm.network "forwarded_port", guest: 80, host: 80 # DevStack CTL (http://localhost)
    control.vm.network "forwarded_port", guest: 8773, host: 8773 # OpenStack API
    control.vm.network "forwarded_port", guest: 8774, host: 8774 # OpenStack API
    control.vm.network "forwarded_port", guest: 8775, host: 8775 # OpenStack API
    control.vm.network "forwarded_port", guest: 8776, host: 8776 # OpenStack API
    control.vm.network "forwarded_port", guest: 9191, host: 9191 # OpenStack API
    control.vm.network "forwarded_port", guest: 9292, host: 9292 # OpenStack API
    control.vm.network "forwarded_port", guest: 5000, host: 5000 # OpenStack API
    control.vm.network "forwarded_port", guest: 8000, host: 8000 # Splunk (for OpenStack Logs)
    #control.vm.network "forwarded_port", guest: 6080, host: 6080
    control.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "4"]
      vb.customize ["modifyvm", :id, "--memory", "3072"]
      #vb.customize ["modifyvm", :id, "--memory", "4096"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nic2", "intnet"]
      #vb.customize ["modifyvm", :id, "--nic3", "intnet"]
      vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
    end
    control.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    control.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    control.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    control.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    control.vm.provision "shell", inline: <<-SCRIPT
      if test ! -f /root/.created-routing; then
        route add -net 192.168.51.0/24 gateway 192.168.50.1 dev eth2
        route add -net 172.16.1.0/24 gateway 172.16.0.1 dev eth1
        sudo iptables -t nat -I POSTROUTING -o eth0 -s 172.20.20.0/24 -j MASQUERADE
        touch /root/.created-routing
      fi
    SCRIPT
    control.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    if is_enable_odl:
        control.vm.provision "puppet" do |puppet|
          puppet.working_directory = "/vagrant/resources/puppet"
          puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
          puppet.manifests_path = "resources/puppet/manifests"
          puppet.manifest_file  = "java7.pp"
          #puppet.options = ["--verbose", "--debug"]
          puppet.options = "--verbose"
        end
        control.vm.provision "puppet" do |puppet|
          puppet.working_directory = "/vagrant/resources/puppet"
          puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
          puppet.manifests_path = "resources/puppet/manifests"
          puppet.manifest_file  = "opendaylight.pp"
          puppet.facter = {
            #"odl_dist_name" => "Hydrogen-Virtualization"
            #"odl_dist_name" => "Hydrogen-SP"
            #"odl_dist_name" => "Helium"
            "odl_dist_name" => "Helium-SR1",
          }
          #puppet.options = ["--verbose", "--debug"]
          puppet.options = "--verbose"
        end
	end
    control.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "devstack-control.pp"
      puppet.facter = {
        "my_branch" => "#{devstack_branch}",
        "rsyslog_port" => "#{rsyslog_port}"
      }
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

  ### Devstack Compute Nodes
  ## ip pre-configuration
  compute_ip = "192.168.51.21"
  compute_ip_data = "172.16.1.21"

  config.vm.define "devstack-compute" do |compute|
    compute.vm.box = "trusty64"
    compute.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
    compute.vm.hostname = "devstack-compute"
    compute.vm.network "private_network", ip: "#{compute_ip}"
    compute.vm.network "private_network", ip: "#{compute_ip_data}"
    #compute.vm.network "forwarded_port", guest: 6080, host: 6080
    compute.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "4"]
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nic2", "intnet"]
      #vb.customize ["modifyvm", :id, "--nic3", "intnet"]
    end
    compute.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    compute.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    compute.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    compute.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    compute.vm.provision "shell", inline: <<-SCRIPT
      if test ! -f /root/.created-routing; then
        route add -net 192.168.50.0/24 gateway 192.168.51.1 dev eth2
        route add -net 172.16.0.0/24 gateway 172.16.1.1 dev eth1
        touch /root/.created-routing
      fi
    SCRIPT
    compute.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
#    compute.vm.provision "puppet" do |puppet|
#      puppet.working_directory = "/vagrant/resources/puppet"
#      puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
#      puppet.manifests_path = "resources/puppet/manifests"
#      puppet.manifest_file  = "java7.pp"
#      #puppet.options = ["--verbose", "--debug"]
#      puppet.options = "--verbose"
#    end
    compute.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-devstack.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "devstack-compute.pp"
      puppet.facter = {
        "my_branch" => "#{devstack_branch}",
        "rsyslog_port" => "#{rsyslog_port}"
      }
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

#################################################################################################################
############## VXLAN / OVS ######################################################################################
#################################################################################################################

  ## VXLAN - Router (Must be deploy first)
  config.vm.define "vxlan-router" do |vxlan_router|
    vxlan_router.vm.box = "trusty64"
    vxlan_router.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
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
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    vxlan_router.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "vxlan-router.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

  ## VXLAN - server1
  config.vm.define "vxlan-server1" do |vxlan_server1|
    vxlan_server1.vm.box = "trusty64"
    vxlan_server1.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
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
      if test ! -f /root/.created-routing; then
        route del default && route add default gw 192.168.1.1
        touch /root/.created-routing
      fi
    SCRIPT
    vxlan_server1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    vxlan_server1.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "vxlan-servers.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

  ## VXLAN - server2
  config.vm.define "vxlan-server2" do |vxlan_server2|
    vxlan_server2.vm.box = "trusty64"
    vxlan_server2.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
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
      if test ! -f /root/.created-routing; then
        route del default && route add default gw 192.168.2.1
        touch /root/.created-routing
      fi
    SCRIPT
    vxlan_server2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    vxlan_server2.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-vxlan.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "vxlan-servers.pp"
      #puppet.options = ["--verbose", "--debug"]
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
#      mininext.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
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
#        #puppet.options = ["--verbose", "--debug"]
#        puppet.options = "--verbose"
#      end
#      mininext.vm.provision "puppet" do |puppet|
#        puppet.working_directory = "/vagrant/resources/puppet"
#        puppet.hiera_config_path = "resources/puppet/hiera-mininext.yaml"
#        puppet.manifests_path = "resources/puppet/manifests"
#        puppet.manifest_file  = "mininext.pp"
#        #puppet.options = ["--verbose", "--debug"]
#        puppet.options = "--verbose"
#      end
#    end
#  end

  ## CBench
  config.vm.define "cbench" do |cbench|
    cbench.ssh.forward_x11 = true
    cbench.vm.box = "trusty64"
    cbench.vm.box_url = "https://onedrive.live.com/download?resid=28F8F701DC29E4B9!247&authkey=!AC-zzAlAl6UhvGo&ithint=file%2cbox"
    #cbench.vm.box = "Fedora20-x86_64"
    #cbench.vm.box_url = "https://vagrantcloud.com/JungJungIn/boxes/Fedora20-x86_64/versions/0.1.0/providers/virtualbox.box"
    cbench.vm.hostname = "cbench"
    cbench.vm.network "private_network", ip: "192.168.77.10"
    #cbench.vm.network "forwarded_port", guest: 8080, host: 9191
    #cbench.vm.network "forwarded_port", guest: 8181, host: 8181
    cbench.vm.provider :virtualbox do |vb|
      #vb.customize ["modifyvm", :id, "--cpus", "1", "--hwvirtex", "off"] ## without VT-x
      vb.customize ["modifyvm", :id, "--cpus", "4"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
    end
    cbench.vm.provision "shell", path: "resources/puppet/scripts/create-swap.sh"
    cbench.vm.provision "shell", path: "resources/puppet/scripts/edit-apt-repo.sh"
    cbench.vm.provision "shell", path: "resources/puppet/scripts/upgrade-puppet.sh"
    cbench.vm.provision "shell", path: "resources/puppet/scripts/bootstrap.sh"
    cbench.vm.provision "shell", inline: <<-SCRIPT
      #route add -net 192.168.40.0/24 eth1 2> /dev/null; echo "route add -net 192.168.40.0/24 eth1"
      #route add -net 192.168.42.0/24 eth1 2> /dev/null; echo "route add -net 192.168.42.0/24 eth1"
      route add -net 192.168.0.0/16 eth1 2> /dev/null; echo "route add -net 192.168.0.0/16 eth1"
    SCRIPT
    cbench.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "base.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    cbench.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "cbench.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
    cbench.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/resources/puppet"
      puppet.hiera_config_path = "resources/puppet/hiera-opendaylight.yaml"
      puppet.manifests_path = "resources/puppet/manifests"
      puppet.manifest_file  = "pox.pp"
      #puppet.options = ["--verbose", "--debug"]
      puppet.options = "--verbose"
    end
  end

end
