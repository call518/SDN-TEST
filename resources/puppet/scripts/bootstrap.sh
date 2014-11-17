#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu 12.04 LTS.
#
set -e

## Installing Puppet Modules
puppet module install --force puppetlabs/vcsrepo
puppet module install --force puppetlabs/stdlib
puppet module install --force puppetlabs/apt
puppet module install --force puppetlabs/firewall
#puppet module install --force /vagrant/resources/puppet/files/puppetlabs-vcsrepo-1.1.0.tar.gz --ignore-dependencies
#puppet module install --force /vagrant/resources/puppet/files/puppetlabs-stdlib-4.3.2.tar.gz --ignore-dependencies
#puppet module install --force /vagrant/resources/puppet/files/puppetlabs-apt-1.6.0.tar.gz --ignore-dependencies
#puppet module install --force /vagrant/resources/puppet/files/puppetlabs-firewall-1.2.0.tar.gz --ignore-dependencies
