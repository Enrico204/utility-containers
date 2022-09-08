#!/usr/bin/env bash
set -o pipefail

export BASEURL="hub.netsplit.it/utilities"
export DOCKERHUB_BASEURL="docker.io/enrico204"

command -v skopeo
if [ $? -ne 0 ]; then
    echo "Skopeo command is missing"
    exit 1
fi

for tag in adminer android-lint android-sdk argocd eslint ffvnc flutter-sdk go-tensorflow-lite golang hugo-netlify hugo-pandoc mariadb-dbmate openapi platformio postgres-dbmate qbittorrent; do
    cd "$tag"
    VERSION=$(make version)
    skopeo inspect "docker://$BASEURL/$tag:$VERSION" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        # Image does not exists
        set -e
        IMAGE_PATH="$BASEURL/$tag" make docker push
        set +e
    fi

    # Mirror container in Docker Hub
    skopeo inspect "docker://$DOCKERHUB_BASEURL/$tag:$VERSION" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        set -e
        buildah manifest push --all --format=docker "$BASEURL/$tag:$VERSION" "docker://$DOCKERHUB_BASEURL/$tag:$VERSION"
        set +e
    fi
    cd ..
done

# Debian builders
cd debian-builder
bash build.sh
cd ..
