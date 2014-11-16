####################################################
#import "base.pp"

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

resources { "firewall":
    purge     => true
}

firewall { "100 s1 MASQUERADE":
    table     => "nat",
    chain     => "POSTROUTING",
    outiface  => "eth0",
    proto     => "all",
    source    => "192.168.1.0/24",
    jump      => "MASQUERADE",
    logoutput => true,
}

firewall { "101 s2 MASQUERADE":
    table     => "nat",
    chain     => "POSTROUTING",
    outiface  => "eth0",
    proto     => "all",
    source    => "192.168.2.0/24",
    jump      => "MASQUERADE",
    logoutput => true,
}
