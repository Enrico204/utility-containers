ARG BUILDAH_VERSION
FROM quay.io/buildah/stable:v${BUILDAH_VERSION}

RUN dnf install --setopt=install_weak_deps=False --best --nodocs -y skopeo make && \
    dnf install -y https://zfsonlinux.org/fedora/zfs-release-2-3$(rpm --eval "%{dist}").noarch.rpm && \
    dnf install -y --nodocs kernel-devel && \
    dnf install -y --nodocs zfs && \
    dnf clean all

COPY storage_zfs.conf /root/
