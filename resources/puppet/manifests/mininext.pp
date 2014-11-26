####################################################


## (!!!!!!!) Pre-Requirement: 'mininet' Must be installed.

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

$deps = [
          "iptables",
]

package { $deps:
    ensure   => installed,
}

vcsrepo { "/hoem/vagrant/miniNExT":
    ensure   => present,
    provider => git,
    user     => "vagrant",
    source   => "https://github.com/USC-NSL/miniNExT.git",
    #revision => "75c2781c0f22c5701257fa28f849d27086b5b13e",
}

exec  { "Install Deps of miniNExT":
    command  => "sudo apt-get -y install `make deps`",
    user     => "vagrant",
    cwd      => "/hoem/vagrant/miniNExT",
    timeout  => "0",
    require  => Vcsrepo["/usr/local/src/miniNExT"],
}

exec  { "Install miniNExT":
    command  => "sudo make install",
    user     => "vagrant",
    cwd      => "/hoem/vagrant/miniNExT",
    timeout  => "0",
    require  => Exec["Install Deps of miniNExT"],
}

### Add-On: Developer Installation
#exec  { "Install miniNExT for Developer":
#    command  => "sudo make develop",
#    user     => "vagrant",
#    cwd      => "/hoem/vagrant/miniNExT",
#    timeout  => "0",
#    require  => Exec["Install miniNExT"],
#}
