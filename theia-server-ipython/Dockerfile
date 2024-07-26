ARG THEIA_VERSION
FROM ghcr.io/eclipse-theia/theia-blueprint/theia-ide:${THEIA_VERSION}

ARG GO_VERSION
USER root

RUN apt-get update -yq && \
    apt-get install -yq python3 python3-pip python3-venv libpcap-dev python3-ipykernel python3-nbformat \
        build-essential openssh-client git curl wget default-jdk ca-certificates zip tzdata jq libsqlite3-0 libsqlite3-dev sqlite3 vim && \
    apt-get clean

RUN wget https://go.dev/dl/go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz -O /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz && \
    echo 'export PATH=$PATH:/usr/local/go/bin/:$HOME/go/bin/' >> /etc/profile.d/golang-path.sh

USER theia

RUN mkdir -p $HOME/.theia-ide/plugins/ && \
    cd $HOME/.theia-ide/plugins/ && \
    wget https://open-vsx.org/api/ms-toolsai/jupyter/2024.5.0/file/ms-toolsai.jupyter-2024.5.0.vsix && \
    wget https://open-vsx.org/api/eamodio/gitlens/15.2.1/file/eamodio.gitlens-15.2.1.vsix && \
    wget https://open-vsx.org/api/golang/Go/0.42.0/file/golang.Go-0.42.0.vsix && \
    wget https://open-vsx.org/api/ms-python/python/2024.10.0/file/ms-python.python-2024.10.0.vsix && \
    wget https://open-vsx.org/api/ms-python/debugpy/linux-x64/2024.8.0/file/ms-python.debugpy-2024.8.0@linux-x64.vsix && \
    wget https://open-vsx.org/api/mechatroner/rainbow-csv/3.3.0/file/mechatroner.rainbow-csv-3.3.0.vsix && \
    wget https://open-vsx.org/api/jebbs/plantuml/2.18.1/file/jebbs.plantuml-2.18.1.vsix

ENV PATH="$PATH:/usr/local/go/bin/:$HOME/go/bin/"
RUN go install github.com/janpfeifer/gonb@latest && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/psampaz/go-mod-outdated@v0.9.0 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.53.3 && \
    go install github.com/amacneil/dbmate/v2@v2.4.0 && \
    PATH="$PATH:/usr/local/go/bin/:$HOME/go/bin/" gonb -install
