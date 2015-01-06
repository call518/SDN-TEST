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

vcsrepo { "/home/vagrant/onos":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "https://gerrit.onosproject.org/onos",
    require => Package["maven"],
}

exec { "mvn clean install":
    cwd      => "/home/vagrant/onos",
    user     => "vagrant",
    timeout  => "0",
    logoutput => true,
    require  => [Vcsrepo["/home/vagrant/onos"], Package["maven"]],
    onlyif   => "test ! -f /home/vagrant/onos/target/onos-1.1.0-SNAPSHOT-tests.jar",
}

file { "/etc/profile.d/onos.sh":
    ensure  => present,
    owner    => "vagrant",
    group    => "vagrant",
    content => "export ONOS_ROOT=\"/home/vagrant/onos\"",
    require => Exec["mvn clean install"],
}

exec { "Download karaf":
    command  => "wget http://mirror.apache-kr.org/karaf/3.0.2/apache-karaf-3.0.2.tar.gz -O apache-karaf-3.0.2.tar.gz",
    cwd      => "/home/vagrant/",
    user     => "vagrant",
    timeout  => "0",
    logoutput => true,
    onlyif   => "test ! -f /home/vagrant/apache-karaf-3.0.2.tar.gz",
    require  => File["/etc/profile.d/onos.sh"],
}

exec { "Extract karaf":
    command  => "tar zxf apache-karaf-3.0.2.tar.gz",
    cwd      => "/home/vagrant",
    user     => "vagrant",
    timeout  => "0",
    logoutput => true,
    onlyif   => "test ! -d /home/vagrant/apache-karaf-3.0.2",
    require  => Exec["Download karaf"],
}

file { "/home/vagrant/karaf":
    ensure   => link,
    owner    => "vagrant",
    group    => "vagrant",
    target  => "/home/vagrant/apache-karaf-3.0.2",
    require  => Exec["Extract karaf"],
}

file { "/etc/profile.d/karaf.sh":
    ensure  => present,
    owner    => "vagrant",
    group    => "vagrant",
    content => "export KARAF_ROOT=\"/home/vagrant/karaf/\"\nexport PATH=\"\$PATH:\$KARAF_ROOT/bin\"",
    require => File["/home/vagrant/karaf"],
}

exec { "Add featuresRepositories to Karaf":
    command  => "sed -i \"/^featuresRepositories=/ s/$/,mvn:org.onosproject\\/onos-features\\/1.1.0-SNAPSHOT\\/xml\\/features/\" /home/vagrant/karaf/etc/org.apache.karaf.features.cfg",
    cwd      => "/home/vagrant/karaf/etc/",
    user     => "vagrant",
    timeout  => "0",
    logoutput => true,
    unless   => "grep -q \"mvn:org.onosproject/onos-features/1.1.0-SNAPSHOT/xml/features\" /home/vagrant/karaf/etc/org.apache.karaf.features.cfg",
    require  => File["/home/vagrant/karaf"],
}

exec { "Add featuresBoot to Karaf":
    command  => "sed -i \"/^featuresBoot=/ s/$/,onos-api,onos-core-trivial,onos-cli,onos-openflow,onos-app-fwd,onos-app-mobility,onos-gui/\" /home/vagrant/karaf/etc/org.apache.karaf.features.cfg",
    cwd      => "/home/vagrant/karaf/etc/",
    user     => "vagrant",
    timeout  => "0",
    logoutput => true,
    unless   => "grep -q \"onos-api,onos-core-trivial,onos-cli,onos-openflow,onos-app-fwd,onos-app-mobility,onos-gui\" /home/vagrant/karaf/etc/org.apache.karaf.features.cfg",
    require  => File["/home/vagrant/karaf"],
}

exec { "Copy ONOS jar to Karaf":
    command  => "cp onos-branding-1.1.0-SNAPSHOT.jar /home/vagrant/karaf/lib/",
    cwd      => "/home/vagrant/onos/tools/package/branding/target/",
    user     => "vagrant",
    timeout  => "0",
    logoutput => true,
    unless   => "test -f /home/vagrant/karaf/lib/onos-branding-1.1.0-SNAPSHOT.jar",
    require  => Exec["Add featuresBoot to Karaf"],
}

