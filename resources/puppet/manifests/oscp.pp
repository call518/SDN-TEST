####################################################
#import "base.pp"

include apt

#class { "apt":
#  always_apt_update    => true,
#  disable_keys         => undef,
#  proxy_host           => false,
#  proxy_port           => "8080",
#  purge_sources_list   => false,
#  purge_sources_list_d => false,
#  purge_preferences_d  => false,
#  update_timeout       => undef,
#  fancy_progress       => undef
#}

### Install Deps Packages
$deps = [
          "unzip",
          "python-dev",
          "python-virtualenv",
          "git",
          "openjdk-7-jdk",
          "ant",
          "build-essential",
]

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

### Apt Update
exec { "apt-update":
    command => "/usr/bin/apt-get update",
    user    => "root",
    timeout => "0",
}

package { "openjdk-6-jre-lib":
    ensure   => purged,
}

package { "openjdk-6-jre-headless":
    ensure   => purged,
}

package { $deps:
    ensure   => installed,
    require  => [Package["openjdk-6-jre-lib"], Package["openjdk-6-jre-headless"]],
    before   => [Exec["Building OSCP: setup.sh"], Exec["Buinding OSCP: make"]],
}

$oscp_dir = "/home/vagrant/net-virt-platform"

vcsrepo { "${oscp_dir}":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "https://git.opendaylight.org/gerrit/p/net-virt-platform.git",
    #revision => "master",
}

exec { "Building OSCP: setup.sh":
    command  => "bash setup.sh",
    cwd      => "${oscp_dir}",
    user     => "vagrant",
    timeout  => "0",
    require  => Vcsrepo["${oscp_dir}"],
}

exec { "Buinding OSCP: make":
    command  => "make",
    cwd      => "${oscp_dir}",
    user     => "vagrant",
    timeout  => "0",
    require  => Exec["Building OSCP: setup.sh"],
}
