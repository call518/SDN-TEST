##### DevStack Compute ########################
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
    content => template("/vagrant/resources/puppet/templates/compute.local.conf.erb")
}

exec { "dos2unix /home/vagrant/devstack/local.conf":
    cwd     => "/home/vagrant/devstack/",
    user    => "root",
    timeout => "0",
    require => File["/home/vagrant/devstack/local.conf"],
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
