#!/usr/bin/env bash
set -xeou pipefail

# This script updates the description for each page on DockerHub

for tag in adminer android-lint android-sdk argocd buildah-builder eslint ffvnc flutter-sdk go-tensorflow-lite golang hugo-netlify hugo-pandoc mariadb-dbmate openapi platformio postgres-dbmate qbittorrent mediamtx; do
    podman run -it --rm --user 0 \
        -v "$HOME/.docker/config.json:/config.json:ro" \
        -v "$(pwd):/src/:ro" \
        chko/docker-pushrm "docker.io/enrico204/$tag" -f /src/README.md --config /config.json
done
