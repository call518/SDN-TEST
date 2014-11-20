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
#$deps = [
#          "build-essential",
#          "debhelper",
#          "python-software-properties",
#          "dkms",
#          "fakeroot",
#          "graphviz",
#          "linux-headers-generic",
#          "python-all",
#          "python-qt4",
#          "python-zopeinterface",
#          "python-twisted-conch",
#          "python-twisted-web",
#          "xauth",
#]

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

### Apt Update
#exec { "apt-update":
#    command => "/usr/bin/apt-get update",
#    user    => "root",
#    timeout => "0",
#}

#package { $deps:
#    ensure   => installed,
#}

### Oracle Java/JDK 7
apt::ppa { "ppa:webupd8team/java": }
package { "oracle-java7-installer":
    ensure  => installed,
    responsefile => "/vagrant/resources/puppet/files/oracle-java.preseed",
    require => Apt::Ppa["ppa:webupd8team/java"],
}
exec{ "update-java-alternatives -s java-7-oracle":
    require => Package["oracle-java7-installer"],
    timeout => "0",
}
$java_home = "/usr/lib/jvm/java-7-oracle"
file { "/etc/profile.d/java_home.sh":
    ensure  => present,
    content => "export JAVA_HOME=\"${java_home}\"";
}

$odl_dist_helium_name = "0.2.0-Helium"
exec { "Wget ODL-Helium":
    #command  => "wget http://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/${odl_dist_helium_name}/distribution-karaf-${odl_dist_helium_name}.zip",
    #command  => "wget https://plink.ucloud.com/public_link/link/b148140a7e1d5c15 -O distribution-karaf-${odl_dist_helium_name}.zip",
    command  => "wget http://172.21.18.11/files/distribution-karaf-0.2.0-Helium.zip -O distribution-karaf-${odl_dist_helium_name}.zip",
    creates  => "/home/vagrant/distribution-karaf-${odl_dist_helium_name}.zip",
    cwd      => "/home/vagrant",
    user     => "vagrant",
    timeout  => "0",
}

exec { "Extract ODL-Helium":
    command => "unzip distribution-karaf-${odl_dist_helium_name}.zip && mv distribution-karaf-${odl_dist_helium_name} opendaylight",
    creates => "/home/vagrant/opendaylight",
    cwd     => "/home/vagrant",
    user    => "vagrant",
    timeout => "0",
    require => Exec["Wget ODL-Helium"],
}

exec { "Patch JMX Error":
    command => "sed -i 's/0.0.0.0/127.0.0.1/g' org.apache.karaf.management.cfg",
    cwd     => "/home/vagrant/opendaylight/etc",
    user    => "vagrant",
    timeout => "0",
    require => Exec["Extract ODL-Helium"],
}

#exec { "Disable Auth":
#    command => "sed -i 's/^authEnabled=.*/authEnabled=false/g' org.opendaylight.aaa.authn.cfg",
#    cwd     => "/home/vagrant/opendaylight/etc",
#    user    => "vagrant",
#    timeout => "0",
#    require => Exec["Extract ODL-Helium"],
#}

file { "Put ODL-Helium-Run-Script":
    path     => "/home/vagrant/opendaylight/run-karaf.sh",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0755,
    source   => "/vagrant/resources/puppet/files/run-karaf.sh",
    replace  => true,
    require  => Exec["Extract ODL-Helium"],
}

exec { "dos2unix run-karaf.sh":
    cwd     => "/home/vagrant/opendaylight",
    user    => "root",
    timeout => "0",
    require => File["Put ODL-Helium-Run-Script"],
}

file { "Put RESTconf-VTN":
    path     => "/home/vagrant/RESTconf-VTN",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0755,
    source   => "/vagrant/resources/puppet/files/RESTconf-VTN",
    ensure   => directory,
    replace  => true,
    recurse  => true,
}
