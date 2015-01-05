####################################################
#import "base.pp"

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

include apt

package { "maven":
    ensure   => installed,
}

#package { "build-essential":
#    ensure   => installed,
#}

vcsrepo { "/usr/local/src/onos":
    provider => git,
    ensure => present,
    user => "root",
    source => "https://gerrit.onosproject.org/onos",
}

exec { "mvn clean install":
    cwd      => "/usr/local/src/onos",
    user     => "root",
    timeout  => "0",
    logoutput => true,
    require  => [Vcsrepo["/usr/local/src/onos"], Package["maven"]],
}

file { "/etc/profile.d/onos.sh":
    ensure  => present,
    owner    => "root",
    group    => "root",
    content => "export ONOS_ROOT=/home/vagrant/onos",
    require => Exec["mvn clean install"],
}

exec { "Download karaf":
    command  => "wget http://mirror.apache-kr.org/karaf/3.0.2/apache-karaf-3.0.2.tar.gz -O apache-karaf-3.0.2.tar.gz",
    cwd      => "/usr/local/src",
    user     => "root",
    timeout  => "0",
    logoutput => true,
    onlyif   => "test ! -f /usr/local/src/apache-karaf-3.0.2.tar.gz",
    require  => File["/etc/profile.d/onos.sh"],
}

exec { "Extract karaf":
    command  => "tar zxf apache-karaf-3.0.2.tar.gz -C /usr/local/",
    cwd      => "/usr/local/src",
    user     => "root",
    timeout  => "0",
    logoutput => true,
    onlyif   => "test ! -d /usr/local/apache-karaf-3.0.2",
    require  => Exec["Download karaf"],
}

file { "Link /usr/local/karaf":
    ensure   => link,
    target  => "/usr/local/apache-karaf-3.0.2",
    require  => Exec["Extract karaf"],
}

file { "/etc/profile.d/karaf.sh":
    ensure  => present,
    content => "export KARAF_ROOT=/home/vagrant/\nexport PATH=$PATH:KARAF_ROOT/bin",
}
