FROM debian:bookworm-slim

RUN apt-get update -yq \
    && apt-get install -yq --no-install-recommends rsyslog \
    && rm -rf /var/cache/apt/*

CMD ["/usr/sbin/rsyslogd", "-n"]
