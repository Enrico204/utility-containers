ARG GO_VERSION
FROM docker.io/library/golang:${GO_VERSION} AS builder

# Basic dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -yq && \
    apt-get install -y make git tar && \
    apt-get clean && \
    git config --system --add safe.directory "*"

WORKDIR /src
RUN git clone https://github.com/tierpod/dmarc-report-converter
WORKDIR /src/dmarc-report-converter
RUN make release


FROM docker.io/library/debian:stable

VOLUME /out

RUN apt-get update -yq && apt-get install -yq curl && apt-get clean

ARG SUPERCRONIC_VERSION
# Latest releases available at https://github.com/aptible/supercronic/releases
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v${SUPERCRONIC_VERSION}/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64

RUN curl -o /usr/local/bin/supercronic -fsSL "https://github.com/aptible/supercronic/releases/download/v${SUPERCRONIC_VERSION}/supercronic-linux-amd64" \
 && chmod +x "/usr/local/bin/supercronic"

COPY --from=builder /src/dmarc-report-converter/bin/dmarc-report-converter /usr/local/bin/

COPY crontab /crontab
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
