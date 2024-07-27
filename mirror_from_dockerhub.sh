#!/usr/bin/env bash
set -eou pipefail

mirror_image_to_netsplit() {
    local IMAGE_SRC="$1"
    local IMAGE_DST="${IMAGE_SRC/docker.io/hub.netsplit.it}"
    IMAGE_DST="${IMAGE_DST/enrico204/utilities}"

    skopeo inspect --raw "$IMAGE_SRC" > /tmp/image-manifest.json
    MANIFEST_TYPE=$(cat /tmp/image-manifest.json | jq -r ".mediaType")

    skopeo copy -a "$IMAGE_SRC" "$IMAGE_DST"

    # If it is a multi-arch image, create a tag for each image layer to work around the registry bug
    if [ "$MANIFEST_TYPE" == "application/vnd.docker.distribution.manifest.list.v2+json" ]; then
        for arch in $(cat /tmp/manifest.json | jq -r '.manifests | .[].platform | select(.os=="linux").architecture'); do
            for variant in $(cat /tmp/manifest.json | jq -r ".manifests | .[].platform | select(.architecture==\"$arch\") | .variant"); do
                if [ "$variant" == "null" ]; then
                    skopeo copy --override-arch "$arch" "$IMAGE_SRC" "${IMAGE_DST}-$arch"
                else
                    skopeo copy --override-arch "$arch" --override-variant "$variant" "$IMAGE_SRC" "${IMAGE_DST}-$arch-$variant"
                fi
            done
        done
    fi
}


mirror_image_to_netsplit docker://docker.io/ibmdevxsdk/openapi-validator:1.19.2
mirror_image_to_netsplit docker://docker.io/hadolint/hadolint:v2.12.0-debian
mirror_image_to_netsplit docker://docker.io/library/debian:12.6
mirror_image_to_netsplit docker://docker.io/library/debian:12.6-slim
