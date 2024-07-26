This repository contains customized container images.

Public repository available at: https://gitlab.com/Enrico204/utility-containers

Short description of images:
* `aria2c` and `aria2c-webui`: the `aria2c` downloader as server with a web ui
* `asterisk`: an image for asterisk with the g729 codec bundled
* `buildah-builder`: an image that I use as build env for this repo; derived
  from `quay.io/buildah/stable`
* `debian-builder`: base images for DKMS builds, used for my personal Debian
  repository
* `dnsmasq`: Alpine container with dnsmasq only
* `eslint`: ESLint in a Node LTS container
* `ffvnc`: a X11 VNC server with full-screen Firefox (useful for remote
  displays, etc)
* `golang`: Go container image for CI/CD builds, with `ca-certificates` (with the
  addition of the Apple certificate for push servers) and `tzdata`, `jq`,
  `curl`, `go-mod-outdated`, `golangci-lint` and `go-licenses`.
* `mediamtx`: mediamtx software in a container
* `node-red`: Debian-based image with Node-RED and `iputils-ping`
* `openapi`: OpenAPI Generator based image with `git` and `make` added for CI/CD
* `platformio`: Platformio with `espressif8266`, `espressif32` and `raspberrypi` board packages ready for CI/CD
* `postgres-dbmate`: PostgreSQL container image bundled with `dbmate`
* `qbittorrent`: QBitTorrent container image (no X11, only web UI)
* `rsyslog`: simple rsyslog running in a container
* `vscode-server-ipython`: `codercom/code-server` image extended with Python, Go, Java, and IPython/Notebook (also with VSCode plugins), and GitLens and Rainbow CSV as VSCode plugins, plus some Go linters such as `golangci-run`.

All images are also published pre-built in Docker Hub under <https://hub.docker.com/u/enrico204>.

### Build everything using buildah-builder

```sh
podman run -it --rm --privileged \
  -v "$(pwd):/src/" \
  -v "${XDG_RUNTIME_DIR}/containers/auth.json:/etc/containers/auth.json:ro" \
  -v "$HOME/.docker/config.json:/root/.docker/config.json:ro" \
  -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro \
  -e "REGISTRY_AUTH_FILE=/etc/containers/auth.json" \
  --workdir /src/ \
  hub.netsplit.it/utilities/buildah-builder:1.36.0-2 \
  /bin/bash -x /src/build_images.sh
```

Use docker-login credentials only:

```sh
podman run -it --rm --privileged \
  -v "$(pwd):/src/" \
  -v "$HOME/.docker/config.json:/root/.docker/config.json:ro" \
  -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro \
  --workdir /src/ \
  hub.netsplit.it/utilities/buildah-builder:1.36.0-2 \
  /bin/bash -x /src/build_images.sh
```
