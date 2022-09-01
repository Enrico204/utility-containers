ARG OPENAPI_VERSION
FROM docker.io/openapitools/openapi-generator-cli:${OPENAPI_VERSION}

RUN apt-get update && \
    apt-get install -y git make && \
    rm -rf /var/cache/apt/*
