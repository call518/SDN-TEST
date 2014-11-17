####################################################
#import "base.pp"

#include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

### Install Deps Packages
$deps = [
          "java-1.7.0-openjdk-devel",
          "perl-Digest-SHA",
          "uuid",
          "libxslt",
          "libcurl",
          "unixODBC",
]

package { $deps:
    ensure   => installed,
}

$odl_dist_helium_name = "0.2.0-Helium"
exec { "Wget ODL-Helium":
    #command  => "wget http://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/${odl_dist_helium_name}/distribution-karaf-${odl_dist_helium_name}.zip",
    command  => "wget https://plink.ucloud.com/public_link/link/964911f1d9fdb9d5 -O distribution-karaf-${odl_dist_helium_name}.zip",
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
    command => "/usr/local/vtn/bin/vtn_stop && /usr/local/vtn/bin/vtn_start",
    cwd     => "/usr/local/vtn/sbin",
    user    => "root",
    timeout => "0",
    require => Exec["Setup VTN DB"],
}
