#!/usr/bin/env bash
set -xeou pipefail

. vars.sh

# This script updates the description for each page on DockerHub

for image in $IMAGES; do
    cd "$image"
    VERSION=$(make version)
    
    if ! skopeo inspect "docker://$DOCKERHUB_BASEURL/$image:$VERSION" > /dev/null 2>&1; then
        skopeo copy -a "docker://$BASEURL/$image:$VERSION" "docker://$DOCKERHUB_BASEURL/$image:$VERSION"
    fi

    podman run -it --rm --user 0 \
        -v "${XDG_RUNTIME_DIR:-/var/tmp/containers-user-$UID/containers}/containers/auth.json:/config.json:ro" \
        -v "$(pwd)/../:/src/:ro" \
        docker.io/chko/docker-pushrm "$DOCKERHUB_BASEURL/$image" -f /src/README.md --config /config.json
    
    cd ..
done
