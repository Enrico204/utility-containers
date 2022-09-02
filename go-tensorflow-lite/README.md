# go-tensorflow-lite

This directory contains the Dockerfile and commands to build the
[go-tensorflow-lite image](https://hub.docker.com/r/enrico204/go-tensorflow-lite).
The image contains the Go compiler and Tensorflow lite headers and library
(shared object).

**Note that these images are based on Debian Buster** because of a GCC 10 bug
on ARM: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101723

To use this image, you can reference it in place of the Go standard image,
like:

```Dockerfile
FROM docker.io/enrico204/go-tensorflow-lite:<tag>
```

Or you can use it directly:

```sh
docker run -it --rm enrico204/go-tensorflow-lite:<tag>
# or Podman
podman run -it --rm docker.io/enrico204/go-tensorflow-lite:<tag>
```

## Architectures

Images are available for these platforms:

* `amd64`
* `arm/v7`
* `arm64`
