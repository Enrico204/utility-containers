FROM docker.io/library/alpine:3.19.1

RUN apk add --no-cache dnsmasq

VOLUME /cfg
VOLUME /data

CMD ["/usr/sbin/dnsmasq", "-d", "-C", "/cfg/dnsmasq.conf", "--dhcp-leasefile=", "/data/leases"]
