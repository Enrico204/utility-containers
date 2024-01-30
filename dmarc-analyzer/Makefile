GO_VERSION=$(shell cat GO.version)
SUPERCRONIC_VERSION=$(shell cat SUPERCRONIC.version)
VERSION=${GO_VERSION}-${SUPERCRONIC_VERSION}-1

BUILDAH_ARGS=--build-arg SUPERCRONIC_VERSION=${SUPERCRONIC_VERSION} --build-arg GO_VERSION=${GO_VERSION} -f Dockerfile --manifest ${IMAGE_PATH}:${VERSION}

docker:
	buildah manifest rm containers-storage:${IMAGE_PATH}:${VERSION} > /dev/null 2>&1 || true
	buildah manifest create ${IMAGE_PATH}:${VERSION}

	buildah bud ${BUILDAH_ARGS} --arch amd64
#	buildah bud ${BUILDAH_ARGS} --arch arm64 --variant v8

push:
	buildah manifest push --all --format=docker ${IMAGE_PATH}:${VERSION} docker://${IMAGE_PATH}:${VERSION}

version:
	@echo ${VERSION}

inspect:
	buildah manifest inspect ${IMAGE_PATH}:${VERSION}

test:
	podman run -it --rm -e IMAP_SERVER=tls://localhost:993 -e IMAP_USER=example -e IMAP_PASS=test ${IMAGE_PATH}:${VERSION}
