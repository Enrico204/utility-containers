CMDLINE_TOOLS=10406996
BUILD_TOOLS=34.0.0
ANDROID_SDK=33
VERSION=4

BUILDAH_ARGS=--build-arg BUILD_TOOLS=${BUILD_TOOLS} \
	--build-arg CMDLINE_TOOLS=${CMDLINE_TOOLS} \
	--build-arg ANDROID_SDK=${ANDROID_SDK} \
	--build-arg VERSION=${VERSION} \
	-f Dockerfile --manifest ${IMAGE_PATH}:${VERSION}

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
