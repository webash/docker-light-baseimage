#!/bin/bash -e
log-helper level eq trace && set -x

# If /dev/log is either a named pipe or it was placed there accidentally,
# e.g. because of the issue documented at https://github.com/phusion/baseimage-docker/pull/25,
# then we remove it.
if [ ! -S /dev/log ]; then rm -f /dev/log; fi
if [ ! -S /var/lib/syslog-ng/syslog-ng.ctl ]; then rm -f /var/lib/syslog-ng/syslog-ng.ctl; fi

# determine output mode on /dev/stdout because of the issue documented at https://github.com/phusion/baseimage-docker/issues/468
if [ -p /dev/stdout ]; then
    SYSLOG_OUTPUT_MODE_DEV_STDOUT=pipe
else
    SYSLOG_OUTPUT_MODE_DEV_STDOUT=file
fi

export SYSLOG_OUTPUT_MODE_DEV_STDOUT
envsubst-templates /container/services/:syslog-ng-core/config /etc/syslog-ng

# If /var/log is writable by another user logrotate will fail
/bin/chown root:root /var/log
/bin/chmod 0755 /var/log
