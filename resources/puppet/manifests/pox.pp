####################################################
#import "base.pp"

include apt

### Export Env: Global %PATH for "Exec"
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

## Debian/Ubuntu
$deps = [
	"git",
	"python-numpy",
	"python-matplotlib",
]

package { $deps:
    ensure   => installed,
}

$POX_DIR = "/home/vagrant/pox"
vcsrepo { "${$POX_DIR}":
    provider => git,
    ensure => present,
    user => "vagrant",
    source => "http://github.com/noxrepo/pox",
}

exec { "Put POX Example Run Command":
    command => "echo './pox.py log.level --=INFO topology forwarding.l2_learning' > run-pox.cmd",
    cwd     => "${$POX_DIR}",
    user    => "vagrant",
    timeout => "0",
    logoutput => true,
    require => Vcsrepo["${$POX_DIR}"],
}
