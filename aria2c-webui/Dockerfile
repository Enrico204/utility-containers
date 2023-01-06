FROM docker.io/library/alpine:3.17.0 AS builder
RUN apk add --no-cache git
RUN git clone https://github.com/ziahamza/webui-aria2.git /app


FROM docker.io/library/caddy:2.6.2-alpine
RUN apk add --no-cache sed tini
COPY --from=builder /app/docs/ /usr/share/caddy/
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/sbin/tini", "-v", "--", "/docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]