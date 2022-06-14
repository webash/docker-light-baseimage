#!/bin/bash -e

mkdir -p /var/lib/syslog-ng
rm -f /etc/default/syslog-ng /etc/syslog-ng/syslog-ng.conf

touch /var/log/syslog
chmod 640 /var/log/syslog

ln -sf /container/services/:syslog-ng-core/assets/config/syslog_ng_default /etc/default/syslog-ng
ln -sf /container/services/:syslog-ng-core/assets/config/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
