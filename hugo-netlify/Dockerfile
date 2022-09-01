ARG HUGO_VERSION
FROM docker.io/library/node:lts-bullseye-slim
ARG HUGO_VERSION

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget && rm -rf /var/cache/apt/*

RUN export ARCH="$(uname -m)" \
    && if [ "${ARCH}" = "x86_64" ]; then export ARCH="Linux-64bit"; MINIOARCH="amd64"; \
    elif [ "${ARCH}" = "aarch64" ]; then export ARCH="Linux-ARM64"; MINIOARCH="arm64"; \
    elif [ "${ARCH}" = "armv7l" ]; then export ARCH="Linux-ARM"; MINIOARCH=""; \
    else echo $ARCH; exit 1; fi \
    && wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_${ARCH}.deb -O /tmp/hugo.deb \
    && dpkg -i /tmp/hugo.deb \
    && rm /tmp/hugo.deb \
    && npm install netlify-cli -g \
    && wget https://dl.min.io/client/mc/release/linux-${MINIOARCH}/mc -O /usr/local/bin/mc \
    && chmod a+x /usr/local/bin/mc
