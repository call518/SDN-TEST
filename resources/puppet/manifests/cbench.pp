####################################################
#import "base.pp"

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

package { "iptables":
    ensure   => installed,
}

## Fedroa-20
#$deps = [
#	"net-snmp-devel",
#	"libpcap-devel",
#	"autoconf",
#	"make",
#	"automake",
#	"libtool",
#	"libconfig-devel",
#	"git",
#]

## Debian/Ubuntu
$deps = [
	"libsnmp-dev",
	"libpcap-dev",
	"autoconf",
	"make",
	"automake",
	"libtool",
	"libconfig-dev",
	"git",
	"sshpass",
	"python-numpy",
	"python-matplotlib",
	"gnuplot",
]

package { $deps:
    ensure   => installed,
}

$OF_DIR = "/home/vagrant/openflow"
$OFLOPS_DIR = "/home/vagrant/oflops"

vcsrepo { "${OFLOPS_DIR}":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "https://github.com/andi-bigswitch/oflops.git",
}

vcsrepo { "${OF_DIR}":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "git://gitosis.stanford.edu/openflow.git",
}

exec { "Build Configuration (1)":
    command => "bash boot.sh",
    user    => "vagrant",
    cwd     => "${OFLOPS_DIR}",
    timeout => "0",
    logoutput => true,
    require => [ Vcsrepo["${OFLOPS_DIR}"], Vcsrepo["${OF_DIR}"] ],
    #require => [ Exec["Git Clone OFLOPS"], Exec["Git Clone OpenFlow"] ],
    unless  => "bash -c 'command -v cbench &>/dev/null'",
}

exec { "Build Configuration (2)":
    command => "bash -c './configure --with-openflow-src-dir=${OF_DIR}'",
    user    => "vagrant",
    cwd     => "${OFLOPS_DIR}",
    timeout => "0",
    logoutput => true,
    require => Exec["Build Configuration (1)"],
    unless  => "bash -c 'command -v cbench &>/dev/null'",
}

exec { "Make & Install":
    command => "make && make install",
    user    => "root",
    cwd     => "${OFLOPS_DIR}",
    timeout => "0",
    logoutput => true,
    require => Exec["Build Configuration (2)"],
    unless  => "bash -c 'command -v cbench &>/dev/null'",
}

vcsrepo { "/home/vagrant/wcbench":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "https://github.com/dfarrell07/wcbench.git",
}

exec { "edit wcbench":
    command => "sed -i 's/env sh$/env bash/g' *",
    user    => "vagrant",
    cwd     => "/home/vagrant/wcbench",
    timeout => "0",
    logoutput => true,
    require => Vcsrepo["/home/vagrant/wcbench"],
}

file { "Put wcbench-custom":
    path     => "/home/vagrant/wcbench-custom",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0755,
    source   => "/vagrant/resources/puppet/files/wcbench-custom",
    ensure   => directory,
    replace  => true,
    recurse  => true,
}

exec { "config ssh_config":
    command => "cat /vagrant/resources/puppet/files/ssh_config_options >> /etc/ssh/ssh_config",
    user    => "root",
    timeout => "0",
    logoutput => true,
}

$eCBench_DIR = "/home/vagrant/eCBench"

vcsrepo { "${eCBench_DIR}":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "https://gist.github.com/9837240.git",
    #require => Vcsrepo["${OFLOPS_DIR}"],
}

file { "$eCBench_DIR/oflops":
    ensure   => link,
    target   => "${OFLOPS_DIR}",
    owner    => "vagrant",
    group    => "vagrant",
    replace  => true,
    require  => Vcsrepo["${eCBench_DIR}"],
}

file { "$eCBench_DIR/logs":
    ensure   => directory,
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0750,
    require  => Vcsrepo["${eCBench_DIR}"],
}

exec { "chmod 755 *.sh *.py":
    #command => "",
    cwd     => "${eCBench_DIR}",
    user    => "vagrant",
    timeout => "0",
    logoutput => true,
    require => Vcsrepo["${eCBench_DIR}"],
}

exec { "sed -i 's/10.0.42.5/192.168.41.10/g' ${eCBench_DIR}/.runCbench.config":
    #command => "",
    cwd     => "${eCBench_DIR}",
    user    => "vagrant",
    timeout => "0",
    logoutput => true,
    require => Vcsrepo["${eCBench_DIR}"],
}

ssh_keygen { "vagrant":
    type     => "rsa",
    home     => "/home/vagrant",
    filename => "/home/vagrant/.ssh/id_rsa_nopass",
}

file { "/home/vagrant/.ssh/config":
    ensure  => present,
    owner   => "vagrant",
    group   => "vagrant",
    content => "Host cbench\n    Hostname 192.168.30.10\n    User vagrant\n    IdentityFile /home/vagrant/.ssh/id_rsa\n    StrictHostKeyChecking no",
    mode    => "0600",
}
