FROM docker.io/library/debian:bookworm-slim

COPY mynet.pem /usr/local/share/ca-certificates/mynet.crt
ARG HUGO_VERSION
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -qy ca-certificates tzdata && \
    /bin/bash -c 'echo "deb [trusted=yes] https://deb.netsplit.it/selfcontained ./" > /etc/apt/sources.list.d/netsplit.list' && \
    apt-get update && \
    apt-get install --no-install-recommends -qy hugo=${HUGO_VERSION} rsync openssh-client git sudo && \
    rm -rf /var/cache/apt/* /etc/apt/sources.list.d/netsplit.list && \
    update-ca-certificates && \
    useradd --home /app/ -m appuser && \
    git config --system --add safe.directory "*" && \
    printf "appuser ALL=NOPASSWD: /usr/bin/apt-get *" > /etc/sudoers.d/appuser

USER appuser
WORKDIR /src/

RUN git config --global init.defaultBranch master && \
    git config --global advice.detachedHead false

