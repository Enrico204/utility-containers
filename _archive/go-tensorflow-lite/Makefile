GO_VERSION=$(shell cat GO.version)
TF_VERSION=$(shell cat TENSORFLOW.version)
VERSION=${GO_VERSION}-tf${TF_VERSION}-1

BUILDAH_ARGS=--build-arg GO_VERSION=${GO_VERSION} --build-arg TF_VERSION=${TF_VERSION} -f Dockerfile --manifest ${IMAGE_PATH}:${VERSION}

docker:
	buildah manifest rm containers-storage:${IMAGE_PATH}:${VERSION} > /dev/null 2>&1 || true
	buildah manifest create ${IMAGE_PATH}:${VERSION}

	buildah bud ${BUILDAH_ARGS} --arch amd64
	buildah bud ${BUILDAH_ARGS} --arch arm64 --variant v8
	buildah bud ${BUILDAH_ARGS} --arch arm --variant v7

push:
	buildah manifest push --all --format=docker ${IMAGE_PATH}:${VERSION} docker://${IMAGE_PATH}:${VERSION}

version:
	@echo ${VERSION}

inspect:
	buildah manifest inspect ${IMAGE_PATH}:${VERSION}
