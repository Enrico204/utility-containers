#!/usr/bin/env bash
set -eou pipefail

. /etc/os-release

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
deb $apt_mirror/debian/ $VERSION_CODENAME main contrib non-free
deb $apt_mirror/debian-security $VERSION_CODENAME-security main contrib non-free
deb $apt_mirror/debian/ $VERSION_CODENAME-updates main contrib non-free
#deb $apt_mirror/debian/ $VERSION_CODENAME-backports main contrib non-free
EOF
    fi
fi

cat >> /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian/ $VERSION_CODENAME main non-free contrib
deb http://security.debian.org/debian-security $VERSION_CODENAME-security main contrib non-free
deb http://deb.debian.org/debian/ $VERSION_CODENAME-updates main contrib non-free
#deb http://deb.debian.org/debian/ $VERSION_CODENAME-backports main contrib non-free
EOF
