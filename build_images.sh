#!/usr/bin/env bash
set -eo pipefail

export BASEURL="hub.netsplit.it/utilities"
export DOCKERHUB_BASEURL="docker.io/enrico204"

command -v skopeo
if [ $? -ne 0 ]; then
    echo "Skopeo command is missing"
    exit 1
fi

#for tag in android-lint android-sdk argocd eslint ffvnc flutter-sdk golang hugo-netlify mariadb-dbmate platformio postgres-dbmate qbittorrent; do
for tag in golang hugo-netlify mariadb-dbmate openapi platformio postgres-dbmate qbittorrent; do
    pushd "$tag"
    VERSION=$(make version)
    set +e
    skopeo inspect "docker://$BASEURL/$tag:$VERSION" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        set -e
        # Image does not exists
        IMAGE_PATH="$BASEURL/$tag" make docker push
    fi
    set -e

    # Mirror container in Docker Hub
    set +e
    skopeo inspect "docker://$DOCKERHUB_BASEURL/$tag:$VERSION" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        set -e
        skopeo copy --all "docker://$BASEURL/$tag:$VERSION" "docker://$DOCKERHUB_BASEURL/$tag:$VERSION"
    fi
    set -e
    popd
done
