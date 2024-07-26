GO_VERSION=$(shell cat GO.version)
VSCODE_VERSION=$(shell cat VSCODE.version)
DEBIAN_CODENAME=bookworm
VERSION=${VSCODE_VERSION}-${DEBIAN_CODENAME}-go${GO_VERSION}-2

BUILDAH_ARGS=--build-arg GO_VERSION=${GO_VERSION} --build-arg DEBIAN_CODENAME=${DEBIAN_CODENAME} --build-arg VSCODE_VERSION=${VSCODE_VERSION} -f Dockerfile --manifest ${IMAGE_PATH}:${VERSION}

docker:
	buildah manifest rm containers-storage:${IMAGE_PATH}:${VERSION} > /dev/null 2>&1 || true
	buildah manifest create ${IMAGE_PATH}:${VERSION}

	buildah bud ${BUILDAH_ARGS} --arch amd64
#	buildah bud ${BUILDAH_ARGS} --arch arm64 --variant v8

version:
	@echo ${VERSION}

inspect:
	buildah manifest inspect ${IMAGE_PATH}:${VERSION}

test:
	podman run -it --rm -p 3000:8080 -v "${PWD}:/home/coder/project:ro" -u "$(shell id -u):$(shell id -g)" -e "DOCKER_USER=${USER}" ${IMAGE_PATH}:${VERSION}
 