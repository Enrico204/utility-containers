FROM docker.io/library/debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget ffmpeg tar gzip && rm -rf /var/cache/apt/*

RUN wget https://github.com/bluenviron/mediamtx/releases/download/v0.23.3/mediamtx_v0.23.3_linux_amd64.tar.gz -O /tmp/mediamtx.tgz && \
    tar xvf /tmp/mediamtx.tgz -C /usr/local/bin/ mediamtx

USER 1000

ENTRYPOINT [ "/usr/local/bin/mediamtx" ]
