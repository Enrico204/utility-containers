GO_VERSION=$(cat GO.version)
VERSION=${GO_VERSION}-17
ARCHITECTURES="amd64"

BUILDAH_ARGS="--build-arg GO_VERSION=${GO_VERSION}"
