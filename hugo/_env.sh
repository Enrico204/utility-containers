HUGO_VERSION=$(cat HUGO.version)
VERSION=${HUGO_VERSION}-2

BUILDAH_ARGS="--build-arg HUGO_VERSION=${HUGO_VERSION}"
