ARG POSTGRES_VERSION
ARG DBMATE_VERSION
FROM docker.io/amacneil/dbmate:${DBMATE_VERSION} AS dbmate

FROM docker.io/library/postgres:${POSTGRES_VERSION}

COPY --from=dbmate /usr/local/bin/dbmate /usr/local/bin/dbmate
