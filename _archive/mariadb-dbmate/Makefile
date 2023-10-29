MARIADB_VERSION=$(shell cat MARIADB.version)
DBMATE_VERSION=$(shell cat DBMATE.version)
VERSION=${MARIADB_VERSION}-${DBMATE_VERSION}-1

BUILDAH_ARGS=--build-arg MARIADB_VERSION=${MARIADB_VERSION} --build-arg DBMATE_VERSION=${DBMATE_VERSION} -f Dockerfile --manifest ${IMAGE_PATH}:${VERSION}

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
