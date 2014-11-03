#### Base (Common pp) #########

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

package {"git":
    ensure => "installed"
}

$hosts = hiera("hosts")

file { "/etc/hosts":
    ensure => file,
    owner => "root",
    group => "root",
    content => template("/vagrant/resources/puppet/templates/hosts.erb")
}

package { "dos2unix":
    ensure   => installed,
    require  => File["/etc/hosts"],
}

exec { "dos2unix /etc/hosts":
    cwd     => "/etc",
    user    => "root",
    timeout => "0",
    require => Package["dos2unix"],
}
