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
    command => "make && sudo make install",
    user    => "vagrant",
    cwd     => "${OFLOPS_DIR}",
    timeout => "0",
    logoutput => true,
    require => Exec["Build Configuration (2)"],
    unless  => "bash -c 'command -v cbench &>/dev/null'",
}

#file { "Put wcbench-files":
#    path     => "/home/vagrant/wcbench-scripts",
#    owner    => "vagrant",
#    group    => "vagrant",
#    mode     => 0755,
#    source   => "/vagrant/resources/puppet/files/wcbench-scripts",
#    ensure   => directory,
#    replace  => true,
#    recurse  => true,
#}

#exec { "edit wcbench-scripts":
#    command => "sed -i 's/^#!\/usr\/bin\/env sh$/#!\/usr\/bin\/env bash/g' /home/vagrant/wcbench-scripts/*",
#    user    => "vagrant",
#    cwd     => "/home/vagrant/wcbench-scripts",
#    timeout => "0",
#    logoutput => true,
#    require => File["Put wcbench-files"],
#}

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
