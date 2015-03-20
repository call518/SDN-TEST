#### Base (Common pp) #########

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

package { "git":
    ensure => "installed"
}

package { "unzip":
    ensure => "installed"
}

#package { "dos2unix":
#    ensure   => installed,
#}

#package { "expect":
#    ensure   => installed,
#}

package { "sshpass":
    ensure   => installed,
}

case $operatingsystem {
    debian, ubuntu: { $vim_pkg = "vim" }
    centos, redhat, fedora: { $vim_pkg = "vim-enhanced" }
    default: { fail("Unrecognized operating system for webserver") }
}

case $operatingsystem {
    debian, ubuntu: { $vimrc = "/etc/vim/vimrc" }
    centos, redhat, fedora: { $vimrc = "/etc/vimrc" }
    default: { fail("Unrecognized operating system for webserver") }
}

package { $vim_pkg:
    ensure => "installed"
}

exec { "echo 'set bg=dark' >> $vimrc":
    user    => "root",
    timeout => "0",
    require => Package[ $vim_pkg ],
}

exec { "echo 'set ts=4' >> $vimrc":
    user    => "root",
    timeout => "0",
    require => Package[ $vim_pkg ],
}

$hosts = hiera("hosts")

file { "/etc/hosts":
    ensure => file,
    owner => "root",
    group => "root",
    content => template("/vagrant/resources/puppet/templates/hosts.erb")
}

exec { "cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime":
    user    => "root",
    timeout => "0",
}

