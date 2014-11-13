##### DevStack Compute ########################
#import "base.pp"

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

vcsrepo { "/home/vagrant/devstack":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "https://github.com/openstack-dev/devstack.git",
    #revision => "0b052589132fdfe9c6d3a9f70ddd3c9712ee435a",
    before => File["/home/vagrant/devstack/local.conf"]
}

exec { "git checkout stable/icehouse":
    cwd     => "/home/vagrant/devstack/",
    user    => "vagrant",
    timeout => "0",
    require => Vcsrepo["/home/vagrant/devstack"],
}

$hosts = hiera("hosts")

file { "/home/vagrant/devstack/local.conf":
    ensure => present,
    owner => "vagrant",
    group => "vagrant",
    content => template("/vagrant/resources/puppet/templates/compute.local.conf.erb")
}

exec { "dos2unix /home/vagrant/devstack/local.conf":
    cwd     => "/home/vagrant/devstack/",
    user    => "root",
    timeout => "0",
    require => File["/home/vagrant/devstack/local.conf"],
}
