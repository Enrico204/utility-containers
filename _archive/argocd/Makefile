ARGOCD_VERSION=v$(shell cat ARGOCD.version)
SOPS_VERSION=v$(shell cat SOPS.version)
HELM_SECRETS_VERSION=$(shell cat HELM_SECRETS.version)
KUBECTL_VERSION=$(shell cat KUBECTL.version)
VERSION=${ARGOCD_VERSION}-${SOPS_VERSION}-${HELM_SECRETS_VERSION}-${KUBECTL_VERSION}-1

BUILDAH_ARGS=--build-arg ARGOCD_VERSION=${ARGOCD_VERSION} --build-arg SOPS_VERSION=${SOPS_VERSION} --build-arg HELM_SECRETS_VERSION=${HELM_SECRETS_VERSION} --build-arg KUBECTL_VERSION=${KUBECTL_VERSION} -f Dockerfile --manifest ${IMAGE_PATH}:${VERSION}

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
