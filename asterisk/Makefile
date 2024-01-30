ALPINE_VERSION=3.19
BCG729_VERSION=1.1.1
ASTERISK_VERSION=$(shell cat ASTERISK.version)
ASTERISK_MAJOR=$(shell cat ASTERISK.version | cut -f 1 -d .)
VERSION=${ASTERISK_VERSION}-3

BUILDAH_ARGS=--build-arg ASTERISK_VERSION=${ASTERISK_VERSION} --build-arg ASTERISK_MAJOR=${ASTERISK_MAJOR} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg BCG729_VERSION=${BCG729_VERSION} -f Dockerfile

docker:
	buildah manifest rm containers-storage:${IMAGE_PATH}:${VERSION} > /dev/null 2>&1 || true
	buildah manifest create ${IMAGE_PATH}:${VERSION}

	buildah bud ${BUILDAH_ARGS} --manifest ${IMAGE_PATH}:${VERSION} --arch amd64
	buildah bud ${BUILDAH_ARGS} --manifest ${IMAGE_PATH}:${VERSION} --arch arm64 --variant v8

push:
	buildah manifest push --all --format=docker ${IMAGE_PATH}:${VERSION} docker://${IMAGE_PATH}:${VERSION}

version:
	@echo ${VERSION}

inspect:
	buildah manifest inspect ${IMAGE_PATH}:${VERSION}

latest-version:
	@podman run -it --rm docker.io/library/alpine:${ALPINE_VERSION} /bin/sh -c "apk update > /dev/null && apk info asterisk | head -n 1 | cut -f 1 -d ' ' | cut -f 2- -d -"

test:
	podman build ${BUILDAH_ARGS} -t asterisk:${VERSION} .
	podman run -it --rm asterisk:${VERSION}
