ARG NODERED_VERSION
FROM docker.io/nodered/node-red:${NODERED_VERSION}

USER root
RUN apt-get update -yq && apt-get install -yq iputils-ping && apt-get clean
USER node-red
