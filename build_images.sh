#!/usr/bin/env bash
set -o pipefail

cd "$(dirname "$0")"

. vars.sh


if ! command -v skopeo; then
    echo "Skopeo command is missing"
    exit 1
fi

IMAGES="android-lint android-sdk aria2c aria2c-webui buildah-builder eslint ffvnc flutter-sdk golang mediamtx openapi platformio postgres-dbmate qbittorrent rsyslog"

if [ "$1" != "" ]; then
    IMAGES="$1"
fi

for tag in $IMAGES; do
    cd "$tag"
    VERSION=$(make version)
    if ! skopeo inspect "docker://$BASEURL/$tag:$VERSION" > /dev/null 2>&1; then
        # Image does not exists
        set -e
        IMAGE_PATH="$BASEURL/$tag" make docker push
        set +e
    fi

    # Mirror container in Docker Hub
    if ! skopeo inspect "docker://$DOCKERHUB_BASEURL/$tag:$VERSION" > /dev/null 2>&1; then
        set -e
        buildah manifest push --all --format=docker "$BASEURL/$tag:$VERSION" "docker://$DOCKERHUB_BASEURL/$tag:$VERSION"
        set +e
    fi
    cd ..
done
