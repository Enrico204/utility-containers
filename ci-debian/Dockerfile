ARG DEBIAN_VERSION
FROM docker.io/library/debian:${DEBIAN_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'deb http://deb.debian.org/debian bookworm-backports main' > /etc/apt/sources.list.d/backports.list
RUN apt-get update -yq && \
    apt-get dist-upgrade -yq && \
    apt-get install -yq lsb-release build-essential fakeroot debhelper \
        wget curl jq equivs gettext-base ca-certificates unzip openssh-client \
        devscripts debian-keyring libdistro-info-perl quilt pkg-config \
        git skopeo && \
	apt-get install -yq -t $(lsb_release -sc 2>/dev/null)-backports golang && \
	rm -rf /var/lib/apt/lists/*

COPY mynet.pem /usr/local/share/ca-certificates/mynet.crt
RUN update-ca-certificates
