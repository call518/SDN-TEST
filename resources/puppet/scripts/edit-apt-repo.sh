#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu 12.04 LTS.
#
set -e

### Edit Apt-Repo. Address
if test ! -f /etc/apt/sources.list.vagrant-bak; then
  cp -a /etc/apt/sources.list /etc/apt/sources.list.vagrant-bak
fi
sed -i 's/kr.archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list 2> /dev/null
sed -i 's/us.archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list 2> /dev/null
sed -i 's/security.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list 2> /dev/null
sed -i 's/extras.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list 2> /dev/null

if sudo apt-get update; then
	echo "Success 'apt-get update'"
else
	echo "Failure 'apt-get update'"
fi
