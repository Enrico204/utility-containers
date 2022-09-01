FROM docker.io/library/python:3.9

RUN pip install --upgrade pip && \
    pip install -U platformio && \
    pio platform install --with-all-packages espressif8266 && \
    pio system prune -f
