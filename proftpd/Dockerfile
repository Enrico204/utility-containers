FROM docker.io/library/debian:bullseye-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -qy --no-install-recommends proftpd proftpd-mod-crypto proftpd-mod-ldap proftpd-mod-mysql proftpd-mod-pgsql proftpd-mod-sqlite && \
    rm -rf /var/cache/apt/*

COPY proftpd.conf /etc/proftpd/conf.d/sftp.conf