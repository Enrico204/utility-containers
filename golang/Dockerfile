ARG GO_VERSION
FROM docker.io/library/golang:${GO_VERSION}

ENV CGO_ENABLED 0
ENV GOOS linux

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y upx-ucl zip ca-certificates tzdata jq curl && \
    rm -rf /var/cache/apt/* && \
    useradd --home /app/ appuser && \
    wget https://www.apple.com/certificateauthority/AppleISTCA2G1.cer -O /tmp/AppleISTCA2G1.cer && \
    openssl x509 -inform der -in /tmp/AppleISTCA2G1.cer -out /usr/local/share/ca-certificates/AppleISTCA2G1.crt && \
    rm /tmp/AppleISTCA2G1.cer && \
    update-ca-certificates && \
    go install github.com/psampaz/go-mod-outdated@v0.8.0 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.48.0 && \
    go install github.com/google/go-licenses@v1.2.1

WORKDIR /usr/share/zoneinfo
RUN zip -r -0 /zoneinfo.zip .
WORKDIR /src/