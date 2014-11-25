####################################################
#import "base.pp"

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

package { "iptables":
    ensure   => installed,
}

############## puppetlabs-firewall Not Works... #####################
#resources { "firewall":
#    purge     => true
#}

#exec { "iptables -F && iptables -t nat -F":
#    user    => "root",
#    timeout => "0",
#}

#firewall { "100 s1 MASQUERADE":
#    table     => "nat",
#    chain     => "POSTROUTING",
#    outiface  => "eth0",
#    proto     => "all",
#    source    => "192.168.1.0/24",
#    jump      => "MASQUERADE",
#}

#exec { "iptables -t nat -A POSTROUTING -o eth0 -s 192.168.1.0/24 -j MASQUERADE":
#    user    => "root",
#    timeout => "0",
#    require => Exec["iptables -F && iptables -t nat -F"],
#}

#firewall { "101 s2 MASQUERADE":
#    table     => "nat",
#    chain     => "POSTROUTING",
#    outiface  => "eth0",
#    proto     => "all",
#    source    => "192.168.2.0/24",
#    jump      => "MASQUERADE",
#}

#exec { "iptables -t nat -A POSTROUTING -o eth0 -s 192.168.2.0/24 -j MASQUERADE":
#    user    => "root",
#    timeout => "0",
#    require => Exec["iptables -F && iptables -t nat -F"],
#}
#####################################################################
