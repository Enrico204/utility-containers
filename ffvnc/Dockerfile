FROM debian:bullseye AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y build-essential fakeroot devscripts dpatch

RUN cat /etc/apt/sources.list | sed 's/^deb/deb-src/' > /etc/apt/sources.list.d/sources.list

WORKDIR /root/dwm/

RUN apt-get update && apt-get source dwm
RUN apt-get build-dep -y dwm

WORKDIR /root/dwm/dwm-6.1
COPY config.hidebar.h debian/local/
RUN fakeroot debian/rules binary


FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y tigervnc-standalone-server firefox-esr dwm && \
    rm -rf /var/cache/apt/*

COPY --from=builder /root/dwm/*.deb /tmp/
RUN dpkg -i /tmp/*.deb && rm /tmp/*.deb

COPY init.sh /init.sh

EXPOSE 5900

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

CMD ["/bin/bash", "/init.sh"]
