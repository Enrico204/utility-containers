ARG ADMINER_VERSION
FROM docker.io/library/adminer:${ADMINER_VERSION}-fastcgi

ENV LIGHTTP_PORT=7070

USER root
RUN apk add lighttpd

COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
USER adminer

CMD ["/bin/sh", "-c", "php-fpm & lighttpd -D -f /etc/lighttpd/lighttpd.conf"]