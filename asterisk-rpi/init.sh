#!/usr/bin/env sh
set -eu

if [ ! -d /var/lib/asterisk/sounds ]; then
    cp -r /var/lib/asterisk-master/* /var/lib/asterisk/
fi

if [ ! -e /etc/asterisk/modules.conf ]; then
    cp -r /etc/asterisk-master/* /etc/asterisk/
fi

exec /usr/sbin/asterisk -f
