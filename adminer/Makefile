ADMINER_VERSION=4.8.1
VERSION=${ADMINER_VERSION}-3

BUILDAH_ARGS=--build-arg ADMINER_VERSION=${ADMINER_VERSION} --build-arg LIGHTTP_PORT=7070 -f Dockerfile  --manifest ${IMAGE_PATH}:${VERSION}

docker:
	buildah manifest rm containers-storage:${IMAGE_PATH}:${VERSION} > /dev/null 2>&1 || true
	buildah manifest create ${IMAGE_PATH}:${VERSION}

	buildah bud ${BUILDAH_ARGS} --arch amd64
	buildah bud ${BUILDAH_ARGS} --arch arm64 --variant v8

push:
	buildah manifest push --all --format=docker ${IMAGE_PATH}:${VERSION} docker://${IMAGE_PATH}:${VERSION}

dev:
	docker run -it --rm -p 7000:7000 -e LIGHTTP_PORT=7000 ${IMAGE_PATH}:${VERSION}

version:
	@echo ${VERSION}

inspect:
	buildah manifest inspect ${IMAGE_PATH}:${VERSION}
