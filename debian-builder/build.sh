#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")"

source ../vars.sh


if ! command -v skopeo > /dev/null; then
    echo "skopeo command is missing"
    exit 1
fi

if ! command -v buildah > /dev/null; then
    echo "buildah command is missing"
    exit 1
fi

source _env.sh

DISTROS=${1:-$DISTROS}

cp ../mynet.pem .

for distro in $DISTROS; do
	IMAGE_FULL_NAME="$BASEURL/debian-builder:$distro-v$VERSION"

	set +e
	skopeo inspect "docker://$IMAGE_FULL_NAME" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		set -e
		# Image does not exists
		buildah manifest rm containers-storage:$IMAGE_FULL_NAME > /dev/null 2>&1 || true
		buildah manifest create $IMAGE_FULL_NAME

		buildah bud --manifest $IMAGE_FULL_NAME --arch amd64              -f Dockerfile.$distro       -t "$IMAGE_FULL_NAME"-amd64
		buildah bud --manifest $IMAGE_FULL_NAME --arch arm64 --variant v8 -f Dockerfile.$distro       -t "$IMAGE_FULL_NAME"-arm64
		buildah bud --manifest $IMAGE_FULL_NAME --arch arm   --variant v7 -f Dockerfile.$distro       -t "$IMAGE_FULL_NAME"-armv7
		buildah bud --manifest $IMAGE_FULL_NAME --arch arm   --variant v5 -f Dockerfile.$distro.armel -t "$IMAGE_FULL_NAME"-armv5

		# Push manifest
		buildah manifest push --all --format=docker "containers-storage:${IMAGE_FULL_NAME}" "docker://${IMAGE_FULL_NAME}"

		# Push tags for specific architectures (workaround docker registry bug)
		for arch in amd64 arm64 armv7 armv5; do
			buildah push "${IMAGE_FULL_NAME}-${arch}"
		done
	fi
done
