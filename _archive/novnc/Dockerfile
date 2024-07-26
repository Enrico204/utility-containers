FROM alpine:latest

ENV NOVNC_TAG="v1.4.0"

ENV WEBSOCKIFY_TAG="v0.11.0"

ENV VNC_SERVER "localhost:5900"

RUN apk --no-cache --update --upgrade add \
        bash \
        python3 \
        python3-dev \
        gfortran \
        py-pip \
        build-base \
        procps \
        git

RUN pip install --no-cache-dir numpy

RUN git config --global advice.detachedHead false && \
    git clone https://github.com/novnc/noVNC --branch ${NOVNC_TAG} /root/noVNC && \
    git clone https://github.com/novnc/websockify --branch ${WEBSOCKIFY_TAG} /root/noVNC/utils/websockify

RUN cp /root/noVNC/vnc.html /root/noVNC/index.html

ENTRYPOINT [ "bash", "-c", "/root/noVNC/utils/novnc_proxy --vnc ${VNC_SERVER}" ]

