#### Base (Common pp) #########

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

package {"git":
    ensure => "installed"
}

package {"vim":
    ensure => "installed"
}

package {"unzip":
    ensure => "installed"
}

package { "dos2unix":
    ensure   => installed,
}

#package { "expect":
#    ensure   => installed,
#}

exec { "echo 'set bg=dark' >> /etc/vim/vimrc":
    user    => "root",
    timeout => "0",
    require => Package["vim"],
}

exec { "echo 'set ts=4' >> /etc/vim/vimrc":
    user    => "root",
    timeout => "0",
    require => Package["vim"],
}

$hosts = hiera("hosts")

file { "/etc/hosts":
    ensure => file,
    owner => "root",
    group => "root",
    content => template("/vagrant/resources/puppet/templates/hosts.erb")
}

exec { "dos2unix /etc/hosts":
    cwd     => "/etc",
    user    => "root",
    timeout => "0",
    require => Package["dos2unix"],
}
