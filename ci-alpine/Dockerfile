ARG ALPINE_VERSION
FROM docker.io/library/alpine:${ALPINE_VERSION} AS builder

RUN apk add --no-cache ca-certificates curl bash jq skopeo git openssh-client

COPY mynet.pem /usr/local/share/ca-certificates/mynet.crt
RUN update-ca-certificates

