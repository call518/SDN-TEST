####################################################
#import "base.pp"

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

#exec { "service openvswitch-controller stop":
#    user    => "root",
#    timeout  => "0",
#    require => Package["mininet"],
#}

#file { "Put topo-mininet":
#    path     => "/home/vagrant/topo-mininet",
#    owner    => "vagrant",
#    group    => "vagrant",
#    mode     => 0755,
#    source   => "/vagrant/resources/topo-mininet",
#    ensure   => directory,
#    replace  => true,
#    recurse  => true,
#}
