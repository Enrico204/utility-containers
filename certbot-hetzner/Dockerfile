ARG CERTBOT_VERSION
FROM docker.io/certbot/certbot:${CERTBOT_VERSION}

ARG PLUGIN_VERSION
RUN pip3 install certbot-dns-hetzner==${PLUGIN_VERSION}
