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

$MY_BRANCH = $my_branch

vcsrepo { "/home/vagrant/devstack":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "https://github.com/openstack-dev/devstack.git",
    revision => "${MY_BRANCH}",
    before => File["/home/vagrant/devstack/local.conf"],
}

#exec { "git checkout ${MY_BRANCH} && git pull":
#    cwd     => "/home/vagrant/devstack/",
#    user    => "vagrant",
#    timeout => "0",
#    require => Vcsrepo["/home/vagrant/devstack"],
#}

#exec { "sudo pip install --upgrade requests setuptools oslo.middleware":
#    cwd     => "/home/vagrant/devstack/",
#    user    => "vagrant",
#    timeout => "0",
#    require => Vcsrepo["/home/vagrant/devstack"],
#}

$hosts = hiera("hosts")

if is_enable_odl == true {
	$local_conf_src = "/vagrant/resources/puppet/templates/compute.local.conf.erb"
} else {
	$local_conf_src = "/vagrant/resources/puppet/templates/compute.local-no-odl.conf.erb"
}

file { "/home/vagrant/devstack/local.conf":
    ensure => present,
    owner => "vagrant",
    group => "vagrant",
    content => template("$local_conf_src"),
    replace  => true,
    require  => Vcsrepo["/home/vagrant/devstack"],
}

#file { "/home/vagrant/devstack/local-no-odl.conf":
#    ensure => present,
#    owner => "vagrant",
#    group => "vagrant",
#    content => template("/vagrant/resources/puppet/templates/compute.local-no-odl.conf.erb"),
#    replace  => true,
#    require  => Vcsrepo["/home/vagrant/devstack"],
#}

#exec { "dos2unix /home/vagrant/devstack/local.conf":
#    cwd     => "/home/vagrant/devstack/",
#    user    => "root",
#    timeout => "0",
#    require => File["/home/vagrant/devstack/local.conf"],
#}

file { "Put local.sh":
    path     => "/home/vagrant/devstack/local.sh",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0755,
    content => template("/vagrant/resources/puppet/templates/devstack-local.sh.erb"),
    replace  => true,
    require  => Vcsrepo["/home/vagrant/devstack"],
}

#exec { "dos2unix /home/vagrant/devstack/local.sh":
#    cwd     => "/home/vagrant/devstack/",
#    user    => "root",
#    timeout => "0",
#    require => File["Put local.sh"],
#}
