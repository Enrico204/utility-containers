#!/usr/bin/env bash
set -o pipefail

cd $(dirname $0)

. ../vars.sh

command -v skopeo
if [ $? -ne 0 ]; then
    echo "Skopeo command is missing"
    exit 1
fi

DISTROS=${1:-}
if [ "$DISTROS" == "" ]; then
	DISTROS="bookworm trixie"
fi

VERSION=3

cp ../mynet.pem .

for distro in $DISTROS; do
	IMAGE_PATH="$BASEURL/debian-builder:$distro-v$VERSION"
	DOCKERHUB_IMAGE_PATH="$DOCKERHUB_BASEURL/debian-builder:$distro-v$VERSION"

	skopeo inspect "docker://$IMAGE_PATH" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		set -e
		# Image does not exists
		buildah manifest rm containers-storage:$IMAGE_PATH > /dev/null 2>&1 || true
		buildah manifest create $IMAGE_PATH

		BUILDAH_ARGS="--build-arg apt_proxy=$apt_proxy --build-arg apt_mirror=$apt_mirror -f Dockerfile.$distro --manifest $IMAGE_PATH"
		buildah bud ${BUILDAH_ARGS} --arch amd64
		buildah bud ${BUILDAH_ARGS} --arch arm64 --variant v8
		buildah bud ${BUILDAH_ARGS} --arch arm   --variant v7

		buildah manifest push --all --format=docker $IMAGE_PATH docker://$IMAGE_PATH
		set +e
	fi

	# ARMel specific
	skopeo --override-arch arm --override-variant v7 inspect "docker://$IMAGE_PATH-armel" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		set -e
		# Image does not exists
		buildah manifest rm containers-storage:$IMAGE_PATH-armel > /dev/null 2>&1 || true
		buildah manifest create $IMAGE_PATH-armel

		BUILDAH_ARGS="--build-arg apt_proxy=$apt_proxy --build-arg apt_mirror=$apt_mirror -f Dockerfile.$distro.armel --manifest $IMAGE_PATH-armel"
		buildah bud ${BUILDAH_ARGS} --arch arm   --variant v5

		buildah manifest push --all --format=docker $IMAGE_PATH-armel docker://$IMAGE_PATH-armel
		set +e
	fi

	# Mirror container in Docker Hub
	skopeo inspect "docker://$DOCKERHUB_IMAGE_PATH" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		set -e
		buildah manifest push --all --format=docker $IMAGE_PATH "docker://$DOCKERHUB_IMAGE_PATH"
		set +e
	fi

	# Mirror container in Docker Hub (ARMel version)
	skopeo --override-arch arm --override-variant v7 inspect "docker://$DOCKERHUB_IMAGE_PATH-armel" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		set -e
		buildah manifest push --all --format=docker $IMAGE_PATH-armel "docker://$DOCKERHUB_IMAGE_PATH-armel"
		set +e
	fi
done

