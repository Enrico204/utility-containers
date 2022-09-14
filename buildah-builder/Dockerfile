ARG BUILDAH_VERSION
FROM quay.io/buildah/stable:v${BUILDAH_VERSION}

RUN dnf install --setopt=install_weak_deps=False --best --nodocs -y skopeo make && \
    dnf clean all
