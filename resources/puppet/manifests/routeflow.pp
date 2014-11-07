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
          "build-essential",
          "debhelper",
          "python-software-properties",
          "dkms",
          "fakeroot",
          "graphviz",
          "linux-headers-generic",
          "python-all",
          "python-qt4",
          "python-zopeinterface",
          "python-twisted-conch",
          "python-twisted-web",
          "xauth",
          "maven",
          "git",
          "libboost-dev",
          "libboost-program-options-dev",
          "libboost-thread-dev",
          "libboost-filesystem-dev",
          "iproute-dev",
          "openvswitch-switch",
          "mongodb",
          "python-pymongo",
          "lxc",
]

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

### Apt Update
#exec { "apt-update":
#    command => "/usr/bin/apt-get update",
#    user    => "root",
#    timeout  => "0",
#}

package { $deps:
    ensure   => installed,
}

### Oracle Java/JDK 7
apt::ppa { "ppa:webupd8team/java": }
package { "oracle-java7-installer":
    ensure  => installed,
    responsefile => "/vagrant/resources/puppet/files/oracle-java.preseed",
    require => Apt::Ppa["ppa:webupd8team/java"],
}
exec{ "update-java-alternatives -s java-7-oracle":
    require => Package["oracle-java7-installer"],
    timeout  => "0",
}

### RouteFlow & OpenDaylight-rfproxy
vcsrepo { "/home/vagrant/RouteFlow-Test/RouteFlow":
    ensure   => present,
    provider => git,
    user     => "vagrant",
    source   => "https://github.com/CPqD/RouteFlow.git",
    revision => "3f406b9c1a0796f40a86eb1194990cdd2c955f4d",
}

vcsrepo { "/home/vagrant/RouteFlow-Test/rfproxy-odl-plugin":
    ensure   => present,
    provider => git,
    user     => "vagrant",
    source   => "https://github.com/routeflow/odl-rfproxy.git",
    revision => "0c8074dbe6332792c0532d253d6fb82e44c9a86c",
}

vcsrepo { "/home/vagrant/RouteFlow-Test/opendaylight-with-rfproxy":
    ensure   => present,
    provider => git,
    user     => "vagrant",
    source   => "https://git.opendaylight.org/gerrit/p/controller.git",
    revision => "5ed4ad773ce1bdd1a1511fe8ce66e0db00ae0a3b",
}

exec  { "Copy RF-Proxy-Source":
    command  => "cp -af pom.xml ../opendaylight-with-rfproxy/opendaylight/ && cp -af src ../opendaylight-with-rfproxy/opendaylight/",
    user     => "vagrant",
    cwd      => "/home/vagrant/RouteFlow-Test/rfproxy-odl-plugin",
    timeout  => "0",
    require  => [Vcsrepo["/home/vagrant/RouteFlow-Test/rfproxy-odl-plugin"], Vcsrepo["/home/vagrant/RouteFlow-Test/opendaylight-with-rfproxy"]],
}

$odl_rfproxy_pom = "/home/vagrant/RouteFlow-Test/opendaylight-with-rfproxy/opendaylight/distribution/opendaylight/pom.xml"
file { "Put RF-Proxy`s pom.xml":
    path     => $odl_rfproxy_pom,
    owner    => "vagrant",
    group    => "vagrant",
    source   => "/vagrant/resources/puppet/files/pom-odl.xml",
    replace  => true,
    require  => Vcsrepo["/home/vagrant/RouteFlow-Test/opendaylight-with-rfproxy"],
}

exec  { "Build RFProxy":
    #command  => "echo 'Starting Build RFProxy...' && mvn clean -q install -DskipTests -e",
    command  => "mvn clean install -DskipTests -e",
    user     => "vagrant",
    cwd      => "/home/vagrant/RouteFlow-Test/opendaylight-with-rfproxy/opendaylight",
    logoutput => true,
    timeout  => "0",
    require  => [File["Put RF-Proxy`s pom.xml"], Exec["Copy RF-Proxy-Source"]],
}

exec  { "Build ODL":
    #command  => "echo 'Starting Build ODL...' && mvn clean -q install -DskipTests  -Dmaven.compile.fork=true",
    command  => "mvn clean install -DskipTests  -Dmaven.compile.fork=true",
    user     => "vagrant",
    cwd      => "/home/vagrant/RouteFlow-Test/opendaylight-with-rfproxy/opendaylight/distribution/opendaylight/",
    logoutput => true,
    timeout  => "0",
    require  => Exec["Build RFProxy"],
}

exec  { "Make RouteFlow-Tests":
    command  => "make rfclient",
    user     => "vagrant",
    cwd      => "/home/vagrant/RouteFlow-Test/RouteFlow",
    logoutput => true,
    timeout  => "0",
    require  => Exec["Build ODL"],
}

exec  { "Build LXC-Env.":
    command  => "bash create",
    user     => "root",
    cwd      => "/home/vagrant/RouteFlow-Test/RouteFlow/rftest",
    logoutput => true,
    timeout  => "0",
    require  => Exec["Make RouteFlow-Tests"],
}
