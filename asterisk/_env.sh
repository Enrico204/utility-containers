ALPINE_VERSION=3.19
BCG729_VERSION=1.1.1
ASTERISK_VERSION=$(cat ASTERISK.version)
ASTERISK_MAJOR=$(cat ASTERISK.version | cut -f 1 -d .)
VERSION="${ASTERISK_VERSION}-4"

BUILDAH_ARGS="--build-arg ASTERISK_VERSION=${ASTERISK_VERSION} --build-arg ASTERISK_MAJOR=${ASTERISK_MAJOR} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg BCG729_VERSION=${BCG729_VERSION}"
ARCHITECTURES="amd64 arm64"
