FROM docker.io/library/debian:bookworm-slim

ARG HUGO_VERSION
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -qy ca-certificates tzdata && \
    /bin/bash -c 'echo "deb [trusted=yes] https://deb.netsplit.it/selfcontained ./" > /etc/apt/sources.list.d/netsplit.list' && \
    apt-get update && \
    apt-get install --no-install-recommends -qy hugo=${HUGO_VERSION} rsync openssh-client git sudo && \
    rm -rf /var/cache/apt/* /etc/apt/sources.list.d/netsplit.list && \
    useradd --home /app/ -m appuser && \
    git config --system --add safe.directory "*" && \
    printf "appuser ALL=NOPASSWD: /usr/bin/apt-get *" > /etc/sudoers.d/appuser && \
    git config --global init.defaultBranch master && \
    git config --global advice.detachedHead false

USER appuser
WORKDIR /src/
