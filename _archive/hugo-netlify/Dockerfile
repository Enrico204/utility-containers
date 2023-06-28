FROM docker.io/library/node:lts-bullseye-slim

RUN npm install netlify-cli -g

ARG HUGO_VERSION
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends -qy ca-certificates \
    && /bin/bash -c 'echo "deb [trusted=yes] https://deb.netsplit.it/bullseye ./" > /etc/apt/sources.list.d/netsplit.list' \
    && apt-get update \
    && apt-get install --no-install-recommends -qy hugo=${HUGO_VERSION} mcli \
    && rm -rf /var/cache/apt/* /etc/apt/sources.list.d/netsplit.list
