FROM docker.io/library/debian:bookworm-slim
ARG apt_mirror
ARG apt_proxy

COPY setup-mirror.sh /tmp/
ENV DEBIAN_FRONTEND=noninteractive

# First we install LaTeX, so we can re-use cached layers
RUN bash /tmp/setup-mirror.sh && \
    apt-get update && \
    apt-get install --no-install-recommends -qy texlive-full texlive-fonts-extra texlive-latex-extra rsync \
    openssh-client git ca-certificates && \
    rm -rf /var/cache/apt/*

ARG HUGO_VERSION
ARG PANDOC_VERSION
ARG PLANTUML_VERSION
# Then we install hugo, pandoc and plantuml
RUN /bin/bash -c 'echo "deb [trusted=yes] https://deb.netsplit.it/bookworm ./" > /etc/apt/sources.list.d/netsplit.list' && \
    /bin/bash -c 'echo "deb [trusted=yes] https://deb.netsplit.it/selfcontained ./" >> /etc/apt/sources.list.d/netsplit.list' && \
    apt-get update && \
    apt-get install --no-install-recommends -qy mcli hugo=${HUGO_VERSION} pandoc=${PANDOC_VERSION} plantuml=${PLANTUML_VERSION} && \
    bash /tmp/setup-mirror.sh sysprep && \
    rm -rf /tmp/* /var/cache/apt/* /etc/apt/sources.list.d/netsplit.list

COPY 09-texlive-fonts.conf /etc/fonts/conf.d/09-texlive-fonts.conf
COPY policy.xml /etc/ImageMagick-6/policy.xml

RUN fc-cache -fsv
RUN mkdir -p /root/texmf/tex/latex && cd /root/texmf/tex/latex && \
    git clone https://github.com/Jubobs/xcolor-solarized.git && \
    git clone https://github.com/Jubobs/gitdags.git
