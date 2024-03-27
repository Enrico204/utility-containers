FROM hub.netsplit.it/utilities/android-sdk:4

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -yq && \
    apt-get install -yq zip unzip xz-utils git-core curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG FLUTTER_VERSION

RUN wget --progress=dot -O /tmp/flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    && mkdir /usr/local/flutter/ \
    && tar xf /tmp/flutter.tar.xz -C /usr/local/ \
    && git config --global --add safe.directory /usr/local/flutter \
    && rm /tmp/flutter.tar.xz

ENV PATH="${PATH}:/usr/local/flutter/bin/"

RUN flutter config --no-analytics \
    && dart --disable-analytics \
    && flutter precache
