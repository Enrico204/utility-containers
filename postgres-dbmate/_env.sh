POSTGRES_VERSION=$(cat POSTGRES.version)
DBMATE_VERSION=$(cat DBMATE.version)
VERSION=${POSTGRES_VERSION}-${DBMATE_VERSION}-1

BUILDAH_ARGS="--build-arg POSTGRES_VERSION=${POSTGRES_VERSION} --build-arg DBMATE_VERSION=${DBMATE_VERSION}"