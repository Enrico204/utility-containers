ARG GO_VERSION
FROM docker.io/library/golang:${GO_VERSION}

# Avoid CGo by default
ENV CGO_ENABLED 0
ENV GOOS linux

# Disable GOPATH, we will use a standard user to run everything
ENV GOPATH=
ENV PATH=/app/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Basic dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -yq && \
    apt-get install -yq zip ca-certificates tzdata jq curl libsqlite3-0 libsqlite3-dev && \
    apt-get clean && \
    useradd --home /app/ -m appuser && \
    wget https://www.apple.com/certificateauthority/AppleISTCA2G1.cer -O /tmp/AppleISTCA2G1.cer && \
    openssl x509 -inform der -in /tmp/AppleISTCA2G1.cer -out /usr/local/share/ca-certificates/AppleISTCA2G1.crt && \
    rm /tmp/AppleISTCA2G1.cer && \
    update-ca-certificates && \
    git config --system --add safe.directory "*"

# Pack zoneinfo for Go timezone
WORKDIR /usr/share/zoneinfo
RUN zip -r -0 /zoneinfo.zip .

RUN wget -O /tmp/golangci-lint.tar.gz https://github.com/golangci/golangci-lint/releases/download/v1.55.2/golangci-lint-1.55.2-linux-amd64.tar.gz && \
    tar xvf /tmp/golangci-lint.tar.gz --strip-components=1 -C /usr/bin/ && \
    rm /tmp/golangci-lint.tar.gz

USER appuser
# Install CLI tools and restore permissions to 777 because we use a user to do everything
# See "How to use this image" under https://hub.docker.com/_/golang
RUN go install github.com/psampaz/go-mod-outdated@v0.9.0 && \
    go install github.com/google/go-licenses@v1.6.0 && \
	go install golang.org/x/tools/cmd/godoc@latest && \
	go install github.com/amacneil/dbmate/v2@v2.4.0

WORKDIR /src/
