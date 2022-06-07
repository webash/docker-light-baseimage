#!/bin/sh -e
log-helper level eq trace && set -x

CURRENT_SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

ln -sf "${CURRENT_SCRIPT_DIR}/:logrotate/assets/config/logrotate.conf" /etc/logrotate.conf
ln -sf "${CURRENT_SCRIPT_DIR}/:logrotate/assets/config/logrotate_syslogng" /etc/logrotate.d/syslog-ng

chmod 444 -R "${CURRENT_SCRIPT_DIR}"/:logrotate/assets/config/*
