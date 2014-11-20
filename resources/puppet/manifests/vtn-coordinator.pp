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
]

package { $deps:
    ensure   => installed,
}

#$odl_dist_helium_name = "0.2.0-Helium"
$odl_dist_helium_name = "0.2.1-Helium-SR1"
exec { "Wget ODL-Helium":
    #command  => "wget http://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/${odl_dist_helium_name}/distribution-karaf-${odl_dist_helium_name}.zip",
    command  => "wget http://172.21.18.11/files/distribution-karaf-${odl_dist_helium_name}.zip -O distribution-karaf-${odl_dist_helium_name}.zip", ## (Intra)
    #command  => "wget https://plink.ucloud.com/public_link/link/b148140a7e1d5c15 -O distribution-karaf-${odl_dist_helium_name}.zip", ## Helium (uCloud)
    #command  => "wget https://plink.ucloud.com/public_link/link/a6b154dfe9076714 -O distribution-karaf-${odl_dist_helium_name}.zip", ## Helium-SR1 (uCloud)
    creates  => "/home/vagrant/distribution-karaf-${odl_dist_helium_name}.zip",
    cwd      => "/home/vagrant",
    user     => "vagrant",
    timeout  => "0",
    require  => Package[ $deps ],
}

exec { "Extract ODL-Helium":
    command => "unzip distribution-karaf-${odl_dist_helium_name}.zip && mv distribution-karaf-${odl_dist_helium_name} opendaylight",
    creates => "/home/vagrant/opendaylight",
    cwd     => "/home/vagrant",
    user    => "vagrant",
    timeout => "0",
    require => Exec["Wget ODL-Helium"],
}

exec { "Extract VTN-Coordinator":
    command => "tar -jxvf distribution.vtn-coordinator-6.0.0.0-Helium-bin.tar.bz2 -C /",
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
	"java-1.7.0-openjdk"
]

package { $deps_postgresql:
    ensure   => installed,
    require => Exec["Extract VTN-Coordinator"],
}

exec { "Setup VTN DB":
    command => "/usr/local/vtn/sbin/db_setup && touch /root/.created-vtn-db.mark",
    creates => "/root/.created-vtn-db.mark",
    cwd     => "/usr/local/vtn/sbin",
    user    => "root",
    timeout => "0",
    require => Package[ $deps_postgresql ],
}

exec { "Start VTN Coordinator":
    command => "bash -c 'if [ `jps | grep -c \"Bootstrap\"` -eq 0 ]; then /usr/local/vtn/bin/vtn_start; fi'",
    cwd     => "/usr/local/vtn/sbin",
    user    => "root",
    timeout => "0",
    require => Exec["Setup VTN DB"],
}
