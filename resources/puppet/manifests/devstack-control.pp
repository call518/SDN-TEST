##### DevStack Control ########################
#import "base.pp"

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

package { "ntp":
    ensure   => installed,
}

package { "iptables":
    ensure   => installed,
}

#package { "virt-manager":
#    ensure   => installed,
#}

vcsrepo { "/home/vagrant/devstack":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "https://github.com/openstack-dev/devstack.git",
    #revision => "2d311df771bf5745d20ba7eeeb44adc7db0df54a",	## Juno
    #revision => "0b052589132fdfe9c6d3a9f70ddd3c9712ee435a",	## Icehouse
    before => File["/home/vagrant/devstack/local.conf"]
}

$MY_BRANCH = $my_branch
exec { "git checkout ${MY_BRANCH} && git pull":
    cwd     => "/home/vagrant/devstack/",
    user    => "vagrant",
    timeout => "0",
    require => Vcsrepo["/home/vagrant/devstack"],
}

#exec { "sudo pip install --upgrade requests setuptools oslo.middleware":
#    cwd     => "/home/vagrant/devstack/",
#    user    => "vagrant",
#    timeout => "0",
#    require => Vcsrepo["/home/vagrant/devstack"],
#}

$hosts = hiera("hosts")

file { "/home/vagrant/devstack/local.conf":
    ensure => present,
    owner => "vagrant",
    group => "vagrant",
    content => template("/vagrant/resources/puppet/templates/control.local.conf.erb")
}

exec { "dos2unix /home/vagrant/devstack/local.conf":
    cwd     => "/home/vagrant/devstack/",
    user    => "root",
    timeout => "0",
    require => File["/home/vagrant/devstack/local.conf"],
}

file { "Put devstack-overlay-demo-cmd.txt":
    path     => "/home/vagrant/devstack/devstack-overlay-demo-cmd.txt",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0644,
    source   => "/vagrant/resources/puppet/files/devstack-overlay-demo-cmd.txt",
    replace  => true,
}

############## puppetlabs-firewall Not Works... #####################
#resources { "firewall":
#    purge     => true
#}

#exec { "iptables -F && iptables -t nat -F":
#    user    => "root",
#    timeout => "0",
#}

#firewall { "100 MASQUERADE to Public":
#    table     => "nat",
#    chain     => "POSTROUTING",
#    outiface  => "eth0",
#    proto     => "all",
#    source    => "172.24.4.0/24",
#    jump      => "MASQUERADE",
#}

#exec { "iptables -t nat -A POSTROUTING -o eth0 -s 172.24.4.0/24 -j MASQUERADE":
#    user    => "root",
#    timeout => "0",
##    require => Exec["iptables -F && iptables -t nat -F"],
#}
#####################################################################

exec { "echo \"\nauto eth3\niface eth3 inet manual\nup ifconfig $IFACE 0.0.0.0 up\nup ip link set $IFACE promisc on\ndown ip link set $IFACE promisc off\ndown ifconfig $IFACE down\" >> /etc/network/interfaces && ifdown eth3 && ifup eth3":
    user    => "root",
    timeout => "0",
    unless  => "grep '^auto eth3' /etc/network/interfaces",
}

exec { "Create EXT_GW_IP (eth0:1)":
    command => "ifconfig eth0:1 172.20.20.1/24 up && sed -i '/^exit 0/i ifconfig eth0:1 172.20.20.1/24 up' /etc/rc.local",
    user    => "root",
    timeout => "0",
    unless  => "grep '^ifconfig eth0:1' /etc/rc.local",
}

exec { "Create NAT (EXT_GW_IP to eth0)":
    #command => "iptables -t nat -A POSTROUTING -o eth0 -s 172.20.20.0/24 -j MASQUERADE",
    command => "iptables -t nat -A POSTROUTING -o eth0 -s 172.20.20.1/24 -j MASQUERADE",
    user    => "root",
    timeout => "0",
    require => Exec["Create EXT_GW_IP (eth0:1)"],
}

file { "Put local.sh":
    path     => "/home/vagrant/devstack/local.sh",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0755,
    source   => "/vagrant/resources/puppet/files/devstack-local.sh",
    replace  => true,
    require  => Vcsrepo["/home/vagrant/devstack"],
}
