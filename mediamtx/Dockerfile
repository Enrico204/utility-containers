FROM docker.io/library/debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget ffmpeg tar gzip && rm -rf /var/cache/apt/*

ARG MEDIAMTX_VERSION
ARG ARCH=$(dpkg --print-architecture)
RUN wget https://github.com/bluenviron/mediamtx/releases/download/v${MEDIAMTX_VERSION}/mediamtx_v${MEDIAMTX_VERSION}_linux_amd64.tar.gz -O /tmp/mediamtx.tgz && \
    tar xvf /tmp/mediamtx.tgz -C /usr/local/bin/ mediamtx

USER 1000

ENTRYPOINT [ "/usr/local/bin/mediamtx" ]
