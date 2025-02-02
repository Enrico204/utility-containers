#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")"

. ../../vars.sh

# This script generates the workflow for the Gitea pipeline dinamically, to
# have one job per container.

cat > images.yaml <<EOF
name: BuildImages
on:
#  push:
#    branches:
#      - master
  workflow_dispatch:

jobs:
EOF

for img in $IMAGES; do
cat >> images.yaml <<EOF

  ${img}:
    runs-on: privileged
    container:
      image: hub.netsplit.it/utilities/buildah-builder:1.37.3-3
      credentials:
        username: \${{ secrets.NETSPLIT_REGISTRY_USER }}
        password: \${{ secrets.NETSPLIT_REGISTRY_PASS }}
      #volumes:
      #  - /var/lib/gitea-act-runner/.cache/:/var/lib/gitea-act-runner/.cache/
    steps:
      - name: Checking out the repository
        run: |
          echo "Cloning the repository"
          git init
          git remote add origin "https://git:\${{ github.token }}@git.netsplit.it/\${GITHUB_REPOSITORY}"
          git fetch --depth 1 origin "\$GITHUB_SHA"
          git checkout FETCH_HEAD

      - name: Set credentials for registries
        run: |
          mkdir -p "\$HOME/.docker/"
          export REGISTRY_AUTH_FILE=\$HOME/.docker/auth.json

          export NETSPLIT_CREDS=\$(echo -n '\${{ secrets.NETSPLIT_REGISTRY_USER }}:\${{ secrets.NETSPLIT_REGISTRY_PASS }}' | base64 -w 0)
          export DOCKER_CREDS=\$(echo -n '\${{ secrets.DOCKER_REGISTRY_USER }}:\${{ secrets.DOCKER_REGISTRY_PASS }}' | base64 -w 0)
          printf '{"auths": {"hub.netsplit.it": {"auth": "%s"}, "docker.io": {"auth": "%s"}}}' "\$NETSPLIT_CREDS" "\$DOCKER_CREDS" > "\$HOME/.docker/auth.json"
          printf "REGISTRY_AUTH_FILE=\$REGISTRY_AUTH_FILE" >> \$GITHUB_ENV

      - name: Build and push image
        run: /bin/bash -x build_images.sh "$img"
#        run: >
#          podman run -it --rm --privileged
#          -v "\$(pwd):/src/"
#          -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro
#          -v "\$HOME/.docker/auth.json:/auth.json:ro"
#          -e REGISTRY_AUTH_FILE=/auth.json
#          --workdir /src/
#          hub.netsplit.it/utilities/buildah-builder:1.36.0-2
#          /bin/bash -x build_images.sh "$img"

      - name: Cleanup
        run: |
          rm -f "\$REGISTRY_AUTH_FILE"
        if: always()

EOF
done

# TODO: sync dockerhub

# cat >> images.yaml <<EOF

#   update-dockerhub-descriptions:
#     runs-on: host-linux-amd64
#     needs: [${IMAGES// /, }]
#     container:
#       volumes:
#         - /var/lib/gitea-act-runner/.cache/:/var/lib/gitea-act-runner/.cache/
#     steps:
#       - name: Checking out the repository
#         uses: https://git.netsplit.it/actions/git-clone@v2
#         with:
#           token: \${{ github.token }}
#       - name: Set credentials for registries
#         run: |
#           export NETSPLIT_CREDS=\$(echo '\${{ secrets.NETSPLIT_REGISTRY_USER }}:\${{ secrets.NETSPLIT_REGISTRY_PASS }}' | base64 -w 0)
#           export DOCKER_CREDS=\$(echo '\${{ secrets.DOCKER_REGISTRY_USER }}:\${{ secrets.DOCKER_REGISTRY_PASS }}' | base64 -w 0)
#           printf '{"auths": {"hub.netsplit.it": {"auth": "%s"}, "https://index.docker.io/v1/": {"auth": "%s"}}}' "\$NETSPLIT_CREDS" "\$DOCKER_CREDS" > "\${XDG_RUNTIME_DIR:-/var/tmp/containers-user-\$UID/containers}/containers/auth.json"
#       - name: Update repository descriptions
#         run: bash update_dockerhub.sh

# EOF
