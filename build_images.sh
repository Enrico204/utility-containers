#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")"

. vars.sh


if ! command -v skopeo; then
    echo "Skopeo command is missing"
    exit 1
fi

if [ "$1" != "" ]; then
    IMAGES="$1"
fi

for tag in $IMAGES; do
    cd "$tag"
    VERSION=$(make version)

    # Check whether images exists locally or in Netsplit Hub
    LOCAL_EXISTS=1
    HUB_EXISTS=1

    set +e
    if ! buildah manifest inspect "containers-storage:$BASEURL/$tag:$VERSION" > /dev/null 2>&1; then
        LOCAL_EXISTS=0
    fi

    if ! skopeo inspect "docker://$BASEURL/$tag:$VERSION" > /dev/null 2>&1; then
        HUB_EXISTS=0
    fi
    set -e
    
    if [ $HUB_EXISTS -eq 0 ]; then
        if [ $LOCAL_EXISTS -eq 0 ]; then
            # Image does not exists locally, build it
            IMAGE_PATH="$BASEURL/$tag" make docker
        fi

        # and then push it
        buildah manifest push --all --format=docker "$BASEURL/$tag:$VERSION" "docker://$BASEURL/$tag:$VERSION"
    fi

    cd ..
done
