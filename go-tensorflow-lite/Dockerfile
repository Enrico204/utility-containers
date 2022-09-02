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

COPY --from=builder /src/tflite_build/libtensorflowlite_c.so /usr/local/lib/
COPY --from=builder /src/tensorflow-${TF_VERSION}/tensorflow/lite/c/*.h /usr/local/include/tensorflow/lite/c/
COPY --from=builder /src/tensorflow-${TF_VERSION}/tensorflow/lite/*.h /usr/local/include/tensorflow/lite/

RUN ldconfig
