GO_VERSION=$(shell cat GO.version)
THEIA_VERSION=$(shell cat THEIA.version)
VERSION=${THEIA_VERSION}-go${GO_VERSION}-1

BUILDAH_ARGS=--build-arg GO_VERSION=${GO_VERSION} --build-arg THEIA_VERSION=${THEIA_VERSION} -f Dockerfile --manifest ${IMAGE_PATH}:${VERSION}

docker:
	buildah manifest rm containers-storage:${IMAGE_PATH}:${VERSION} > /dev/null 2>&1 || true
	buildah manifest create ${IMAGE_PATH}:${VERSION}

	buildah bud ${BUILDAH_ARGS} --arch amd64
#	buildah bud ${BUILDAH_ARGS} --arch arm64 --variant v8

version:
	@echo ${VERSION}

inspect:
	buildah manifest inspect ${IMAGE_PATH}:${VERSION}
