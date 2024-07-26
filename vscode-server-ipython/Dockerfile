ARG VSCODE_VERSION
ARG DEBIAN_CODENAME
FROM docker.io/codercom/code-server:${VSCODE_VERSION}-${DEBIAN_CODENAME}

ARG GO_VERSION
USER root
ENV USER=root

RUN apt-get update -yq && \
    apt-get install -yq python3 python3-pip python3-venv libpcap-dev python3-ipykernel python3-nbformat \
        build-essential openssh-client git curl wget default-jdk ca-certificates zip tzdata jq libsqlite3-0 libsqlite3-dev sqlite3 vim && \
    apt-get clean

RUN wget https://go.dev/dl/go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz -O /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz && \
    echo 'export PATH=$PATH:/usr/local/go/bin/:~/go/bin/' >> /etc/profile.d/golang-path.sh

USER 1000
ENV USER=coder

RUN code-server --install-extension ms-toolsai.jupyter && \
    code-server --install-extension eamodio.gitlens && \
    code-server --install-extension golang.go && \
    code-server --install-extension ms-python.python && \
    code-server --install-extension ms-python.debugpy && \
    code-server --install-extension mechatroner.rainbow-csv && \
    code-server --install-extension jebbs.plantuml

ENV PATH="$PATH:/usr/local/go/bin/:$HOME/go/bin/"
RUN go install github.com/janpfeifer/gonb@latest && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/psampaz/go-mod-outdated@v0.9.0 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.53.3 && \
    go install github.com/amacneil/dbmate/v2@v2.4.0 && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install golang.org/x/tools/gopls@latest && \
    PATH="$PATH:/usr/local/go/bin/:$HOME/go/bin/" gonb -install

ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "--disable-telemetry", "."]
