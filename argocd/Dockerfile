ARG ARGOCD_VERSION
FROM quay.io/argoproj/argocd:${ARGOCD_VERSION}

ARG SOPS_VERSION
ARG HELM_SECRETS_VERSION
ARG KUBECTL_VERSION
ENV DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update && \
    apt-get install -y wget gettext-base && \
    wget https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux -O /usr/local/bin/sops && \
    chmod a+x /usr/local/bin/sops && \
    wget https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && \
    chmod a+x /usr/local/bin/kubectl && \
    apt-get remove --purge -y wget && \
    rm -rf /var/cache/apt/* /var/lib/apt/*
USER 999

ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/"
RUN helm plugin install --version ${HELM_SECRETS_VERSION} https://github.com/jkroepke/helm-secrets
