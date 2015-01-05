####################################################
#import "base.pp"

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

### Oracle Java/JDK 7
apt::ppa { "ppa:webupd8team/java": }

exec { "apt-update":
    command => "/usr/bin/apt-get update",
    user    => "root",
    timeout => "0",
    require => Apt::Ppa["ppa:webupd8team/java"],
}

package { "oracle-java7-installer":
    ensure  => installed,
    responsefile => "/vagrant/resources/puppet/files/oracle-java7.preseed",
    #require => Apt::Ppa["ppa:webupd8team/java"],
    require => Exec["apt-update"],
}

#exec{ "update-java-alternatives -s java-7-oracle":
#    timeout => "0",
#    require => Package["oracle-java7-installer"],
#}

package { "oracle-java8-set-default":
    ensure  => installed,
    #require => Apt::Ppa["ppa:webupd8team/java"],
    #require => Exec["apt-update"],
    require => Package["oracle-java7-installer"],
}

#$java_home = "/usr/lib/jvm/java-7-oracle"
#file { "/etc/profile.d/java_home.sh":
#    ensure  => present,
#    content => "export JAVA_HOME=\"${java_home}\"",
#    require => Exec["update-java-alternatives -s java-7-oracle"],
#    require => Package["oracle-java7-set-default"],
#}
