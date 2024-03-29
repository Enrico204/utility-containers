This repository contains customized container images.

Public repository available at: https://gitlab.com/Enrico204/utility-containers

Short description of images:
* `adminer`: a version which uses `php-fpm` and `lighttpd`
* `android-lint`: Android/Java linters
* `android-sdk`: Android SDK
* `argocd`: ArgoCD with these additional tools: `envsubst`, `sops`,
  `kubectl`, and Helm secrets plugin for helm.
* `buildah-builder`: an image that I use as build env for this repo; derived
  from `quay.io/buildah/stable`
* `debian-builder`: base images for DKMS builds, used for my personal Debian
  repository
* `eslint`: ESLint in a Node LTS container
* `ffvnc`: a X11 VNC server with full-screen Firefox (useful for remote
  displays, etc)
* `flutter-sdk`: Flutter SDK
* `go-tensorflow-lite`: Go compiler with tensorflow headers and shared objects.
  See the specific `README.md` for more info.
* `golang`: Go container images with default `ca-certificates` (with the
  addition of the Apple certificate for push servers) and `tzdata`, `jq`,
  `curl`, `go-mod-outdated`, `golangci-lint` and `go-licenses`.
* `hugo-netlify`: GoHugo, netlify-cli and MinIO/S3 `mc` client
* `hugo-pandoc`: GoHugo + pandoc (with full TeXLive)
* `mariadb-dbmate`: MariaDB container image bundled with `dbmate`
* `openapi`: `openapitools/openapi-generator-cli` + `git` and `make`
* `platformio`: PlatformIO + `espressif8266` package
* `postgres-dbmate`: Postgres container image bundled with `dbmate`
* `qbittorrent`: QBitTorrent container image (no X11, only web UI)

All images are also published pre-built in Docker Hub, e.g.
`hub.docker.com/enrico204/adminer`.

### Build everything using buildah-builder

```sh
podman run -it --rm --privileged \
  -v "$(pwd):/src/" \
  -v "${XDG_RUNTIME_DIR}/containers/auth.json:/etc/containers/auth.json:ro" \
  -v "$HOME/.docker/config.json:/root/.docker/config.json:ro" \
  -e "REGISTRY_AUTH_FILE=/etc/containers/auth.json" \
  --workdir /src/ \
  hub.netsplit.it/utilities/buildah-builder:1.31.0-2 \
  /bin/bash -x /src/build_images.sh
```

Use docker-login credentials only:

```sh
podman run -it --rm --privileged \
  -v "$(pwd):/src/" \
  -v "$HOME/.docker/config.json:/root/.docker/config.json:ro" \
  --workdir /src/ \
  hub.netsplit.it/utilities/buildah-builder:1.31.0-2 \
  /bin/bash -x /src/build_images.sh
```
