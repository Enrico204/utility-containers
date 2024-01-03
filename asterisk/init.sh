#!/usr/bin/env sh
set -eu

cp -r /var/lib/asterisk-master/* /var/lib/asterisk/

if [ ! -e /etc/asterisk/modules.conf ]; then
    cp -r /etc/asterisk-master/* /etc/asterisk/
fi

exec /usr/sbin/asterisk -f