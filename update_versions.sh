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


docker_version quay.io/buildah/stable > buildah-builder/BUILDAH.version

github_tag flutter/flutter > flutter-sdk/FLUTTER.version

docker_version docker.io/library/golang > golang/GO.version

netsplit_repo_version selfcontained hugo amd64 > hugo-pandoc/HUGO.version
#github_version gohugoio/hugo > hugo-pandoc/HUGO.version
#cp hugo-pandoc/HUGO.version hugo-netlify/HUGO.version

#github_version jgm/pandoc > hugo-pandoc/PANDOC.version
netsplit_repo_version selfcontained pandoc amd64 > hugo-pandoc/PANDOC.version
#github_version plantuml/plantuml > hugo-pandoc/PLANTUML.version
netsplit_repo_version selfcontained plantuml all > hugo-pandoc/PLANTUML.version

docker_version docker.io/openapitools/openapi-generator-cli > openapi/OPENAPI.version

github_version amacneil/dbmate > postgres-dbmate/DBMATE.version
docker_version docker.io/library/postgres > postgres-dbmate/POSTGRES.version
