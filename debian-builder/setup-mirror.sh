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
deb $apt_mirror/debian/ $VERSION_CODENAME-backports main contrib non-free
EOF
    fi
fi

case $VERSION_CODENAME in
    stretch)
        cat >> /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian/ stretch main non-free contrib
deb http://security.debian.org/debian-security stretch/updates main contrib non-free
deb http://deb.debian.org/debian/ stretch-updates main contrib non-free
deb http://deb.debian.org/debian/ stretch-backports main contrib non-free
EOF
        ;;
    buster)
        cat >> /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian/ buster main non-free contrib
deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb http://deb.debian.org/debian/ buster-updates main contrib non-free
deb http://deb.debian.org/debian/ buster-backports main contrib non-free
EOF
        ;;
    bullseye)
        cat >> /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian/ bullseye main non-free contrib
deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb http://deb.debian.org/debian/ bullseye-backports main contrib non-free
EOF
        ;;
    bookworm)
        cat >> /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian/ bookworm main non-free contrib
deb http://security.debian.org/debian-security bookworm-security main contrib non-free
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free
deb http://deb.debian.org/debian/ bookworm-backports main contrib non-free
EOF
        ;;
    *)
        echo "Not supported by setup-mirror.sh"
        exit 1
        ;;
esac
