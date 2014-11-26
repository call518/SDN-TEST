####################################################


## (!!!!!!!) Pre-Requirement: 'mininet' Must be installed.

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

$deps = [
          "iptables",
          "mininet",
          "quagga",
]

exec { "Enable Backport-Precise":
    command => "bash -c 'if [ \"`lsb_release --codename --short`\" == \"precise\" ];then cp /vagrant/resources/puppet/files/sources-precise-backport.list /etc/apt/sources.list; apt-get update; fi'",
    user    => "root",
    timeout  => "0",
    before  => Package[ $deps ],
}

package { $deps:
    ensure   => installed,
}

vcsrepo { "/home/vagrant/miniNExT":
    ensure   => present,
    provider => git,
    user     => "vagrant",
    source   => "https://github.com/USC-NSL/miniNExT.git",
    #revision => "75c2781c0f22c5701257fa28f849d27086b5b13e",
}

exec  { "Install Deps of miniNExT":
    command  => "sudo apt-get -y install `make deps`",
    user     => "vagrant",
    cwd      => "/home/vagrant/miniNExT",
    timeout  => "0",
    require  => Vcsrepo["/home/vagrant/miniNExT"],
}

exec  { "Install miniNExT":
    command  => "sudo make install",
    user     => "vagrant",
    cwd      => "/home/vagrant/miniNExT",
    timeout  => "0",
    require  => Exec["Install Deps of miniNExT"],
}

### Add-On: Developer Installation
#exec  { "Install miniNExT for Developer":
#    command  => "sudo make develop",
#    user     => "vagrant",
#    cwd      => "/home/vagrant/miniNExT",
#    timeout  => "0",
#    require  => Exec["Install miniNExT"],
#}

file { "Put start.py":
    path    => "/home/vagrant/miniNExT/examples/quagga-ixp/start.py",
    ensure  => present,
    owner   => "vagrant",
    group   => "vagrant",
    mode    => 0755,
    content => template("/vagrant/resources/puppet/templates/start.py.erb"),
    require => Exec["Install miniNExT"],
}

