FROM docker.io/library/python:3.11

RUN apt-get update -yq && \
    apt-get install -yq libncurses5-dev flex bison build-essential && \
    apt-get clean

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -U platformio && \
    pio platform install --with-all-packages espressif8266 && \
    pio platform install --with-all-packages platformio/espressif32 && \
    pio platform install --with-all-packages platformio/raspberrypi && \
    pio system prune -f
