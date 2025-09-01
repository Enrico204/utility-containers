#!/usr/bin/env bash
set -xeou pipefail

# This script updates versions of source images or tools in each container
# directory

docker_version() {
    skopeo inspect "docker://$1" | jq -r ".RepoTags | .[]" | grep -E '^v?[0-9\.]+$' | tr -d 'v' | grep -vE 'pre$' | sort -V | tail -n 1
}

github_version() {
    curl -s "https://api.github.com/repos/$1/releases/latest" | jq -r ".tag_name" | tr -d 'v'
}

github_tag() {
    curl -s "https://api.github.com/repos/$1/git/refs/tags" | jq -r ".[].ref" | sed 's/^refs\/tags\///' | tr -d 'v' | grep -vE 'pre$' | tail -n 1
}

netsplit_repo_version() {
    curl -s "https://deb.netsplit.it/$1/Packages" | grep -A5 "Package: $2" | awk -v arch="$3" -v pkgarch="" '
/^Architecture:/ { pkgarch = $2 }
/^Version:/ { if (pkgarch == arch) print $2; pkgarch = "" }
' | grep -vE '^$' | sort -V | tail -n 1
}

alpine_repo_version() {
	VERSION=$1
	PACKAGE=$2
	#curl -s "https://git.alpinelinux.org/aports/plain/main/${PACKAGE}/APKBUILD?h=${VERSION}-stable" | grep -E 'pkgver=|pkgrel=' | cut -f 2 -d = | tr '\n' ' ' | sed 's/ /-r/' | tr -d ' '
	curl -s "https://gitlab.alpinelinux.org/alpine/aports/-/raw/${VERSION}-stable/main/${PACKAGE}/APKBUILD" | grep -E 'pkgver=|pkgrel=' | cut -f 2 -d = | tr '\n' ' ' | sed 's/ /-r/' | tr -d ' '
}


docker_version quay.io/buildah/stable > buildah-builder/BUILDAH.version

# github_tag flutter/flutter > flutter-sdk/FLUTTER.version

docker_version docker.io/library/golang > golang/GO.version
cp golang/GO.version vscode-server-ipython/GO.version

docker_version docker.io/nodered/node-red > node-red/NODE-RED.version

skopeo inspect "docker://docker.io/codercom/code-server" | jq -r ".RepoTags | .[]" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1 > vscode-server-ipython/VSCODE.version

netsplit_repo_version selfcontained hugo amd64 > hugo/HUGO.version
# netsplit_repo_version selfcontained pandoc amd64 > hugo-pandoc/PANDOC.version
# netsplit_repo_version selfcontained plantuml all > hugo-pandoc/PLANTUML.version

#github_version bluenviron/mediamtx > mediamtx/MEDIAMTX.version

github_version amacneil/dbmate > postgres-dbmate/DBMATE.version
docker_version docker.io/library/postgres > postgres-dbmate/POSTGRES.version

github_version aptible/supercronic > dmarc-analyzer/SUPERCRONIC.version

docker_version ghcr.io/eclipse-theia/theia-blueprint/theia-ide > theia-server-ipython/THEIA.version

cd asterisk
source _env.sh
alpine_repo_version ${ALPINE_VERSION} asterisk > ASTERISK.version
#podman run -it --rm \
#    docker.io/library/alpine:${ALPINE_VERSION} \
#    /bin/sh -c "apk update > /dev/null && apk info asterisk | head -n 1 | cut -f 1 -d ' ' | cut -f 2- -d -" \
#    > ASTERISK.version
cd ..

github_tag lucaslorentz/caddy-docker-proxy > caddy-docker/CADDY-DOCKER.version
github_tag caddyserver/caddy > caddy-docker/CADDY.version

