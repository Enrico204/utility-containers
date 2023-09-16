#!/usr/bin/env bash
set -eou pipefail

rm -f /etc/apt/sources.list

if [ "${1:-}" == "sysprep" ]; then
    # Remove proxy
    rm -f /etc/apt/apt.conf.d/99proxy

    # Do not add local mirrors
else
    if [ "${apt_proxy:-}" != "" ]; then
        echo "Acquire::http::Proxy \"$apt_proxy\";" > /etc/apt/apt.conf.d/99proxy
    fi

    if [ "${apt_mirror:-}" != "" ]; then
        cat > /etc/apt/sources.list <<EOF
deb $apt_mirror/debian/ bullseye main contrib non-free
deb $apt_mirror/debian-security bullseye-security main contrib non-free
deb $apt_mirror/debian/ bullseye-updates main contrib non-free
#deb $apt_mirror/debian/ bullseye-backports main contrib non-free
EOF
    fi
fi

cat >> /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian/ bullseye main non-free contrib
deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
#deb http://deb.debian.org/debian/ bullseye-backports main contrib non-free
EOF
