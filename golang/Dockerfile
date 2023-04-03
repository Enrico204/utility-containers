ARG GO_VERSION
FROM docker.io/library/golang:${GO_VERSION}

# Avoid CGo by default
ENV CGO_ENABLED 0
ENV GOOS linux

# Basic dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y upx-ucl zip ca-certificates tzdata jq curl libsqlite3-0 libsqlite3-dev && \
    rm -rf /var/cache/apt/* && \
    useradd --home /app/ -m appuser && \
    wget https://www.apple.com/certificateauthority/AppleISTCA2G1.cer -O /tmp/AppleISTCA2G1.cer && \
    openssl x509 -inform der -in /tmp/AppleISTCA2G1.cer -out /usr/local/share/ca-certificates/AppleISTCA2G1.crt && \
    rm /tmp/AppleISTCA2G1.cer && \
    update-ca-certificates && \
    git config --global --add safe.directory "*"

# Pack zoneinfo for Go timezone
WORKDIR /usr/share/zoneinfo
RUN zip -r -0 /zoneinfo.zip .

# Install CLI tools and restire permissions to 777
# See "How to use this image" under https://hub.docker.com/_/golang
RUN go install github.com/psampaz/go-mod-outdated@v0.8.0 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.51.1 && \
    go install github.com/google/go-licenses@v1.2.1 && \
    chmod -R 777 "$GOPATH"

USER appuser
WORKDIR /src/
