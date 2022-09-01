FROM docker.io/library/eclipse-temurin:11.0.12_7-jdk

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y unzip && rm -rf /var/cache/apt/*

WORKDIR /tools

ADD https://github.com/checkstyle/checkstyle/releases/download/checkstyle-8.30/checkstyle-8.30-all.jar checkstyle.jar
ADD https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.27.0/pmd-bin-6.27.0.zip pmd-bin-6.27.0.zip

RUN unzip pmd-bin-6.27.0.zip && rm pmd-bin-6.27.0.zip && mv pmd-bin-6.27.0 pmd
