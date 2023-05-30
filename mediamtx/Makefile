VERSION=1

docker:
	docker build --build-arg VERSION=${VERSION} -f Dockerfile -t ${IMAGE_PATH}:${VERSION} .

push:
	docker push ${IMAGE_PATH}:${VERSION}

version:
	@echo ${VERSION}

inspect:
	docker inspect ${IMAGE_PATH}:${VERSION}
