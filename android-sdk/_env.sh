CMDLINE_TOOLS=10406996
BUILD_TOOLS=34.0.0
ANDROID_SDK=33
TEMURIN_VERSION=17.0.12_7-jdk
VERSION="cmd${CMDLINE_TOOLS}-tools${BUILD_TOOLS}-sdk${ANDROID_SDK}-java${TEMURIN_VERSION}-1"

BUILDAH_ARGS="--build-arg BUILD_TOOLS=${BUILD_TOOLS} --build-arg CMDLINE_TOOLS=${CMDLINE_TOOLS} --build-arg ANDROID_SDK=${ANDROID_SDK} --build-arg TEMURIN_VERSION=${TEMURIN_VERSION}"
