#!/usr/bin/env bash
set -eou pipefail

# This script generates the workflow for the Gitea pipeline dinamically, to
# have one job per container.

cat > images.yaml <<EOF
name: BuildImages
on:
  push:
    branches:
      - master

jobs:
EOF

for img in "aria2c aria2c-webui" asterisk buildah-builder dmarc-analyzer dnsmasq eslint ffvnc golang mediamtx node-red novnc openapi platformio postgres-dbmate qbittorrent rsyslog; do
cat >> images.yaml <<EOF

  ${img/ /-}:
    runs-on: host-linux-amd64
    container:
      volumes:
        - /var/lib/gitea-act-runner/.cache/:/var/lib/gitea-act-runner/.cache/
    steps:
      - name: Checking out the repository
        uses: https://git.netsplit.it/actions/git-clone@v2
        with:
          token: \${{ github.token }}
      - name: Login into registries
        run: |
          buildah login -u \${{ secrets.NETSPLIT_REGISTRY_USER }} -p \${{ secrets.NETSPLIT_REGISTRY_PASS }} hub.netsplit.it
          buildah login -u \${{ secrets.DOCKER_REGISTRY_USER }} -p \${{ secrets.DOCKER_REGISTRY_PASS }} registry-1.docker.io
      - name: Build images
        run: >
          podman run -it --rm --privileged
          -v "\$(pwd):/src/"
          -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro
          --workdir /src/
          hub.netsplit.it/utilities/buildah-builder:1.36.0-2
          /bin/bash -x build_images.sh "$img"
      - name: Logout from registries
        run: |
          buildah logout registry-1.docker.io
          buildah logout hub.netsplit.it
        if: always()

EOF
done
