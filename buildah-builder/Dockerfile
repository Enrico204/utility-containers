ARG BUILDAH_VERSION
FROM quay.io/buildah/stable:v${BUILDAH_VERSION}

# ZFS on linux: see the repository list here when the Fedora version changes:
# https://github.com/zfsonlinux/zfsonlinux.github.com/tree/master/fedora
RUN dnf install --setopt=install_weak_deps=False --best --nodocs -y skopeo make git && \
    dnf install -y https://zfsonlinux.org/fedora/zfs-release-2-8$(rpm --eval "%{dist}").noarch.rpm && \
    dnf install -y --nodocs kernel-devel && \
    dnf install -y --nodocs zfs && \
    dnf clean all

COPY mynet.pem /etc/pki/ca-trust/source/anchors/mynet.pem
COPY storage_zfs.conf /root/
RUN update-ca-trust
