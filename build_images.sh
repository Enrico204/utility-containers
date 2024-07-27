#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")"

source vars.sh


if ! command -v skopeo > /dev/null; then
    echo "skopeo command is missing"
    exit 1
fi

if ! command -v buildah > /dev/null; then
    echo "buildah command is missing"
    exit 1
fi

if [ "${1:-}" != "" ]; then
    IMAGES="${1:-}"
fi

IMAGES=($IMAGES)
for image in "${IMAGES[@]}"; do
    cd "$image"

    VERSION=""
    BUILDAH_ARGS=""
    ARCHITECTURES="amd64"

    source _env.sh
    ARCHITECTURES=($ARCHITECTURES)

    if [ "$VERSION" == "" ]; then
        echo "$image: No VERSION specified, skipping"
        cd ..
        continue
    fi

    IMAGE_FULL_NAME="${BASEURL}/${image}:${VERSION}"

    # Check whether images exists locally or in Netsplit Hub
    LOCAL_EXISTS=1
    HUB_EXISTS=1

    set +e
    if ! buildah inspect "containers-storage:$IMAGE_FULL_NAME" > /dev/null 2>&1; then
        LOCAL_EXISTS=0
    fi

    if ! skopeo inspect "docker://$IMAGE_FULL_NAME" > /dev/null 2>&1; then
        HUB_EXISTS=0
    fi
    set -e
    
    if [ "$HUB_EXISTS" -eq 0 ]; then
        if [ "$LOCAL_EXISTS" -eq 0 ]; then
            # Image does not exists locally and remotely, build it
            buildah manifest create "$IMAGE_FULL_NAME"

            for arch in "${ARCHITECTURES[@]}"; do
                if [ "$arch" == "amd64" ]; then
                    buildah bud -f Dockerfile --manifest "$IMAGE_FULL_NAME" --arch amd64              -t "$IMAGE_FULL_NAME"-amd64 $BUILDAH_ARGS
                elif [ "$arch" == "arm64" ]; then
                    buildah bud -f Dockerfile --manifest "$IMAGE_FULL_NAME" --arch arm64 --variant v8 -t "$IMAGE_FULL_NAME"-arm64 $BUILDAH_ARGS
                elif [ "$arch" == "armv7" ]; then
                    buildah bud -f Dockerfile --manifest "$IMAGE_FULL_NAME" --arch arm   --variant v7 -t "$IMAGE_FULL_NAME"-armv7 $BUILDAH_ARGS
                elif [ "$arch" == "armel" ]; then
                    buildah bud -f Dockerfile --manifest "$IMAGE_FULL_NAME" --arch arm   --variant v5 -t "$IMAGE_FULL_NAME"-armv5 $BUILDAH_ARGS
                else
                    echo "$image: Wrong platform $arch"
                    exit 1
                fi
            done
        fi

        if [ "${#ARCHITECTURES[@]}" -eq 1 ]; then
            # No manifest needed (one arch only), push only the image
            set +e
            buildah manifest rm containers-storage:"$IMAGE_FULL_NAME" > /dev/null 2>&1 || true
            set -e
            buildah tag "${IMAGE_FULL_NAME}-$ARCHITECTURES" "$IMAGE_FULL_NAME"
            buildah push "$IMAGE_FULL_NAME"
        else
            # Push manifest
            buildah manifest push --all --format=docker "containers-storage:${IMAGE_FULL_NAME}" "docker://${IMAGE_FULL_NAME}"

            # Push tags for specific architectures (workaround docker registry bug)
            for arch in "${ARCHITECTURES[@]}"; do
                buildah push "${IMAGE_FULL_NAME}-${arch}"
            done
        fi
    fi

    cd ..
done
