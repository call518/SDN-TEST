#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu 12.04 LTS.
#
set -e

## Load up the release information
. /etc/lsb-release

#REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb"
REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-stable.deb"

#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

## Edit Apt-Repo. Address
#cp -a /etc/apt/sources.list /etc/apt/sources.list.vagrant-bak
#sed -i 's/kr.archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list 2> /dev/null
#sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list 2> /dev/null
#sed -i 's/security.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list 2> /dev/null
#sed -i 's/extras.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list 2> /dev/null

## Do the initial apt-get update
echo "Initial apt-get update..."
apt-get update >/dev/null

## Install wget if we have to (some older Ubuntu versions)
echo "Installing wget..."
apt-get install -y wget >/dev/null

## Install unzip
echo "Installing unzip..."
apt-get install -y unzip >/dev/null

#if which puppet > /dev/null 2>&1 -a apt-cache policy | grep --quiet apt.puppetlabs.com; then
#if which puppet > /dev/null 2>&1; then
if [ `puppet -V | cut -d. -f1` -ge 3 ]; then 
  echo "Puppet is already installed."
else
  ## Install the PuppetLabs repo
  echo "Configuring PuppetLabs repo..."
  repo_deb_path=$(mktemp)
  wget --output-document="${repo_deb_path}" "${REPO_DEB_URL}" 2>/dev/null
  dpkg -i "${repo_deb_path}" >/dev/null
  apt-get update >/dev/null
  
  ## Install Puppet
  echo "Installing Puppet..."
  DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install puppet >/dev/null
  sed -i 's/^templatedir=/#templatedir=/g' /etc/puppet/puppet.conf
  
  echo "Puppet installed!"
  
  ## Install RubyGems for the provider
  echo "Installing RubyGems..."
  if [ $DISTRIB_CODENAME != "trusty" ]; then
    apt-get install -y rubygems >/dev/null
  fi
  gem install --no-ri --no-rdoc rubygems-update
  update_rubygems >/dev/null
fi

## Installing Puppet Modules
#puppet module install --force puppetlabs/vcsrepo
#puppet module install --force puppetlabs/stdlib
#puppet module install --force puppetlabs/apt
puppet module install --force /vagrant/resources/puppet/files/puppetlabs-vcsrepo-1.1.0.tar.gz --ignore-dependencies
puppet module install --force /vagrant/resources/puppet/files/puppetlabs-stdlib-4.3.2.tar.gz --ignore-dependencies
puppet module install --force /vagrant/resources/puppet/files/puppetlabs-apt-1.6.0.tar.gz --ignore-dependencies
