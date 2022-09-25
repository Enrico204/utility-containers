FROM docker.io/library/debian:bullseye-slim

ARG APT_PROXY
ARG HUGO_VERSION
ARG PANDOC_VERSION
ARG PLANTUML_VERSION
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "Acquire::http::Proxy \"${APT_PROXY}\";" > /etc/apt/apt.conf.d/99proxy \
    && apt-get update \
    && apt-get install --no-install-recommends -qy ca-certificates \
    && /bin/bash -c 'echo "deb [trusted=yes] https://deb.netsplit.it/bullseye ./" > /etc/apt/sources.list.d/netsplit.list' \
    && apt-get update \
    && apt-get install --no-install-recommends -qy hugo=${HUGO_VERSION} pandoc=${PANDOC_VERSION} plantuml=1:${PLANTUML_VERSION} \
    texlive-full texlive-fonts-extra texlive-latex-extra mcli rsync openssh-client git \
    && rm -rf /var/cache/apt/* /etc/apt/sources.list.d/netsplit.list /etc/apt/apt.conf.d/99proxy

COPY 09-texlive-fonts.conf /etc/fonts/conf.d/09-texlive-fonts.conf
COPY policy.xml /etc/ImageMagick-6/policy.xml

RUN fc-cache -fsv
RUN mkdir -p /root/texmf/tex/latex && cd /root/texmf/tex/latex && \
    git clone https://github.com/Jubobs/xcolor-solarized.git && \
    git clone https://github.com/Jubobs/gitdags.git
