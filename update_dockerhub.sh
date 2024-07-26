#!/usr/bin/env bash
set -xeou pipefail

. vars.sh

# This script updates the description for each page on DockerHub

for tag in $IMAGES; do
    podman run -it --rm --user 0 \
        -v "${XDG_RUNTIME_DIR:-/var/tmp/containers-user-$UID/containers}/containers/auth.json:/config.json:ro" \
        -v "$(pwd):/src/:ro" \
        docker.io/chko/docker-pushrm "docker.io/enrico204/$tag" -f /src/README.md --config /config.json
done
