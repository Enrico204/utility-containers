ARG GO_VERSION
FROM docker.io/library/golang:${GO_VERSION}

# Avoid CGo by default
ENV CGO_ENABLED 0
ENV GOOS linux

# Disable GOPATH, we will use a standard user to run everything
ENV GOPATH=
ENV PATH=/app/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY mynet.pem /usr/local/share/ca-certificates/mynet.crt
# Basic dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -yq && \
    apt-get install -yq zip ca-certificates tzdata jq curl libsqlite3-0 libsqlite3-dev libpcap-dev sudo podman skopeo buildah && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update -yq && \
    apt-get install -yq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    apt-get clean && \
    useradd --home /app/ -m appuser && \
    mkdir /out && \
    chown appuser /out \
    update-ca-certificates && \
    git config --system --add safe.directory "*" && \
    printf "appuser ALL=NOPASSWD: /usr/bin/apt-get *" > /etc/sudoers.d/appuser

# Pack zoneinfo for Go timezone
WORKDIR /usr/share/zoneinfo
RUN zip -r -0 /zoneinfo.zip .

USER appuser
# Install CLI tools and restore permissions to 777 because we use a user to do everything
# See "How to use this image" under https://hub.docker.com/_/golang
RUN go install github.com/psampaz/go-mod-outdated@v0.9.0 && \
    go install github.com/google/go-licenses@v1.6.0 && \
    go install golang.org/x/tools/cmd/godoc@latest && \
    go install github.com/amacneil/dbmate/v2@v2.4.0 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.53.3 && \
    git config --global init.defaultBranch master && \
    git config --global advice.detachedHead false

WORKDIR /src/
