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

### $odl_dist_name: Read from Puppet Facter in Vagrantfile

if $odl_dist_name == "Hydrogen-Virtualization" {
    $odl_bin_name = "distributions-virtualization-0.1.1-osgipackage"
    #$odl_bin_url = "https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distributions-virtualization/0.1.1/${odl_bin_name}.zip"
    $odl_bin_url = "http://172.21.18.11/files/${odl_bin_name}.zip"
} elsif $odl_dist_name == "Hydrogen-SP" {
    $odl_bin_name = "distributions-serviceprovider-0.1.1-osgipackage"
    #$odl_bin_url = "https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distributions-serviceprovider/0.1.1/${odl_bin_name}.zip"
    $odl_bin_url = "http://172.21.18.11/files/${odl_bin_name}.zip"
} elsif $odl_dist_name == "Helium" {
    $odl_bin_name = "distribution-karaf-0.2.0-Helium"
    #$odl_bin_url = "http://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.2.0-Helium/#{odl_bin_name}.zip"
    $odl_bin_url = "http://172.21.18.11/files/${odl_bin_name}.zip"
} elsif $odl_dist_name == "Helium-SR1" {
    $odl_bin_name = "distribution-karaf-0.2.1-Helium-SR1"
    #$odl_bin_url = "https://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.2.1-Helium-SR1/${odl_bin_name}.zip"
    $odl_bin_url = "http://172.21.18.11/files/${odl_bin_name}.zip"
}

exec { "Wget ODL-Helium":
    command  => "wget ${odl_bin_url}",
    creates  => "/home/vagrant/${odl_bin_name}.zip",
    cwd      => "/home/vagrant",
    user     => "vagrant",
    timeout  => "0",
}

exec { "Extract ODL-Helium":
    command => "unzip ${odl_bin_name}.zip && mv ${odl_bin_name} opendaylight",
    creates => "/home/vagrant/opendaylight",
    cwd     => "/home/vagrant",
    user    => "vagrant",
    timeout => "0",
    require => Exec["Wget ODL-Helium"],
}

#if $odl_dist_name == "Helium" or $odl_dist_name == "Helium-SR1" {
if $odl_dist_name in "Helium-SR1" {
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
}

file { "Put RESTconf-VTN-Tutorial-1":
    path     => "/home/vagrant/RESTconf-VTN-Tutorial-1",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0755,
    source   => "/vagrant/resources/puppet/files/RESTconf-VTN-Tutorial-1",
    ensure   => directory,
    replace  => true,
    recurse  => true,
}

file { "Put RESTconf-VTN-Tutorial-2":
    path     => "/home/vagrant/RESTconf-VTN-Tutorial-2",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0755,
    source   => "/vagrant/resources/puppet/files/RESTconf-VTN-Tutorial-1",
    ensure   => directory,
    replace  => true,
    recurse  => true,
}

$hosts = hiera("hosts")

file { "Put m2m-1.py":
    path    => "/home/vagrant/RESTconf-VTN-Tutorial-2/m2m-1.py",
    ensure  => present,
    owner   => "vagrant",
    group   => "vagrant",
    mode    => 0755,
    content => template("/vagrant/resources/puppet/templates/m2m-1.py.erb"),
    require => File["Put RESTconf-VTN-Tutorial-2"],
}

file { "Put m2m-2.py":
    path    => "/home/vagrant/RESTconf-VTN-Tutorial-2/m2m-2.py",
    ensure  => present,
    owner   => "vagrant",
    group   => "vagrant",
    mode    => 0755,
    content => template("/vagrant/resources/puppet/templates/m2m-2.py.erb"),
    require => File["Put RESTconf-VTN-Tutorial-2"],
}

exec { "dos2unix /home/vagrant/RESTconf-VTN-Tutorial-2/m2m-*":
    cwd     => "/etc",
    user    => "root",
    timeout => "0",
    require => [ File["Put m2m-1.py"], File["Put m2m-2.py"] ],
}
