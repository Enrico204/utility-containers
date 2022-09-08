FROM docker.io/library/debian:bullseye-slim

ARG HUGO_VERSION
ARG PANDOC_VERSION
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends -qy ca-certificates \
    && /bin/bash -c 'echo "deb [trusted=yes] https://deb.netsplit.it/bullseye ./" > /etc/apt/sources.list.d/netsplit.list' \
    && apt-get update \
    && apt-get install --no-install-recommends -qy hugo=${HUGO_VERSION} texlive-full pandoc=${PANDOC_VERSION} mcli rsync openssh-client git \
    && rm -rf /var/cache/apt/* /etc/apt/sources.list.d/netsplit.list
