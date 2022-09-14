#!/usr/bin/env bash
set -xeou pipefail

docker_version() {
    skopeo inspect "docker://$1" | jq -r ".RepoTags | .[]" | grep -E '^v?[0-9\.]+$' | tr -d 'v' | grep -vE 'pre$' | sort -V | tail -n 1
}

github_version() {
    curl -s "https://api.github.com/repos/$1/releases/latest" | jq -r ".tag_name" | tr -d 'v'
}

github_tag() {
    curl -s "https://api.github.com/repos/$1/git/refs/tags" | jq -r ".[].ref" | sed 's/^refs\/tags\///' | tr -d 'v' | grep -vE 'pre$' | tail -n 1
}

docker_version docker.io/library/adminer > adminer/ADMINER.version

docker_version quay.io/argoproj/argocd > argocd/ARGOCD.version
github_version mozilla/sops > argocd/SOPS.version
github_version jkroepke/helm-secrets > argocd/HELM_SECRETS.version
# github_version kubernetes/kubectl > argocd/KUBECTL.version

docker_version quay.io/buildah/stable > buildah-builder/BUILDAH.version

github_tag flutter/flutter > flutter-sdk/FLUTTER.version

docker_version docker.io/library/golang > go-tensorflow-lite/GO.version
cp go-tensorflow-lite/GO.version golang/GO.version

github_version gohugoio/hugo > hugo-netlify/HUGO.version

cp hugo-netlify/HUGO.version hugo-pandoc/HUGO.version
github_version jgm/pandoc > hugo-pandoc/PANDOC.version
github_version plantuml/plantuml > hugo-pandoc/PLANTUML.version

github_version amacneil/dbmate > mariadb-dbmate/DBMATE.version
docker_version docker.io/library/mariadb > mariadb-dbmate/MARIADB.version

docker_version docker.io/openapitools/openapi-generator-cli > openapi/OPENAPI.version

cp mariadb-dbmate/DBMATE.version postgres-dbmate/DBMATE.version
docker_version docker.io/library/postgres > postgres-dbmate/POSTGRES.version
