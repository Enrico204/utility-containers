FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y autoconf automake bison build-essential cmake curl flex git libdumbnet-dev libhwloc-dev libluajit-5.1-dev liblzma-dev libpcap-dev libpcre3-dev libssl-dev man-db pkg-config vim zlib1g-dev && \
    apt-get clean && \
    git clone "https://github.com/snort3/libdaq.git" && \
    cd libdaq && \
    ./bootstrap && \
    ./configure && \
    make install && \
    ldconfig && \
    cd ../ && \
    rm -rf libdaq && \
    useradd -ms /bin/bash snorty

USER snorty
WORKDIR /home/snorty

RUN mkdir -p examples snort3 src .vim/syntax .vim/colors && \
    cd src && \
    git clone "https://github.com/snort3/snort3.git" && \
    cd snort3 && \
    ./configure_cmake.sh --prefix=/home/snorty/snort3 && \
    cd build && \
    make -j$(nproc) install && \
    cd /home/snorty && \
    rm -rf src/ && \
    echo 'if [[ ! $PATH =~ $HOME/snort3/bin ]]; then export PATH=$PATH:$HOME/snort3/bin; fi' >> ~/.bashrc && \
    echo 'alias snort="snort -c $HOME/snort3/etc/snort/snort.lua"' >> ~/.bashrc && \
    echo 'export TERM=xterm-256color' >> ~/.bashrc && \
    mkdir snort3/etc/rules && \
    cd snort3/etc/rules && \
    curl -LO "https://snort.org/downloads/community/snort3-community-rules.tar.gz" && \
    tar xzf snort3-community-rules.tar.gz snort3-community-rules/snort3-community.rules --strip=1 && \
    rm snort3-community-rules.tar.gz

COPY examples examples
COPY .vimrc .vimrc
COPY hog.vim .vim/syntax/hog.vim
COPY ir_black.vim .vim/colors/ir_black.vim
