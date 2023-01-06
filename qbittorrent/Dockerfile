FROM docker.io/library/debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y qbittorrent-nox && rm -rf /var/cache/apt/*

VOLUME /store/

EXPOSE 8080

USER 1000

CMD [ "/bin/sh", "-c", "echo yes | qbittorrent-nox --save-path=/store/downloads --profile=/store/.cfg" ]
