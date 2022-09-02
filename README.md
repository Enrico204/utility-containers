This repository contains customized container images.

Short description of content:
* `adminer`: a version which uses `php-fpm` and `lighttpd`
* `android-lint`: Android/Java linters
* `android-sdk`: Android SDK
* `argocd`: ArgoCD with these additional tools: `envsubst`, `sops`,
  `kubectl`, and Helm secrets plugin for helm.
* `eslint`: ESLint in a Node LTS container
* `ffvnc`: a X11 VNC server with full-screen Firefox (useful for remote
  displays, etc)
* `flutter-sdk`: Flutter SDK
* `golang`: Go container images with UPX, default `ca-certificates` (with the
  addition of the Apple certificate for push servers) and `tzdata`, `jq`,
  `curl`, `go-mod-outdated`, `golangci-lint` and `go-licenses`.
* `hugo-netlify`: GoHugo, netlify-cli and MinIO/S3 `mc` client
* `mariadb-dbmate`: MariaDB container image bundled with `dbmate`
* `openapi`: `openapitools/openapi-generator-cli` + `git` and `make`
* `platformio`: PlatformIO + `espressif8266` package
* `postgres-dbmate`: Postgres container image bundled with `dbmate`
* `qbittorrent`: QBitTorrent container image (no X11, only web UI)
* `go-tensorflow-lite`: Go compiler with tensorflow headers and shared objects.
  See the specific `README.md` for more info.

All images are also published pre-built in Docker Hub, e.g.
`hub.docker.com/enrico204/adminer`.
