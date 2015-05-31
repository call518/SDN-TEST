####################################################
#import "base.pp"

#include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

exec { "Disable Firewall":
    command => "systemctl stop firewalld.service && systemctl disable firewalld",
    user    => "root",
    timeout => "0",
}

exec { "Disable SELINUX":
    command => "setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux",
    user    => "root",
    timeout => "0",
}

### Install Deps Packages
$deps = [
          "java-1.7.0-openjdk-devel",
          "perl-Digest-SHA",
          "uuid",
          "libxslt",
          "libcurl",
          "unixODBC",
          "lsof",
          "gtest-devel",
          "json-c",
          "json-c-devel",
]

package { $deps:
    ensure   => installed,
}

### $odl_dist_name: Read from Puppet Facter in Vagrantfile

if $odl_dist_name == "Hydrogen-Virtualization" {
    $odl_bin_name = "distributions-virtualization-0.1.1-osgipackage"
    $odl_bin_url = "https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distributions-virtualization/0.1.1/${odl_bin_name}.zip"
} elsif $odl_dist_name == "Hydrogen-SP" {
    $odl_bin_name = "distributions-serviceprovider-0.1.1-osgipackage"
    $odl_bin_url = "https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distributions-serviceprovider/0.1.1/${odl_bin_name}.zip"
} elsif $odl_dist_name == "Helium" {
    $odl_bin_name = "distribution-karaf-0.2.0-Helium"
    $odl_bin_url = "http://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.2.0-Helium/#{odl_bin_name}.zip"
} elsif $odl_dist_name == "Helium-SR1" {
    $odl_bin_name = "distribution-karaf-0.2.1-Helium-SR1"
    $odl_bin_url = "https://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.2.1-Helium-SR1/${odl_bin_name}.zip"
}

exec { "Wget ODL-Helium":
    command  => "wget ${odl_bin_url} -O ${odl_bin_name}.zip",
    creates  => "/home/vagrant/${odl_bin_name}.zip",
    cwd      => "/home/vagrant",
    user     => "vagrant",
    timeout  => "0",
}

if $odl_dist_name in "Helium-SR1" {
    $unzip_cmd = "unzip ${odl_bin_name}.zip && mv ${odl_bin_name} opendaylight"
} else {
    $unzip_cmd = "unzip ${odl_bin_name}.zip"
}

exec { "Extract ODL-Helium":
    #command => "unzip ${odl_bin_name}.zip && mv ${odl_bin_name} opendaylight",
    command => "${unzip_cmd}",
    creates => "/home/vagrant/opendaylight",
    cwd     => "/home/vagrant",
    user    => "vagrant",
    timeout => "0",
    require => Exec["Wget ODL-Helium"],
}

exec { "Extract VTN-Coordinator":
    command => "tar -jxvf `ls -1 | grep \"tar.bz2$\" | head -n 1` -C /",
    creates => "/usr/local/vtn",
    cwd     => "/home/vagrant/opendaylight/externalapps",
    user    => "root",
    timeout => "0",
    require => Exec["Extract ODL-Helium"],
}

$deps_postgresql = [
	"postgresql-libs",
	"postgresql",
	"postgresql-server",
	"postgresql-contrib",
	"postgresql-odbc",
	"java-1.7.0-openjdk",
        #"tomcat",
]

package { $deps_postgresql:
    ensure   => installed,
    require => Exec["Extract VTN-Coordinator"],
}

if "Hydrogen" in "$odl_dist_name" {

    $tomcat_path = "/usr/local/tomcat"

    exec { "Wget Tomcat":
        command => "wget http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.39/bin/apache-tomcat-7.0.39.tar.gz",
        cwd     => "/usr/local",
        creates => "/usr/local/apache-tomcat-7.0.39.tar.gz",
        user    => "root",
        timeout => "0",
        require => Package["postgresql"],
    }

    exec { "Extract Tomcat":
        command => "tar zxf apache-tomcat-7.0.39.tar.gz",
        cwd     => "/usr/local",
        creates => "/usr/local/apache-tomcat-7.0.39",
        user    => "root",
        timeout => "0",
        require => Exec["Wget Tomcat"],
    }

    file { "/usr/local/tomcat":
        ensure   => link,
        target   => "/usr/local/apache-tomcat-7.0.39",
        owner    => "root",
        group    => "root",
        replace  => true,
        require => Exec["Extract Tomcat"],
    }

    exec { "Clear Default webapps":
        command => "rm -rf /usr/local/tomcat/webapps/*",
        cwd     => "/usr/local/tomcat/webapps",
        user    => "root",
        timeout => "0",
        require => File["/usr/local/tomcat"],
    }

    file { "${tomcat_path}/webapps/vtn-webapi":
        ensure   => link,
        target   => "/usr/local/vtn/tomcat/webapps/vtn-webapi",
        owner    => "root",
        group    => "root",
        replace  => true,
        require => File["/usr/local/tomcat"],
    }

    file { "config ${tomcat_path}/conf/catalina.properties":
        path    => "${tomcat_path}/conf/catalina.properties",
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => 0755,
        content => template("/vagrant/resources/puppet/templates/catalina.properties.erb"),
        require => File["/usr/local/tomcat"],
    }

    file { "config ${tomcat_path}/conf/server.xml":
        path    => "${tomcat_path}/conf/server.xml",
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => 0755,
        content => template("/vagrant/resources/puppet/templates/server.xml.erb"),
        require => File["/usr/local/tomcat"],
    }
}

#exec { "Setup VTN DB":
#    command => "/usr/local/vtn/sbin/db_setup && touch /root/.created-vtn-db.mark",
#    creates => "/root/.created-vtn-db.mark",
#    cwd     => "/usr/local/vtn/sbin",
#    user    => "root",
#    timeout => "0",
#    require => Package[ $deps_postgresql ],
#}

exec { "Setup VTN DB":
    command => "/usr/local/vtn/sbin/db_setup",
    user    => "root",
    timeout => "0",
    require => Package[ $deps_postgresql ],
}

#exec { "Start VTN Coordinator":
#    command => "bash -c 'if [ `jps | grep -c \"Bootstrap\"` -eq 0 ]; then /usr/local/vtn/bin/vtn_start; fi'",
#    cwd     => "/usr/local/vtn/sbin",
#    user    => "root",
#    timeout => "0",
#    require => Exec["Setup VTN DB"],
#}

exec { "Start VTN Coordinator":
    command => "/usr/local/vtn/bin/vtn_start",
    user    => "root",
    timeout => "0",
    returns => [0, 1],
    require => Exec["Setup VTN DB"],
}

#service { "tomcat":
#    ensure   => "running",
#    enable   => "true",
#    require  => [ Package["tomcat"], Exec["Start VTN Coordinator"] ],
#}

if "Hydrogen" in "$odl_dist_name" {
    exec { "Start VTN Tomcat":
        command => "/usr/local/tomcat/bin/catalina.sh start",
        user    => "root",
        timeout => "0",
        require => Exec["Start VTN Coordinator"],
    }
}

file { "Put RESTconf-VTN-Tutorial-2":
    path     => "/home/vagrant/RESTconf-VTN-Tutorial-2",
    owner    => "vagrant",
    group    => "vagrant",
    mode     => 0755,
    source   => "/vagrant/resources/puppet/files/RESTconf-VTN-Tutorial-2",
    ensure   => directory,
    replace  => true,
    recurse  => true,
}
