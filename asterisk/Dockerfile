ARG ALPINE_VERSION
FROM docker.io/library/alpine:${ALPINE_VERSION} AS g729builder

ARG BCG729_VERSION
ARG ASTERISK_MAJOR

RUN apk add --no-cache asterisk-dev build-base git cmake make automake autoconf libtool

RUN git clone https://github.com/BelledonneCommunications/bcg729 /usr/src/bcg729 && \
    cd /usr/src/bcg729 && \
    git checkout tags/${BCG729_VERSION} &&\
    cmake . -DCMAKE_INSTALL_PREFIX=/usr && \
    make && \
    make install

RUN mkdir -p /usr/src/asterisk-g72x && \
    git clone https://github.com/arkadijs/asterisk-g72x /usr/src/asterisk-g72x && \
    cd /usr/src/asterisk-g72x && \
    ./autogen.sh && \
    if [ $(arch) == aarch64 ]; then ./configure --with-bcg729 --with-asterisk${ASTERISK_MAJOR}0; else ./configure --with-bcg729 --with-asterisk${ASTERISK_MAJOR}0 --enable-penryn; fi && \
    make && \
    make install



ARG ALPINE_VERSION
FROM docker.io/library/alpine:${ALPINE_VERSION}

ARG ASTERISK_VERSION

COPY init.sh /init.sh

RUN apk add --no-cache tini \
    asterisk=${ASTERISK_VERSION} \
    asterisk-curl=${ASTERISK_VERSION} \
    asterisk-fax=${ASTERISK_VERSION} \
    asterisk-mobile=${ASTERISK_VERSION} \
    asterisk-odbc=${ASTERISK_VERSION} \
    asterisk-opus=${ASTERISK_VERSION} \
    asterisk-pgsql=${ASTERISK_VERSION} \
    asterisk-sounds-en=${ASTERISK_VERSION} \
    asterisk-sounds-moh=${ASTERISK_VERSION} \
    asterisk-speex=${ASTERISK_VERSION} \
    asterisk-srtp=${ASTERISK_VERSION} \
    asterisk-tds=${ASTERISK_VERSION} \
    asterisk-sample-config \
    && mv /var/lib/asterisk /var/lib/asterisk-master \
    && mkdir /var/lib/asterisk \
    && chown asterisk:asterisk /var/lib/asterisk \
    && mv /etc/asterisk /etc/asterisk-master \
    && mkdir /etc/asterisk \
    && chown asterisk:asterisk /etc/asterisk \
    && chmod a+x /init.sh

COPY --from=g729builder /usr/lib/asterisk/modules/codec_g729.so /usr/lib/asterisk/modules/codec_g729.so
COPY --from=g729builder /usr/lib/libbcg729.so.0 /usr/lib/libbcg729.so.0
RUN ln -s /usr/lib/libbcg729.so.0 /usr/lib/libbcg729.so

USER asterisk

CMD ["/sbin/tini", "--", "/init.sh"]
