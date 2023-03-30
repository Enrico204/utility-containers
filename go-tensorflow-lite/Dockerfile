ARG GO_VERSION
ARG TF_VERSION

FROM docker.io/library/debian:buster AS builder

RUN apt-get update && \
    apt-get install -y build-essential openjdk-11-jdk-headless python3 zip \
        unzip wget libatomic1 git-core python3-distutils python3-numpy
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

WORKDIR /src

ARG TF_VERSION

RUN wget https://github.com/tensorflow/tensorflow/archive/refs/tags/v${TF_VERSION}.tar.gz \
    && tar xf v${TF_VERSION}.tar.gz \
    && rm v${TF_VERSION}.tar.gz

# CMAKE
RUN echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/backports.list && apt-get update
RUN apt-get install -y -t buster-backports cmake

RUN mkdir /src/tflite_build
WORKDIR /src/tflite_build

RUN cmake ../tensorflow-${TF_VERSION}/tensorflow/lite/c
RUN cmake --build . -j $(nproc)

# Final stage
ARG GO_VERSION
FROM docker.io/library/golang:${GO_VERSION}-buster
ARG TF_VERSION

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y upx-ucl zip ca-certificates tzdata jq curl && \
    rm -rf /var/cache/apt/* && \
    useradd --home /app/ -M appuser && \
    wget https://www.apple.com/certificateauthority/AppleISTCA2G1.cer -O /tmp/AppleISTCA2G1.cer && \
    openssl x509 -inform der -in /tmp/AppleISTCA2G1.cer -out /usr/local/share/ca-certificates/AppleISTCA2G1.crt && \
    rm /tmp/AppleISTCA2G1.cer && \
    update-ca-certificates && \
    go install github.com/psampaz/go-mod-outdated@v0.8.0 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.51.1 && \
    go install github.com/google/go-licenses@v1.2.1

WORKDIR /usr/share/zoneinfo
RUN zip -r -0 /zoneinfo.zip .
WORKDIR /src/

COPY --from=builder /src/tflite_build/libtensorflowlite_c.so /usr/local/lib/
COPY --from=builder /src/tensorflow-${TF_VERSION}/tensorflow/lite/c/*.h /usr/local/include/tensorflow/lite/c/
COPY --from=builder /src/tensorflow-${TF_VERSION}/tensorflow/lite/*.h /usr/local/include/tensorflow/lite/

RUN ldconfig
