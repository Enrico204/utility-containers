HUGO_VERSION=$(shell cat HUGO.version)
PANDOC_VERSION=$(shell cat PANDOC.version)-1
PLANTUML_VERSION=$(shell cat PLANTUML.version)
VERSION=${HUGO_VERSION}-${PANDOC_VERSION}-${PLANTUML_VERSION}-4

BUILDAH_ARGS=--build-arg HUGO_VERSION=${HUGO_VERSION} --build-arg PANDOC_VERSION=${PANDOC_VERSION} --build-arg PLANTUML_VERSION=${PLANTUML_VERSION} --build-arg apt_proxy=${apt_proxy} --build-arg apt_mirror=${apt_mirror} -f Dockerfile --manifest ${IMAGE_PATH}:${VERSION}

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
