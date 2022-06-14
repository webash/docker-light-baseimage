#!/bin/sh -e
# This file is used only during the image build and deleted at the end.

## Add tools to /sbin
ln -s /container/tools/* /sbin/

# Create image default directories.
mkdir -p /container/environment \
         /container/services \
         /container/entrypoint /container/entrypoint/startup /container/entrypoint/process /container/entrypoint/finish \
         /container/var /container/var/state

# Install required packages.
packages-index-update

packages-install-clean apt-utils apt-transport-https ca-certificates software-properties-common \
locales python3-minimal python3-dotenv gettext-base jq eatmydata

# Set locale.
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen en_US 2>&1 | log-helper info
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

# Clean.
rm -rf /tmp/* /var/tmp/* /container/build /container/Dockerfile
