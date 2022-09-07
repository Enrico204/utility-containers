#!/usr/bin/env bash
set -o pipefail

VERSION=0

for distro in stretch buster bullseye; do
	IMAGE_PATH="$BASEURL/debian-builder:$distro-v$VERSION"
	DOCKERHUB_IMAGE_PATH="$DOCKERHUB_BASEURL/debian-builder:$distro-v$VERSION"

	skopeo inspect "docker://$IMAGE_PATH" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		set -e
		# Image does not exists
		buildah manifest rm containers-storage:$IMAGE_PATH || true > /dev/null 2>&1
		buildah manifest create $IMAGE_PATH

		BUILDAH_ARGS="--build-arg apt_proxy=$apt_proxy -f Dockerfile.$distro --manifest $IMAGE_PATH"
		buildah bud ${BUILDAH_ARGS} --arch amd64
		buildah bud ${BUILDAH_ARGS} --arch arm64 --variant v8
		buildah bud ${BUILDAH_ARGS} --arch arm   --variant v7

		buildah manifest push --all --format=docker $IMAGE_PATH docker://$IMAGE_PATH
		set +e
	fi

	# ARMel specific
	skopeo --override-arch armel --override-variant v7 inspect "docker://$IMAGE_PATH-armel" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		set -e
		# Image does not exists
		buildah manifest rm containers-storage:$IMAGE_PATH-armel || true > /dev/null 2>&1
		buildah manifest create $IMAGE_PATH-armel

		BUILDAH_ARGS="--build-arg apt_proxy=$apt_proxy -f Dockerfile.$distro.armel --manifest $IMAGE_PATH-armel"
		buildah bud ${BUILDAH_ARGS} --arch arm   --variant v7

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
	skopeo --override-arch armel --override-variant v7 inspect "docker://$DOCKERHUB_IMAGE_PATH-armel" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		set -e
		buildah manifest push --all --format=docker $IMAGE_PATH-armel "docker://$DOCKERHUB_IMAGE_PATH-armel"
		set +e
	fi
done

