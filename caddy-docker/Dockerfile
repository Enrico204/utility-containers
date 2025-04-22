FROM docker.io/library/golang:1.24 AS builder

RUN apt-get update -yq && \
	apt-get install -qy debian-keyring debian-archive-keyring apt-transport-https ca-certificates curl && \
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-xcaddy-archive-keyring.gpg && \
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-xcaddy.list && \
	apt-get update -yq && \
	apt-get install -yq xcaddy

ARG CADDY_VERSION
ARG CADDY_DOCKER_VERSION
RUN CGO_ENABLED=0 GOOS=linux \
    xcaddy build v$CADDY_VERSION \
    --output /caddy \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@v$CADDY_DOCKER_VERSION \
	--with github.com/caddy-dns/hetzner \
	--with github.com/caddy-dns/bunny


FROM scratch

EXPOSE 80 443

ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /caddy /

ENTRYPOINT ["/caddy"]
CMD ["docker-proxy"]

