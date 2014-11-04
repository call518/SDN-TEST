####################################################
import "base.pp"

include apt

#class { "apt":
#  always_apt_update    => true,
#  disable_keys         => undef,
#  proxy_host           => false,
#  proxy_port           => "8080",
#  purge_sources_list   => false,
#  purge_sources_list_d => false,
#  purge_preferences_d  => false,
#  update_timeout       => undef,
#  fancy_progress       => undef
#}

### Install Deps Packages
$deps = [ "build-essential",
          "debhelper",
          "python-software-properties",
          "dkms",
          "fakeroot",
          "graphviz",
          "linux-headers-generic",
          "python-all",
          "python-qt4",
          "python-zopeinterface",
          "python-twisted-conch",
          "python-twisted-web",
          "xauth",
          "openvswitch-datapath-dkms",
          "wireshark",
]

### Export Env: Global %PATH for "Exec"
#Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

### Apt Update
#exec { "apt-update":
#    command => "/usr/bin/apt-get update",
#    user    => "root",
#    timeout  => "0",
#}

package { $deps:
    ensure   => installed,
    before   => Package["mininet"],
}

### Mininet
package { "mininet":
    ensure   => installed,
}

exec { "service openvswitch-controller stop":
    user    => "root",
    timeout  => "0",
    require => Package["mininet"],
}

exec { "update-rc.d openvswitch-controller disable":
    user    => "root",
    timeout  => "0",
    require => Package["mininet"],
}

exec { "dpkg-reconfigure openvswitch-datapath-dkms":
    user    => "root",
    timeout  => "0",
    require => Package["openvswitch-datapath-dkms"],
}

exec { "service openvswitch-switch restart":
    user    => "root",
    timeout  => "0",
    require => Exec["dpkg-reconfigure openvswitch-datapath-dkms"],
}

file { "Put topo-mininet":
    path     => "/home/vagrant/topo-mininet",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0755,
    source   => "/vagrant/resources/topo-mininet",
    ensure   => directory,
    replace  => true,
    recurse  => true,
}

vcsrepo { "/home/vagrant/loxigen":
    ensure   => present,
    provider => git,
    user     => "vagrant",
    source   => "https://github.com/floodlight/loxigen.git",
    require  => Package["wireshark"],
}

exec { "Install Wireshark OF Plugin":
    command  => "make wireshark && cp loxi_output/wireshark/openflow.lua /usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins/",
    user     => "root",
    cwd      => "/home/vagrant/loxigen/",
    timeout  => "0",
    require  => Vcsrepo["/home/vagrant/loxigen"],
}

#exec { "Disable Lua-Script":
#    command  => "sed -i 's/^disable_lua.*/disable_lua = true/g' init.lua",
#    user     => "root",
#    cwd      => "/usr/share/wireshark/",
#    timeout  => "0",
#    require  => Package["wireshark"],
#}
