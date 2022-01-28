#!/bin/sh -e
# This file is used only during the image build and deleted at the end

## Add bash tools to /sbin
ln -s /container/tools/* /sbin/

## Create image default directories
mkdir -p /container/environment \
         /container/service \
         /container/run /container/run/startup /container/run/process /container/run/finish \
         /container/run/var /container/run/var/state

# General config
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no

apt-get update

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot

## Install apt-utils.
apt-get install -y --no-install-recommends apt-utils apt-transport-https ca-certificates software-properties-common \
locales python3-minimal python3-dotenv gettext-base jq eatmydata

## Upgrade all packages.
apt-get dist-upgrade -y --no-install-recommends -o Dpkg::Options::="--force-confold"

# Fix locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen en_US
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

apt-get clean
rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Remove useless files
rm -rf /container/build
