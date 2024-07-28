#!/usr/bin/env bash
set -eou pipefail

mirror_image_to_netsplit() {
    local IMAGE_SRC="$1"
    local IMAGE_DST="${IMAGE_SRC/docker.io/hub.netsplit.it}"
    IMAGE_DST="${IMAGE_DST/enrico204/utilities}"

    skopeo copy -a "$IMAGE_SRC" "$IMAGE_DST"
}


mirror_image_to_netsplit docker://docker.io/ibmdevxsdk/openapi-validator:1.19.2
mirror_image_to_netsplit docker://docker.io/hadolint/hadolint:v2.12.0-debian
mirror_image_to_netsplit docker://docker.io/library/debian:bookworm
mirror_image_to_netsplit docker://docker.io/library/debian:bookworm-slim
mirror_image_to_netsplit docker://docker.io/library/debian:bookworm-backports
