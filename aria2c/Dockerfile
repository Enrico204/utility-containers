FROM docker.io/library/alpine:3.17.0

EXPOSE 6800
VOLUME /storage

RUN apk add --no-cache aria2 tini
COPY docker-entrypoint.sh /docker-entrypoint.sh

# When using this image, set the $RPCSECRET environment variable

ENTRYPOINT ["/sbin/tini", "-v", "--", "/docker-entrypoint.sh"]